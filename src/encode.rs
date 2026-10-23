//! Raster buffer and minimal PNG encoder (8-bit, no filtering, zlib via miniz_oxide).

/// Channels: 2 = grey + alpha, 3 = RGB, 4 = RGBA. Values in [0, 1].
pub struct Img {
    pub w: u32,
    pub h: u32,
    pub ch: usize,
    pub data: Vec<f32>,
}

impl Img {
    pub fn new(w: u32, h: u32, ch: usize) -> Self {
        Self { w, h, ch, data: vec![0.0; w as usize * h as usize * ch] }
    }

    pub fn idx(&self, x: u32, y: u32) -> usize {
        (y as usize * self.w as usize + x as usize) * self.ch
    }

    /// Composite `alpha` over the alpha channel (last channel), source-over.
    /// For grey + alpha, `grey` is blended too. Out-of-bounds is ignored.
    pub fn blend(&mut self, x: i64, y: i64, grey: f32, alpha: f32) {
        if x < 0 || y < 0 || x >= self.w as i64 || y >= self.h as i64 || alpha <= 0.0 {
            return;
        }
        let alpha = alpha.min(1.0);
        let i = self.idx(x as u32, y as u32);
        let a0 = self.data[i + self.ch - 1];
        let a = alpha + a0 * (1.0 - alpha);
        if self.ch == 2 && a > 0.0 {
            self.data[i] = (grey * alpha + self.data[i] * a0 * (1.0 - alpha)) / a;
        }
        self.data[i + self.ch - 1] = a;
    }

    pub fn png(&self) -> Vec<u8> {
        let colour_type = match self.ch {
            2 => 4,
            3 => 2,
            _ => 6,
        };
        let row = self.w as usize * self.ch;
        let mut raw = Vec::with_capacity((row + 1) * self.h as usize);
        for r in self.data.chunks(row) {
            raw.push(0); // filter: none
            raw.extend(r.iter().map(|v| (v.clamp(0.0, 1.0) * 255.0).round() as u8));
        }
        let mut ihdr = Vec::with_capacity(13);
        ihdr.extend(self.w.to_be_bytes());
        ihdr.extend(self.h.to_be_bytes());
        ihdr.extend([8, colour_type, 0, 0, 0]);

        let mut out = b"\x89PNG\r\n\x1a\n".to_vec();
        chunk(&mut out, b"IHDR", &ihdr);
        chunk(&mut out, b"IDAT", &miniz_oxide::deflate::compress_to_vec_zlib(&raw, 6));
        chunk(&mut out, b"IEND", &[]);
        out
    }
}

fn chunk(out: &mut Vec<u8>, kind: &[u8; 4], data: &[u8]) {
    out.extend((data.len() as u32).to_be_bytes());
    let start = out.len();
    out.extend(kind);
    out.extend(data);
    let crc = crc32(&out[start..]);
    out.extend(crc.to_be_bytes());
}

fn crc32(bytes: &[u8]) -> u32 {
    let mut c = !0u32;
    for &b in bytes {
        c ^= b as u32;
        for _ in 0..8 {
            c = if c & 1 != 0 { 0xEDB8_8320 ^ (c >> 1) } else { c >> 1 };
        }
    }
    !c
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn png_header_and_crc() {
        assert_eq!(crc32(b"IEND"), 0xAE42_6082);
        let png = Img::new(3, 2, 4).png();
        assert_eq!(&png[..8], b"\x89PNG\r\n\x1a\n");
        assert_eq!(&png[12..16], b"IHDR");
        assert_eq!(&png[png.len() - 8..png.len() - 4], b"IEND");
    }
}
