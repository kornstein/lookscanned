//! Highlighter stroke: wobbly band, chisel ends, heavier where the pen lands.

use crate::encode::Img;
use crate::params::Params;
use crate::rng::{Rng, fbm, smoothstep};

/// The band fills 80% of the height, centred.
pub fn marker(p: &Params) -> Img {
    let (w, h, seed) = (p.px("w", 256), p.px("h", 32), p.seed());
    let ppmm = p.num("ppmm", 6.0);
    let opacity = p.num("opacity", 0.55).clamp(0.0, 1.0);
    let colour = p.color("color", [1.0, 0.914, 0.302]).map(|c| c as f32);
    let mut img = Img::new(w, h, 4);
    let mut rng = Rng::new(seed);

    let (wf, hf) = (w as f64, h as f64);
    let thick = hf * 0.8;
    let soft = (0.12 * ppmm).max(0.6);
    let tilt = rng.range(-0.12, 0.12) * thick;
    let landing = rng.range(0.15, 0.4);
    let fading = rng.range(0.05, 0.25);
    let chisel = rng.range(0.25, 0.6) * thick;

    let edge = |k: u64| -> Vec<f64> {
        (0..h).map(|y| (fbm(seed ^ k, (y as f64 + 0.5) / ppmm, 0.5, 2) - 0.5) * ppmm).collect()
    };
    let (jag_left, jag_right) = (edge(6), edge(7));

    for x in 0..w {
        let xf = x as f64 + 0.5;
        let (u, xm) = (xf / wf, xf / ppmm);
        let centre = hf / 2.0 + (fbm(seed, xm / 25.0, 0.5, 2) - 0.5) * 0.3 * thick + tilt * (u - 0.5);
        let half = thick / 2.0 * (0.88 + 0.24 * fbm(seed ^ 4, xm / 12.0, 0.5, 2));
        let top = centre - half + (fbm(seed ^ 1, xm / 1.2, 0.5, 3) - 0.5) * 0.14 * thick;
        let bottom = centre + half + (fbm(seed ^ 5, xm / 1.2, 0.5, 3) - 0.5) * 0.14 * thick;
        let pressure = (1.0 + landing * (-xm / 2.5).exp()) * (1.0 - fading * u);
        for y in 0..h {
            let yf = y as f64 + 0.5;
            let across = smoothstep(top - soft, top + soft, yf) * (1.0 - smoothstep(bottom - soft, bottom + soft, yf));
            if across <= 0.0 {
                continue;
            }
            let t = ((yf - top) / (bottom - top)).clamp(0.0, 1.0);
            let left = 0.3 * ppmm + chisel * (1.0 - t) + jag_left[y as usize];
            let right = wf - 0.3 * ppmm - chisel * t + jag_right[y as usize];
            let ends = smoothstep(left - soft, left + soft, xf) * (1.0 - smoothstep(right - soft, right + soft, xf));
            let streak = fbm(seed ^ 3, xm / 9.0, (yf - top) / thick * 8.0, 3);
            let dry = 0.45 + 0.55 * smoothstep(0.2 + 0.25 * u, 0.6, streak);
            let rim = 1.2 - 0.2 * smoothstep(soft, 4.0 * soft, (yf - top).min(bottom - yf));
            let a = opacity * across * ends * pressure * dry * rim;
            let i = img.idx(x, y);
            img.data[i..i + 3].copy_from_slice(&colour);
            img.data[i + 3] = a.min(1.0) as f32;
        }
    }
    img
}
