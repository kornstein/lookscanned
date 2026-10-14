//! Stains in a user-chosen colour: blotches, coffee rings and splatters.

use std::f64::consts::TAU;

use crate::encode::Img;
use crate::params::Params;
use crate::rng::{Rng, fbm, smoothstep};

pub fn stains(p: &Params) -> Img {
    let (w, h, seed) = (p.px("w", 64), p.px("h", 64), p.seed());
    let ppmm = p.num("ppmm", 2.0);
    let amount = p.num("amount", 0.3);
    let (rmin, rmax) = (p.num("min", 2.0 * ppmm) / 2.0, p.num("max", 15.0 * ppmm) / 2.0);
    let mut img = Img::new(w, h, 4);
    let mut rng = Rng::new(seed);

    // `count` places that many stains centred in the image (used by `stain()`).
    let single = p.num("count", 0.0) as usize;
    let area = (w as f64 / ppmm) * (h as f64 / ppmm) / (210.0 * 297.0);
    let n = if single > 0 { single } else { (amount * 9.0 * area + rng.f()) as usize };

    for _ in 0..n {
        let (cx, cy) = if single > 0 {
            (w as f64 / 2.0, h as f64 / 2.0)
        } else {
            (rng.range(0.0, w as f64), rng.range(0.0, h as f64))
        };
        let r = rng.range(rmin, rmax.max(rmin + 1.0));
        let s = rng.next_u64();
        let strength = rng.range(0.25, 0.55) * amount.clamp(0.3, 1.0);
        match rng.f() {
            k if k < 0.45 => blotch(&mut img, cx, cy, r, strength, s),
            k if k < 0.8 => ring(&mut img, cx, cy, r, strength * 1.2, s),
            _ => {
                let mut sr = Rng::new(s);
                for _ in 0..sr.range(4.0, 14.0) as usize {
                    let (a, d) = (sr.range(0.0, TAU), sr.range(0.0, r) * sr.f());
                    let rr = r * sr.range(0.04, 0.22);
                    blotch(&mut img, cx + a.cos() * d, cy + a.sin() * d, rr, strength, sr.next_u64());
                }
            }
        }
    }

    let colour = p.color("color", [0.55, 0.35, 0.17]);
    for px in img.data.chunks_mut(4) {
        px[..3].copy_from_slice(&colour.map(|c| c as f32));
    }
    img
}

/// Irregular disc with a darker rim (the dried edge of a liquid stain).
fn blotch(img: &mut Img, cx: f64, cy: f64, r: f64, strength: f64, seed: u64) {
    paint(img, cx, cy, r, seed, |d, n| {
        let inside = 1.0 - smoothstep(0.92, 1.04, d);
        strength * inside * (0.45 + 0.35 * n + 0.45 * smoothstep(0.7, 0.98, d))
    });
}

/// Coffee-cup ring, often broken.
fn ring(img: &mut Img, cx: f64, cy: f64, r: f64, strength: f64, seed: u64) {
    paint(img, cx, cy, r, seed, |d, n| {
        let band = smoothstep(0.82, 0.95, d) * (1.0 - smoothstep(0.97, 1.03, d));
        strength * band * smoothstep(0.3, 0.6, n)
    });
}

/// Calls `f(distorted distance, noise)` over the stain's bounding box.
fn paint(img: &mut Img, cx: f64, cy: f64, r: f64, seed: u64, f: impl Fn(f64, f64) -> f64) {
    let r = r.max(1.0);
    let x0 = (cx - r * 1.4).max(0.0) as i64;
    let y0 = (cy - r * 1.4).max(0.0) as i64;
    let x1 = (cx + r * 1.4).min(img.w as f64 - 1.0) as i64;
    let y1 = (cy + r * 1.4).min(img.h as f64 - 1.0) as i64;
    for y in y0..=y1 {
        for x in x0..=x1 {
            let (dx, dy) = ((x as f64 - cx) / r, (y as f64 - cy) / r);
            // Distort the outline by angle so stains are not circles.
            let a = dy.atan2(dx);
            let wobble = fbm(seed, a.cos() * 1.5 + 9.0, a.sin() * 1.5 + 9.0, 3) - 0.5;
            let d = (dx * dx + dy * dy).sqrt() * (1.0 + wobble * 0.45);
            let n = fbm(seed ^ 1, dx * 3.0, dy * 3.0, 3);
            img.blend(x, y, 0.0, f(d, n) as f32);
        }
    }
}
