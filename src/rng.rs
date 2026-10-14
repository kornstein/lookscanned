//! Seeded randomness: everything visible derives from the user seed.

/// SplitMix64: tiny, fast, good enough for visual noise.
pub struct Rng(u64);

impl Rng {
    pub fn new(seed: u64) -> Self {
        Self(seed ^ 0x9E37_79B9_7F4A_7C15)
    }

    pub fn next_u64(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        mix(self.0)
    }

    /// Uniform in [0, 1).
    pub fn f(&mut self) -> f64 {
        (self.next_u64() >> 11) as f64 / (1u64 << 53) as f64
    }

    /// Uniform in [a, b).
    pub fn range(&mut self, a: f64, b: f64) -> f64 {
        a + (b - a) * self.f()
    }

    pub fn chance(&mut self, p: f64) -> bool {
        self.f() < p
    }
}

/// SplitMix64 finalizer, used as a stateless hash.
pub fn mix(mut z: u64) -> u64 {
    z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
    z ^ (z >> 31)
}

/// Hash of a lattice point, in [0, 1).
pub fn hash2(seed: u64, x: i64, y: i64) -> f64 {
    let h = mix(seed ^ mix((x as u64).wrapping_mul(0x632B_E59B_D9B4_E019) ^ (y as u64)));
    (h >> 11) as f64 / (1u64 << 53) as f64
}

fn smooth(t: f64) -> f64 {
    t * t * (3.0 - 2.0 * t)
}

/// Value noise in [0, 1). `period` > 0 wraps the lattice so the result tiles.
pub fn vnoise(seed: u64, x: f64, y: f64, period: i64) -> f64 {
    let (x0, y0) = (x.floor(), y.floor());
    let (tx, ty) = (smooth(x - x0), smooth(y - y0));
    let (x0, y0) = (x0 as i64, y0 as i64);
    let w = |v: i64| if period > 0 { v.rem_euclid(period) } else { v };
    let h = |dx, dy| hash2(seed, w(x0 + dx), w(y0 + dy));
    let a = h(0, 0) + (h(1, 0) - h(0, 0)) * tx;
    let b = h(0, 1) + (h(1, 1) - h(0, 1)) * tx;
    a + (b - a) * ty
}

/// Fractal value noise in [0, 1), `octaves` layers halving in amplitude.
pub fn fbm(seed: u64, x: f64, y: f64, octaves: u32) -> f64 {
    let (mut sum, mut amp, mut norm, mut f) = (0.0, 1.0, 0.0, 1.0);
    for o in 0..octaves {
        sum += amp * vnoise(seed.wrapping_add(o as u64 * 7919), x * f, y * f, 0);
        norm += amp;
        amp *= 0.5;
        f *= 2.0;
    }
    sum / norm
}

/// Tileable fractal noise in [0, 1): `x`, `y` in units of the base lattice,
/// which wraps every `period` cells (each octave doubles both).
pub fn pfbm(seed: u64, x: f64, y: f64, period: i64, octaves: u32) -> f64 {
    let (mut sum, mut amp, mut norm, mut f) = (0.0, 1.0, 0.0, 1i64);
    for o in 0..octaves {
        sum += amp * vnoise(seed.wrapping_add(o as u64 * 7919), x * f as f64, y * f as f64, period * f);
        norm += amp;
        amp *= 0.5;
        f *= 2;
    }
    sum / norm
}

pub fn smoothstep(a: f64, b: f64, x: f64) -> f64 {
    smooth(((x - a) / (b - a)).clamp(0.0, 1.0))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn deterministic_and_in_range() {
        let (mut a, mut b) = (Rng::new(42), Rng::new(42));
        for _ in 0..1000 {
            let v = a.f();
            assert_eq!(v, b.f());
            assert!((0.0..1.0).contains(&v));
        }
        assert_ne!(Rng::new(1).next_u64(), Rng::new(2).next_u64());
        for i in 0..200 {
            let n = fbm(7, i as f64 * 0.37, i as f64 * 0.11, 4);
            assert!((0.0..1.0).contains(&n));
        }
        // Periodic noise tiles.
        assert_eq!(vnoise(3, 0.25, 0.5, 8), vnoise(3, 8.25, 0.5, 8));
        assert!((pfbm(3, 0.25, 0.5, 8, 3) - pfbm(3, 8.25, 0.5, 8, 3)).abs() < 1e-12);
    }
}
