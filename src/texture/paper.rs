//! Paper background: base colour, low-frequency mottling, yellowing and foxing.
//! Smooth by nature, so Typst asks for it at a fraction of the page resolution.

use crate::encode::Img;
use crate::params::Params;
use crate::rng::{Rng, fbm, smoothstep};

const AGED: [f64; 3] = [0.93, 0.84, 0.64];
const FOX: [f64; 3] = [0.62, 0.45, 0.28];

pub fn paper(p: &Params) -> Img {
    let (w, h, seed) = (p.px("w", 64), p.px("h", 64), p.seed());
    let mm = 1.0 / p.num("ppmm", 1.0); // mm per pixel
    let base = p.color("color", [1.0; 3]);
    let grain = p.num("grain", 0.0);
    let aging = p.num("aging", 0.0);
    let mut img = Img::new(w, h, 3);

    for y in 0..h {
        for x in 0..w {
            let (xm, ym) = (x as f64 * mm, y as f64 * mm);
            let mottle = fbm(seed, xm / 45.0, ym / 45.0, 4) - 0.5;
            let fine = fbm(seed ^ 1, xm / 5.0, ym / 5.0, 2) - 0.5;
            let lum = 1.0 + mottle * (0.03 + 0.07 * grain) + fine * 0.04 * grain;

            let (u, v) = (x as f64 / w as f64, y as f64 / h as f64);
            let edge = 1.0 - smoothstep(0.0, 0.14, u.min(1.0 - u).min(v).min(1.0 - v));
            let blotch = fbm(seed ^ 2, xm / 70.0, ym / 70.0, 3);
            let yellow = (aging * (0.25 + 0.6 * blotch + 0.6 * edge * blotch)).min(1.0);

            let i = img.idx(x, y);
            for c in 0..3 {
                let aged = base[c] * (1.0 - yellow) + base[c] * AGED[c] * yellow;
                img.data[i + c] = (aged * lum) as f32;
            }
        }
    }

    // Foxing: small rusty spots, more with age.
    let mut rng = Rng::new(seed ^ 3);
    let area = (w as f64 * mm) * (h as f64 * mm) / (210.0 * 297.0);
    for _ in 0..(aging * aging * 60.0 * area) as usize {
        let (cx, cy) = (rng.range(0.0, w as f64), rng.range(0.0, h as f64));
        let r = rng.range(0.3, 2.2) / mm;
        let strength = rng.range(0.15, 0.5) * aging.min(1.0);
        spot(&mut img, cx, cy, r.max(1.0), strength, seed ^ rng.next_u64());
    }
    img
}

fn spot(img: &mut Img, cx: f64, cy: f64, r: f64, strength: f64, seed: u64) {
    let (x0, x1) = ((cx - r * 1.5).max(0.0) as u32, ((cx + r * 1.5) as u32).min(img.w - 1));
    let (y0, y1) = ((cy - r * 1.5).max(0.0) as u32, ((cy + r * 1.5) as u32).min(img.h - 1));
    for y in y0..=y1 {
        for x in x0..=x1 {
            let (dx, dy) = ((x as f64 - cx) / r, (y as f64 - cy) / r);
            let d = (dx * dx + dy * dy).sqrt() * (0.8 + 0.4 * fbm(seed, dx * 2.0, dy * 2.0, 2));
            let a = strength * (1.0 - smoothstep(0.4, 1.0, d));
            let i = img.idx(x, y);
            for (c, fox) in FOX.iter().enumerate() {
                let v = img.data[i + c] as f64;
                img.data[i + c] = (v * (1.0 - a) + v * fox * a) as f32;
            }
        }
    }
}
