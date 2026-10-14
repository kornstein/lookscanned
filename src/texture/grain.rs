//! Tileable textures: paper grain (+ fibres) and the ink-eating "toner" overlay.

use crate::encode::Img;
use crate::params::Params;
use crate::rng::{Rng, hash2, smoothstep, vnoise};

/// Grey + alpha grain tile. Seamless: white noise, wrapped clumps and fibres.
pub fn grain(p: &Params) -> Img {
    let (w, h, seed) = (p.px("w", 256), p.px("h", 256), p.seed());
    let ppmm = p.num("ppmm", 6.0);
    let amount = p.num("amount", 0.5) as f32;
    let fibres = p.num("fibers", 0.0);
    let mut img = Img::new(w, h, 2);

    // Clumps of ~0.5 mm, lattice wrapped on the tile so it repeats cleanly.
    let cells = ((w as f64 / (ppmm * 0.5)).round() as i64).max(1);
    let scale = cells as f64 / w as f64;
    for y in 0..h {
        for x in 0..w {
            let n = hash2(seed, x as i64, y as i64) as f32 - 0.5;
            let c = vnoise(seed ^ 9, x as f64 * scale, y as f64 * scale, cells) as f32 - 0.5;
            let v = n * 0.7 + c * 0.6;
            let i = img.idx(x, y);
            img.data[i] = if v < 0.0 { 0.0 } else { 1.0 };
            img.data[i + 1] = (v.abs() * amount * 0.55).min(1.0);
        }
    }

    // Fibres: short random walks, wrapped around the tile edges.
    let mut rng = Rng::new(seed ^ 5);
    let area = (w as f64 / ppmm) * (h as f64 / ppmm) / 400.0;
    for _ in 0..(fibres * 12.0 * area) as usize {
        let (mut x, mut y) = (rng.range(0.0, w as f64), rng.range(0.0, h as f64));
        let mut a = rng.range(0.0, std::f64::consts::TAU);
        let grey = rng.range(0.35, 0.75) as f32;
        let alpha = rng.range(0.12, 0.35) as f32 * fibres.min(1.0) as f32;
        for _ in 0..(rng.range(2.0, 8.0) * ppmm) as usize {
            a += rng.range(-0.25, 0.25);
            x = (x + a.cos()).rem_euclid(w as f64);
            y = (y + a.sin()).rem_euclid(h as f64);
            img.blend(x as i64, y as i64, grey, alpha);
        }
    }
    img
}

/// RGBA tile in the paper colour: speckled holes and ribbon-wear streaks that
/// "eat" the ink once laid over the text.
pub fn toner(p: &Params) -> Img {
    let (w, h, seed) = (p.px("w", 256), p.px("h", 256), p.seed());
    let ppmm = p.num("ppmm", 6.0);
    let wear = p.num("amount", 0.3).clamp(0.0, 1.5);
    let colour = p.color("color", [1.0; 3]);
    let mut img = Img::new(w, h, 4);

    let fine = ((w as f64 / (ppmm * 0.18)).round() as i64).max(1);
    let streak = ((w as f64 / (ppmm * 3.0)).round() as i64).max(1);
    let (sf, ss) = (fine as f64 / w as f64, streak as f64 / w as f64);
    let threshold = 1.0 - wear * 0.42;
    for y in 0..h {
        for x in 0..w {
            let (xf, yf) = (x as f64, y as f64);
            // Streaks are stretched horizontally, like a worn ribbon or drum.
            let s = vnoise(seed ^ 1, xf * ss, yf * ss * 6.0, streak);
            let n = vnoise(seed, xf * sf, yf * sf, fine) * 0.75 + hash2(seed ^ 2, x as i64, y as i64) * 0.25;
            let v = n + (s - 0.5) * 0.35;
            let i = img.idx(x, y);
            img.data[i..i + 3].copy_from_slice(&colour.map(|c| c as f32));
            img.data[i + 3] = smoothstep(threshold - 0.04, threshold + 0.04, v) as f32 * 0.9;
        }
    }
    img
}
