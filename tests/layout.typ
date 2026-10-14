// Compiled once per preset by `just test`: the extracted text and its line
// breaks must match `--input preset=none` (no effect).
#import "/typst/lib.typ" as lookscanned

#let name = sys.inputs.at("preset", default: "office-scan")
#set page(paper: "a5")
#set text(lang: "fr")
#show: if name == "none" { x => x } else { lookscanned.scan.with(preset: name, seed: 3) }

= Contrat de location

Entre les soussignés, il a été convenu ce qui suit. #lorem(60)

- Article premier : le bailleur loue au preneur.
- Article second : le loyer est payable d'avance.

#lorem(80)
