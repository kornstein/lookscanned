//! Paper damage: folds, dog-ear, staple, paperclip trace and torn edge.

use crate::encode::Img;
use crate::params::Params;
use crate::rng::{Rng, fbm, smoothstep};

/// Scanner lid, seen where the paper is missing.
const LID: [f32; 3] = [0.96, 0.96, 0.95];
const RUST: [f32; 3] = [0.45, 0.3, 0.18];

/// Page-sized RGBA layer; every feature only paints its own box.
pub fn damage(p: &Params) -> Img {
    let (w, h, seed) = (p.px("w", 64), p.px("h", 64), p.seed());
    let ppmm = p.num("ppmm", 1.0);
    let paper = p.color("paper", [1.0, 1.0, 1.0]).map(|c| c as f32);
    let mut d = Damage { img: Img::new(w, h, 4), ppmm, rng: Rng::new(seed), seed };
    let folds = p.num("folds", 0.0).max(0.0) as usize;
    for k in 1..=folds {
        d.fold(k as f64 / (folds + 1) as f64);
    }
    if p.bool("paperclip") {
        d.paperclip();
    }
    if p.bool("staple") {
        d.staple();
    }
    if p.bool("torn") {
        d.torn();
    }
    if p.bool("dog-ear") {
        d.dog_ear(paper);
    }
    d.img
}

struct Damage {
    img: Img,
    ppmm: f64,
    rng: Rng,
    seed: u64,
}

impl Damage {
    fn wm(&self) -> f64 {
        self.img.w as f64 / self.ppmm
    }

    fn hm(&self) -> f64 {
        self.img.h as f64 / self.ppmm
    }

    /// Calls `f(x_mm, y_mm)` over a box in mm, and paints the colour it returns.
    fn paint(&mut self, x0: f64, y0: f64, x1: f64, y1: f64, f: impl Fn(f64, f64) -> Option<([f32; 3], f64)>) {
        let px = |v: f64, max: u32| (v * self.ppmm).clamp(0.0, max as f64) as u32;
        let (xa, xb) = (px(x0, self.img.w), px(x1, self.img.w));
        let (ya, yb) = (px(y0, self.img.h), px(y1, self.img.h));
        for y in ya..yb {
            for x in xa..xb {
                let (xm, ym) = ((x as f64 + 0.5) / self.ppmm, (y as f64 + 0.5) / self.ppmm);
                if let Some((c, a)) = f(xm, ym) {
                    self.img.blend_rgb(x as i64, y as i64, c, a as f32);
                }
            }
        }
    }

    /// Horizontal crease at `t` of the height: shadow on one side, highlight on the other.
    fn fold(&mut self, t: f64) {
        let (wm, hm, seed) = (self.wm(), self.hm(), self.seed ^ self.rng.next_u64());
        let y0 = hm * t + self.rng.range(-2.0, 2.0);
        let slope = self.rng.range(-0.006, 0.006);
        let crease = move |x: f64| y0 + slope * (x - wm / 2.0) + 0.6 * (fbm(seed, x / 30.0, 0.0, 3) - 0.5);
        let strength = move |x: f64| 0.6 + 0.5 * fbm(seed ^ 1, x / 15.0, 3.0, 2);
        self.paint(0.0, y0 - 10.0, wm, y0 + 10.0, |x, y| {
            let d = y - crease(x);
            let s = strength(x);
            let broad = if d > 0.0 { 0.1 * (-d / 5.0).exp() } else { 0.0 };
            let dark = 0.4 * (-((d - 0.15) / 0.22).powi(2)).exp() + broad;
            let light = 0.45 * (-((d + 0.35) / 0.3).powi(2)).exp();
            if dark > light { Some(([0.25; 3], s * dark)) } else { Some(([1.0; 3], s * light)) }
        });
    }

    /// Top-right corner folded over the page.
    fn dog_ear(&mut self, paper: [f32; 3]) {
        let wm = self.wm();
        let (ax, ay) = (self.rng.range(12.0, 22.0), self.rng.range(12.0, 22.0));
        let (a, b) = ((wm - ax, 0.0), (wm, ay));
        let len = (ax * ax + ay * ay).sqrt();
        // Unit normal of the fold, towards the corner.
        let n = (ay / len, -ax / len);
        let back = paper.map(|c| c * 0.94);
        let reach = 2.0 * ax * ay / len + 4.0;
        let aa = 0.5 / self.ppmm;
        self.paint(wm - ax - reach, 0.0, wm, ay + reach, |x, y| {
            let s = (x - a.0) * n.0 + (y - a.1) * n.1;
            let (rx, ry) = (x - 2.0 * s * n.0, y - 2.0 * s * n.1);
            // How far the mirrored point is outside the page: distance to the flap.
            let e = (rx - b.0).max(-ry);
            let fold_shade = 0.1 * (-s.abs() / 2.5).exp() as f32;
            let rim = 0.2 * (1.0 - smoothstep(0.0, 0.35, -e)) as f32;
            let flap = back.map(|c| c * (1.0 - fold_shade - rim));
            let cover = 1.0 - smoothstep(-aa, aa, e);
            let alpha = cover + (1.0 - cover) * 0.28 * (1.0 - smoothstep(0.0, 2.5, e));
            let shade = 0.12 * (-s.max(0.0) / 1.5).exp() as f32;
            let t = smoothstep(-aa, aa, s) as f32;
            let k = cover as f32 * (1.0 - t);
            let a_out = alpha as f32 * (1.0 - t) + t;
            let c = std::array::from_fn(|i| (flap[i] * k + (LID[i] - shade) * t) / a_out.max(1e-6));
            Some((c, a_out as f64))
        });
    }

