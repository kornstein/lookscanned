mod dust;
mod edges;
mod grain;
mod ink;
mod paper;
mod stains;

use crate::encode::Img;
use crate::params::Params;

pub const KINDS: &str = "\"paper\", \"grain\", \"toner\", \"ink\", \"stains\", \"dust\", \"lines\", \"edges\"";

pub fn render(kind: &str, p: &Params) -> Result<Img, String> {
    Ok(match kind {
        "paper" => paper::paper(p),
        "grain" => grain::grain(p),
        "toner" => grain::toner(p),
        "ink" => ink::ink(p),
        "stains" => stains::stains(p),
        "dust" => dust::dust(p),
        "lines" => dust::lines(p),
        "edges" => edges::edges(p),
        other => return Err(format!("unknown texture {other:?}, expected one of {KINDS}")),
    })
}
