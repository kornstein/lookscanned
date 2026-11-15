//! Seeded random table, read by Typst.

use crate::rng::Rng;

pub const TABLE_LEN: usize = 4096;

/// `TABLE_LEN` random bytes.
pub fn table(seed: u64) -> Vec<u8> {
    let mut rng = Rng::new(seed ^ 0x6A09_E667);
    (0..TABLE_LEN).map(|_| rng.next_u64() as u8).collect()
}
