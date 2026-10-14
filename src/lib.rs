mod encode;
mod jitter;
mod params;
mod rng;
mod texture;

/// `texture(kind, params)`: `kind` is a UTF-8 name, `params` a CBOR map
/// (see `params.rs`). Returns PNG bytes.
pub fn texture(kind: &[u8], params: &[u8]) -> Result<Vec<u8>, String> {
    let kind = std::str::from_utf8(kind).map_err(|e| e.to_string())?;
    let params = params::Params::decode(params)?;
    Ok(texture::render(kind, &params)?.png())
}

/// `random(seed)`: `seed` as CBOR integer. Returns `jitter::TABLE_LEN` bytes.
pub fn random(seed: &[u8]) -> Result<Vec<u8>, String> {
    let seed = minicbor::decode::<i64>(seed).map_err(|e| e.to_string())?;
    Ok(jitter::table(seed as u64))
}

// The protocol imports only link inside a WASM host; keep native `cargo test` working.
#[cfg(target_arch = "wasm32")]
mod plugin {
    use wasm_minimal_protocol::*;

    initiate_protocol!();

    #[wasm_func]
    fn texture(kind: &[u8], params: &[u8]) -> Result<Vec<u8>, String> {
        super::texture(kind, params)
    }

    #[wasm_func]
    fn random(seed: &[u8]) -> Result<Vec<u8>, String> {
        super::random(seed)
    }
}

#[cfg(test)]
mod tests {
    use minicbor::Encoder;

    fn params(entries: &[(&str, f64)]) -> Vec<u8> {
        let mut e = Encoder::new(Vec::new());
        e.map(entries.len() as u64).unwrap();
        for (k, v) in entries {
            e.str(k).unwrap().f64(*v).unwrap();
        }
        e.into_writer()
    }

    #[test]
    fn every_kind_renders_deterministically() {
        let p = params(&[("w", 40.0), ("h", 30.0), ("ppmm", 2.0), ("seed", 7.0), ("amount", 0.8)]);
        for kind in ["paper", "grain", "toner", "ink", "stains", "dust", "lines", "edges"] {
            let a = super::texture(kind.as_bytes(), &p).unwrap();
            assert_eq!(a, super::texture(kind.as_bytes(), &p).unwrap(), "{kind}");
        }
        assert!(super::texture(b"nope", &p).is_err());
        assert_ne!(super::random(&[0x01]).unwrap(), super::random(&[0x02]).unwrap());
    }
}