    /// Staple across the top-left corner.
    fn staple(&mut self) {
        let (cx, cy) = (self.rng.range(11.0, 16.0), self.rng.range(10.0, 15.0));
        let angle = (-45.0 + self.rng.range(-10.0, 10.0)).to_radians();
        let (ca, sa) = (angle.cos(), angle.sin());
        let (half, rad) = (6.0, 0.35);
        let local = move |x: f64, y: f64| {
            let (dx, dy) = (x - cx, y - cy);
            (dx * ca + dy * sa, -dx * sa + dy * ca)
        };
        let sd = move |u: f64, v: f64| {
            let q = ((u.abs() - half).max(0.0), v.abs() - rad);
            (q.0 * q.0 + q.1.max(0.0).powi(2)).sqrt() + q.0.max(q.1).min(0.0)
        };
        let r = half + 3.0;
        self.paint(cx - r, cy - r, cx + r, cy + r, |x, y| {
            let (u, v) = local(x, y);
            let d = sd(u, v);
            let (su, sv) = local(x - 0.35, y - 0.45);
            let shadow = 0.35 * (1.0 - smoothstep(-0.1, 0.5, sd(su, sv)));
            let dent = 0.1 * (-(d.max(0.0)) / 1.2).exp();
            let cover = 1.0 - smoothstep(-0.08, 0.08, d);
            if cover > 0.0 {
                let t = (v / rad).clamp(-1.0, 1.0);
                let g = 0.4 + 0.35 * (1.0 - t * t) + 0.2 * (-((t + 0.3) / 0.25).powi(2)).exp();
                Some(([g as f32; 3], cover.max(shadow)))
            } else {
                Some(([0.15; 3], shadow.max(dent)))
            }
        });
    }

    /// Rust and pressure marks of a paperclip on the top edge.
    fn paperclip(&mut self) {
        let wm = self.wm();
        let cx = wm * self.rng.range(0.22, 0.4);
        let angle = self.rng.range(-5.0, 5.0).to_radians();
        let (ca, sa) = (angle.cos(), angle.sin());
        let seed = self.seed ^ self.rng.next_u64();
        // (half width, top, bottom) of each loop, in mm.
        let loops = [(4.5, -10.0, 24.0), (3.0, -6.0, 17.0)];
        self.paint(cx - 12.0, 0.0, cx + 12.0, 28.0, |x, y| {
            let (dx, dy) = (x - cx, y);
            let (u, v) = (dx * ca + dy * sa, -dx * sa + dy * ca);
            let line = loops
                .iter()
                .map(|&(r, top, bottom)| ((u * u + (v - v.clamp(top + r, bottom - r)).powi(2)).sqrt() - r).abs())
                .fold(f64::MAX, f64::min);
            let n = fbm(seed, x / 2.0, y / 2.0, 3);
            let a = 0.3 * (1.0 - smoothstep(0.15, 0.55, line)) * (0.35 + 0.65 * smoothstep(0.3, 0.7, n));
            (a > 0.0).then_some((RUST, a))
        });
    }

    /// Bottom edge torn off, showing the scanner lid.
    fn torn(&mut self) {
        let (wm, hm, seed) = (self.wm(), self.hm(), self.seed ^ self.rng.next_u64());
        let base = self.rng.range(2.0, 4.0);
        let edge =
            move |x: f64| hm - base - 6.0 * fbm(seed, x / 40.0, 0.0, 3) - 1.2 * (fbm(seed ^ 1, x / 1.5, 0.0, 2) - 0.5);
        let aa = 0.5 / self.ppmm;
        self.paint(0.0, hm - base - 9.0, wm, hm, |x, y| {
            let d = y - edge(x);
            let shade = 0.25 * (-d.max(0.0) / 0.8).exp() as f32;
            let fibres = fbm(seed ^ 2, x * 3.0, y * 3.0, 2);
            let f = (0.75 * (1.0 - smoothstep(0.2, 1.1, -d)) * smoothstep(0.25, 0.6, fibres)) as f32;
            let t = smoothstep(-aa, aa, d) as f32;
            let a = f * (1.0 - t) + t;
            Some((LID.map(|c| (f * (1.0 - t) + (c - shade) * t) / a.max(1e-6)), a as f64))
        });
    }
}

#[cfg(test)]
mod tests {
    use minicbor::Encoder;

    use crate::params::Params;

    #[test]
    fn every_feature_paints() {
        let mut e = Encoder::new(Vec::new());
        e.map(9).unwrap();
        e.str("w").unwrap().f64(105.0).unwrap();
        e.str("h").unwrap().f64(148.0).unwrap();
        e.str("ppmm").unwrap().f64(1.0).unwrap();
        e.str("folds").unwrap().f64(2.0).unwrap();
        for k in ["dog-ear", "staple", "paperclip", "torn"] {
            e.str(k).unwrap().bool(true).unwrap();
        }
        e.str("seed").unwrap().f64(3.0).unwrap();
        let img = super::damage(&Params::decode(&e.into_writer()).unwrap());
        let alpha = |x: u32, y: u32| img.data[img.idx(x, y) + 3];
        assert_eq!(alpha(104, 0), 1.0, "dog-ear");
        assert_eq!(alpha(52, 147), 1.0, "torn");
        assert_eq!(alpha(52, 74), 0.0, "middle stays clear");
    }
}
