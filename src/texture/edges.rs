//! Lighting overlay: scanner edge shadows, vignette, binding gutter, uneven
//! light (phone photos). Smooth, so rendered at low resolution.

use crate::encode::Img;
use crate::params::Params;
use crate::rng::{Rng, fbm, smoothstep};

pub fn edges(p: &Params) -> Img {
    let (w, h, seed) = (p.px("w", 64), p.px("h", 64), p.seed());
    let mm = 1.0 / p.num("ppmm", 1.0);
    let shadow = p.num("shadow", 0.0);
    let vignette = p.num("vignette", 0.0);
    let uneven = p.num("uneven", 0.0);
    let binding = p.bool("binding");
    let mut rng = Rng::new(seed);

    // Per side strength (left, right, top, bottom) and width in mm: one side
    // usually dominates, as when the sheet does not lie flat on the glass.
    let main = (rng.f() * 4.0) as usize;
    let sides: Vec<(f64, f64)> = (0..4)
        .map(|i| {
            let s = if i == main { 1.0 } else { rng.range(0.05, 0.45) };
            (shadow * s, rng.range(3.0, 11.0))
        })
        .collect();
    let light = rng.range(0.0, std::f64::consts::TAU);
    let (lx, ly) = (light.cos(), light.sin());

    let (wm, hm) = (w as f64 * mm, h as f64 * mm);
    let mut img = Img::new(w, h, 2);
    for y in 0..h {
        for x in 0..w {
            let (xm, ym) = (x as f64 * mm, y as f64 * mm);
            let dist = [xm, wm - xm, ym, hm - ym];
            let mut clear = 1.0;
            for (i, &(s, width)) in sides.iter().enumerate() {
                let along = if i < 2 { ym } else { xm };
                let wobble = 0.6 + 0.8 * fbm(seed ^ i as u64, along / 40.0, 0.0, 3);
                let a = s * 0.6 * (1.0 - smoothstep(0.0, width * wobble, dist[i])).powi(2);
                clear *= 1.0 - a;
            }
            let (u, v) = (x as f64 / w as f64 - 0.5, y as f64 / h as f64 - 0.5);
            let r = (u * u + v * v).sqrt() * std::f64::consts::SQRT_2;
            clear *= 1.0 - vignette * 0.45 * smoothstep(0.35, 1.1, r);
            let ramp = (u * lx + v * ly + 0.7) / 1.4;
            clear *=
                1.0 - uneven * 0.35 * smoothstep(0.0, 1.0, ramp) * (0.7 + 0.6 * fbm(seed ^ 7, u * 2.0, v * 2.0, 2));
            if binding {
                clear *= 1.0 - 0.75 * (-xm / 7.0).exp() - 0.25 * (-xm / 25.0).exp();
            }
            let i = img.idx(x, y);
            img.data[i + 1] = (1.0 - clear.max(0.0)) as f32;
        }
    }
    img
}
