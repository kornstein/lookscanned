//! Ink tilings for text and strokes.

use crate::encode::Img;
use crate::params::Params;
use crate::rng::{hash2, pfbm, smoothstep};

/// Lattice period for a feature of `mm`.
fn cells(w: u32, ppmm: f64, mm: f64) -> i64 {
    ((w as f64 / (ppmm * mm)).round() as i64).max(1)
}

/// Ink tile: glyph interior ("fill") or patchy outline ("edge").
/// Both share their pinholes, so holes go through the stroke.
pub fn ink(p: &Params) -> Img {
    let (w, seed) = (p.px("w", 128), p.seed());
    let ppmm = p.num("ppmm", 24.0);
    let amount = p.num("amount", 0.3).clamp(0.0, 1.5);
    let alpha = p.num("alpha", 1.0).clamp(0.0, 1.0);
    let soft = p.num("soft", 0.0).clamp(0.0, 1.0);
    let colour = p.color("color", [0.0; 3]);
    let edge = p.str("mode", "fill") == "edge";
    let mut img = Img::new(w, w, 4);

    let (pc, pf, pp) = (cells(w, ppmm, 0.9), cells(w, ppmm, 0.3), cells(w, ppmm, 0.06));
    let (sc, sf, sp) = (pc as f64 / w as f64, pf as f64 / w as f64, pp as f64 / w as f64);
    for y in 0..w {
        for x in 0..w {
            let (xf, yf) = (x as f64, y as f64);
            let coarse = pfbm(seed, xf * sc, yf * sc, pc, 3);
            let fibre = pfbm(seed ^ 1, xf * sf, yf * sf, pf, 2);
            let pin = pfbm(seed ^ 2, xf * sp, yf * sp, pp, 2) * 0.7 + hash2(seed ^ 3, x as i64, y as i64) * 0.3;
            let holes = smoothstep(1.0 - amount * 0.4, 1.04 - amount * 0.4, pin * 0.6 + fibre * 0.4);
            let a = if edge {
                let t = 0.44 - 0.25 * (coarse - 0.5);
                let k = 0.015 + 0.2 * soft;
                smoothstep(t - k, t + k, fibre) * (1.0 - 0.45 * soft)
            } else {
                1.0 - amount * 0.12 * smoothstep(0.4, 0.75, coarse)
            };
            let a = a * (1.0 - holes);
            let i = img.idx(x, y);
            img.data[i..i + 3].copy_from_slice(&colour.map(|c| c as f32));
            img.data[i + 3] = (a * alpha) as f32;
        }
    }
    img
}
