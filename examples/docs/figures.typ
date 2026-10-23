// Figures of the web documentation, one per compilation:
//
//   typst compile --root . --input fig=preset-fax examples/docs/figures.typ out.pdf
//
// `just docs-images` renders all of them into docs/assets/img/.
#import "/typst/lib.typ" as lookscanned

#let fig = sys.inputs.at("fig", default: "hero")

#let excerpt = [
  = Cauchy sequences

  A sequence $(u_n)$ of real numbers is a _Cauchy sequence_ if for every
  $epsilon > 0$ there exists $N in NN$ such that $abs(u_p - u_q) <= epsilon$
  for all $p, q >= N$.

  *Theorem 1.4.* A real sequence converges if and only if it is a Cauchy
  sequence. In particular, for $abs(q) < 1$,
  $ sum_(n=0)^infinity q^n = 1 / (1 - q). $
]

// Same layout everywhere, so figures can be compared side by side.
#let page-setup = (width: 12cm, height: 7cm, margin: (x: 1cm, y: 0.9cm))

// Neutral settings for ink close-ups: no rotation, no page effects.
#let still = (skew: (page-rotation: 0deg, line-jitter: 0deg, char-jitter: 0pt))

#let sample = [*Theorem.* Every bounded monotone sequence converges: $u_n -> sup_k u_k$.]

#let ink-row(label, ..overrides) = (
  text(size: 8pt, fill: luma(90), raw(label)),
  lookscanned.region(preset: "clean-scan", seed: 4, paper: (grain: 0), ..still, ..overrides, text(size: 13pt, sample)),
)

#let ink-figure(rows) = {
  set page(width: 15cm, height: auto, margin: 0.6cm)
  grid(columns: (3.2cm, 1fr), align: horizon, column-gutter: 0.4cm, row-gutter: 0.35cm, ..rows.flatten())
}

#let texture-cell(label, body) = stack(spacing: 4pt, box(stroke: 0.4pt + luma(200), body), text(size: 8pt, raw(label)))

#set text(font: "New Computer Modern", size: 10pt)
#set par(justify: true)

#if fig.starts-with("preset-") or fig == "hero" {
  let name = if fig == "hero" { "old-paper" } else { fig.slice(7) }
  set page(..page-setup)
  show: lookscanned.scan.with(preset: name, seed: 3)
  excerpt
  if fig == "hero" { lookscanned.scribble(body: "complete!", color: rgb("#2a3f8f"), at: (x: 70%, y: 78%)) }
} else if fig.starts-with("start-") {
  set page(..page-setup)
  let step = int(fig.slice(6))
  show: if step == 1 { x => x } else if step == 2 {
    lookscanned.scan.with(preset: "office-scan")
  } else if step == 3 {
    lookscanned.scan.with(preset: "office-scan", seed: 7, intensity: 1.6)
  } else {
    lookscanned.scan.with(
      preset: "office-scan",
      seed: 7,
      intensity: 1.6,
      paper: (color: rgb("#f3ead6"), aging: 0.4),
      ink: (bleed: 0.6),
    )
  }
  excerpt
  if step == 4 { lookscanned.stamp("Library copy", color: rgb("#5b3a8c"), at: (x: 62%, y: 76%), size: 10pt) }
} else if fig == "ink-bleed" {
  ink-figure(((0, 0.4, 0.8, 1.2).map(b => ink-row("bleed: " + str(b), ink: (bleed: b)))))
} else if fig == "ink-fade" {
  ink-figure(((0, 0.4, 0.8).map(f => ink-row("fade: " + str(f), ink: (fade: f)))))
} else if fig == "ink-wear" {
  ink-figure(((0, 0.5, 1).map(w => ink-row("wear: " + str(w), ink: (bleed: 0.3, wear: w)))))
} else if fig == "ink-legibility" {
  ink-figure(((1, 0.7, 0.4).map(l => ink-row("legibility: " + str(l), ink: (bleed: 0.3, legibility: l)))))
} else if fig == "paper-aging" {
  set page(width: auto, height: auto, margin: 0.4cm)
  grid(columns: 4, column-gutter: 0.3cm, ..(0, 0.3, 0.6, 1).map(a => texture-cell(
    "aging: " + str(a),
    lookscanned.texture("paper", seed: 5, width: 3cm, height: 4cm, color: rgb("#f4eedf"), grain: 0.4, aging: a),
  )))
} else if fig == "textures" {
  set page(width: auto, height: auto, margin: 0.4cm)
  let s = (width: 3cm, height: 3cm, seed: 2)
  let cells = (
    ("paper", lookscanned.texture("paper", ..s, color: rgb("#efe3c8"), grain: 0.5, aging: 0.6)),
    ("grain", lookscanned.texture("grain", ..s, amount: 1, fibers: 1)),
    ("toner", lookscanned.texture("toner", ..s, amount: 1, color: rgb("#1a1a1a"))),
    ("ink", lookscanned.texture("ink", ..s, resolution: 600, amount: 0.8)),
    ("stains", lookscanned.texture("stains", ..s, count: 1, min: 22mm, max: 26mm)),
    ("dust", lookscanned.texture("dust", ..s, amount: 1, scratches: 1)),
    ("lines", lookscanned.texture("lines", ..s, amount: 1, axis: "h")),
    ("edges", lookscanned.texture("edges", ..s, shadow: 1, vignette: 1)),
  )
  grid(columns: 4, gutter: 0.3cm, ..cells.map(((k, c)) => texture-cell(k, c)))
} else if fig == "page-override" {
  set page(..page-setup)
  show: lookscanned.scan.with(preset: "office-scan", seed: 3)
  [= Lecture notes
  #lorem(30)]
  pagebreak()
  lookscanned.page(stains: (amount: 1), skew: (page-rotation: 2deg), edges: (binding: true))[
    = Appendix: tables
    #lorem(30)
  ]
} else if fig == "region" {
  set page(width: 12cm, height: auto, margin: 0.8cm)
  [The proof below is reproduced from the original 1958 edition. #lorem(14)]
  lookscanned.region(preset: "typewriter", seed: 2)[
    *Proof.* Let $epsilon > 0$ and choose $N$ such that $abs(u_n - ell) <= epsilon$
    for all $n >= N$. Then $abs(u_p - u_q) <= 2 epsilon$ for all $p, q >= N$.
  ]
  [The converse requires the completeness of $RR$. #lorem(10)]
} else if fig == "decorations" {
  set page(width: 12cm, height: 6.5cm, margin: 0.8cm, fill: rgb("#f7f5ef"))
  lookscanned.stamp("Library copy", color: rgb("#5b3a8c"), size: 13pt, at: (x: 0cm, y: 0.5cm))
  lookscanned.stamp("Marked", angle: 9deg, size: 13pt, seed: 3, at: (x: 6.9cm, y: 1.9cm))
  lookscanned.scribble(body: "see Thm 1.4", at: (x: 0.2cm, y: 3.4cm))
  lookscanned.scribble(width: 3.2cm, seed: 4, at: (x: 3.4cm, y: 3.6cm))
  lookscanned.stain(at: (x: 9.6cm, y: 0.6cm), size: 18mm)
} else {
  panic("unknown figure " + repr(fig))
}
