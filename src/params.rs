//! Parameters sent by `typst/wasm.typ` as a CBOR map with string keys.
//! Lengths are converted to pixels and colours to `[r, g, b, a]` on the Typst side.

use std::collections::HashMap;

use minicbor::Decoder;
use minicbor::data::Type;

enum Value {
    Num(f64),
    Str(String),
    Bool(bool),
    Arr(Vec<f64>),
}

pub struct Params(HashMap<String, Value>);

fn num(d: &mut Decoder) -> Result<f64, minicbor::decode::Error> {
    Ok(match d.datatype()? {
        Type::U8 | Type::U16 | Type::U32 | Type::U64 => d.u64()? as f64,
        Type::I8 | Type::I16 | Type::I32 | Type::I64 => d.i64()? as f64,
        Type::F16 => d.f16()? as f64,
        Type::F32 => d.f32()? as f64,
        _ => d.f64()?,
    })
}

impl Params {
    pub fn decode(bytes: &[u8]) -> Result<Self, String> {
        let mut d = Decoder::new(bytes);
        let mut map = HashMap::new();
        let len = d.map().map_err(|e| e.to_string())?.ok_or("indefinite map")?;
        for _ in 0..len {
            let key = d.str().map_err(|e| e.to_string())?.to_owned();
            let value = match d.datatype().map_err(|e| e.to_string())? {
                Type::String => Value::Str(d.str().map_err(|e| e.to_string())?.to_owned()),
                Type::Bool => Value::Bool(d.bool().map_err(|e| e.to_string())?),
                Type::Array => {
                    let n = d.array().map_err(|e| e.to_string())?.unwrap_or(0);
                    let v = (0..n).map(|_| num(&mut d)).collect::<Result<_, _>>();
                    Value::Arr(v.map_err(|e| format!("{key}: {e}"))?)
                }
                _ => Value::Num(num(&mut d).map_err(|e| format!("{key}: {e}"))?),
            };
            map.insert(key, value);
        }
        Ok(Self(map))
    }

    pub fn num(&self, k: &str, default: f64) -> f64 {
        match self.0.get(k) {
            Some(Value::Num(v)) => *v,
            _ => default,
        }
    }

    pub fn px(&self, k: &str, default: u32) -> u32 {
        (self.num(k, default as f64).round() as u32).clamp(1, 12000)
    }

    pub fn seed(&self) -> u64 {
        self.num("seed", 0.0) as i64 as u64
    }

    pub fn str(&self, k: &str, default: &'static str) -> &str {
        match self.0.get(k) {
            Some(Value::Str(s)) => s,
            _ => default,
        }
    }

    pub fn bool(&self, k: &str) -> bool {
        matches!(self.0.get(k), Some(Value::Bool(true)))
    }

    /// RGB colour as floats in [0, 1].
    pub fn color(&self, k: &str, default: [f64; 3]) -> [f64; 3] {
        match self.0.get(k) {
            Some(Value::Arr(c)) if c.len() >= 3 => [c[0] / 255.0, c[1] / 255.0, c[2] / 255.0],
            _ => default,
        }
    }
}
