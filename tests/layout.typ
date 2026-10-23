// Compiled once per preset by `just test`: the extracted text and its line
// breaks must match `--input preset=none` (no effect).
#import "/typst/lib.typ" as lookscanned

#let name = sys.inputs.at("preset", default: "office-scan")
#set page(paper: "a5")
#show: if name == "none" { x => x } else { lookscanned.scan.with(preset: name, seed: 3) }

= Convergence of series

Let $(u_n)$ be a sequence of non-negative real numbers. The series $sum u_n$
converges if and only if its partial sums are bounded. #lorem(50)

- Comparison: if $0 <= u_n <= v_n$ and $sum v_n$ converges, so does $sum u_n$.
- Ratio test: if $u_(n+1) / u_n -> ell < 1$, then $sum u_n$ converges.

$ sum_(n=1)^infinity 1 / n^2 = pi^2 / 6 $

#lorem(70)
