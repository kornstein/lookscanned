//! Scanner-glass debris (dust, hairs, scratches) and transfer artefacts
//! (fax lines, photocopier bands).

use std::f64::consts::TAU;

use crate::encode::Img;
use crate::params::Params;
use crate::rng::{Rng, fbm};

/// Grey + alpha, full page.
pub fn dust(p: &Params) -> Img {
    let (w, h, seed) = (p.px("w", 64), p.px("h", 64), p.seed());
    let ppmm = p.num("ppmm", 6.0);
    let (dust, scratches) = (p.num("amount", 0.5), p.num("scratches", 0.0));
    let mut img = Img::new(w, h, 2);
    let mut rng = Rng::new(seed);
    let area = (w as f64 / ppmm) * (h as f64 / ppmm) / (210.0 * 297.0);

    // Specks: tiny dark blobs.
    for _ in 0..(dust * 350.0 * area) as usize {
        let (cx, cy) = (rng.range(0.0, w as f64), rng.range(0.0, h as f64));
        let r = rng.range(0.04, 0.22) * ppmm * (1.0 + 2.0 * rng.f().powi(6));
        let (grey, alpha) = (rng.range(0.0, 0.25) as f32, rng.range(0.4, 0.95) as f32);
        let ri = r.ceil() as i64 + 1;
        for y in -ri..=ri {
            for x in -ri..=ri {
                let d = ((x * x + y * y) as f64).sqrt() / r.max(0.5);
                if d < 1.0 + 0.5 * rng.f() {
                    img.blend(cx as i64 + x, cy as i64 + y, grey, alpha);
                }
            }
        }
    }

    // Hairs: curly dark lines of a few millimetres.
    for _ in 0..(dust * 5.0 * area + rng.f() * dust) as usize {
        let len = rng.range(2.0, 9.0) * ppmm;
        walk(&mut img, &mut rng, len, 0.18, 0.15, 0.7);
    }

    // Scratches: long, faint, mostly vertical lines (sliding glass).
    for _ in 0..(scratches * 10.0 * area) as usize {
        let len = rng.range(20.0, 180.0) * ppmm;
        let grey = if rng.chance(0.5) { 1.0 } else { 0.1 };
        let (x, y) = (rng.range(0.0, w as f64), rng.range(0.0, h as f64));
        let mut a = TAU / 4.0 + rng.range(-0.08, 0.08);
        let alpha = rng.range(0.12, 0.35) as f32;
        let (mut x, mut y) = (x, y);
        for _ in 0..len as usize {
            a += rng.range(-0.002, 0.002);
            x += a.cos();
            y += a.sin();
            img.blend(x as i64, y as i64, grey, alpha);
        }
    }
    img
}

fn walk(img: &mut Img, rng: &mut Rng, len: f64, curl: f64, grey: f32, alpha: f32) {
    let (mut x, mut y) = (rng.range(0.0, img.w as f64), rng.range(0.0, img.h as f64));
    let mut a = rng.range(0.0, TAU);
    for _ in 0..len as usize {
        a += rng.range(-curl, curl);
        x += a.cos();
        y += a.sin();
        img.blend(x as i64, y as i64, grey, alpha);
    }
}

/// Grey + alpha strip, stretched over the page by Typst:
/// `axis: "h"` → 1×h horizontal fax lines, `axis: "v"` → w×1 photocopier bands.
pub fn lines(p: &Params) -> Img {
    let seed = p.seed();
    let amount = p.num("amount", 0.5);
    let horizontal = p.str("axis", "h") == "h";
    let n = if horizontal { p.px("h", 64) } else { p.px("w", 64) };
    let mut img = if horizontal { Img::new(1, n, 2) } else { Img::new(n, 1, 2) };
    let mut rng = Rng::new(seed);
    let set = |img: &mut Img, i: i64, grey: f32, a: f32| {
        if horizontal { img.blend(0, i, grey, a) } else { img.blend(i, 0, grey, a) }
    };

    if horizontal {
        // Fax: thin dark lines and white dropouts.
        let mut i = 0i64;
        while i < n as i64 {
            if rng.chance(amount * 0.012) {
                let (t, a) = (rng.range(1.0, 3.5) as i64, rng.range(0.25, 0.8) as f32);
                (0..t).for_each(|k| set(&mut img, i + k, 0.05, a));
                i += t;
            } else if rng.chance(amount * 0.004) {
                let t = rng.range(1.0, 4.0) as i64;
                (0..t).for_each(|k| set(&mut img, i + k, 1.0, 0.85));
                i += t;
            }
            i += 1;
        }
    } else {
        // Photocopier: soft vertical bands plus a few drum streaks.
        for i in 0..n as i64 {
            let b = fbm(seed, i as f64 / n as f64 * 9.0, 0.5, 3);
            set(&mut img, i, 0.1, (amount * 0.22 * (b - 0.35).max(0.0)) as f32);
        }
        for _ in 0..(amount * 6.0) as usize {
            let (x, t) = (rng.range(0.0, n as f64) as i64, rng.range(1.0, 3.0) as i64);
            let a = rng.range(0.1, 0.4) as f32;
            (0..t).for_each(|k| set(&mut img, x + k, 0.1, a));
        }
    }
    img
}
