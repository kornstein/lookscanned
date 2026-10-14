// Figures of the web documentation. One figure per compilation:
//
//   typst compile --root . --input fig=preset-fax examples/docs/figures.typ out.png
//
// `just docs-images` renders all of them into docs/assets/img/.
#import "/typst/lib.typ" as lookscanned

#let fig = sys.inputs.at("fig", default: "hero")

#let letter = [
  = Rental agreement

  Between the undersigned, it has been agreed as follows. The landlord rents
  to the tenant the premises described below, for a period of three years
  starting on the first of March. The rent is payable monthly and in advance.

  - Article 1: the premises are let unfurnished.
  - Article 2: the deposit equals two months of rent.
]

// Same layout everywhere, so figures can be compared side by side.
#let page-setup = (width: 12cm, height: 8.5cm, margin: (x: 1cm, y: 0.9cm))

// Neutral settings for ink close-ups: no rotation, no page effects.
#let still = (skew: (page-rotation: 0deg, line-jitter: 0deg, char-jitter: 0pt))

#let sample = [*Rental agreement*, signed in Paris. The rent is payable monthly.]

#let ink-row(label, ..overrides) = (
  text(size: 8pt, fill: luma(90), raw(label)),
  lookscanned.region(preset: "clean-scan", seed: 4, paper: (grain: 0), ..still, ..overrides, text(size: 13pt, sample)),
)

#let ink-figure(rows) = {
  set page(width: 14cm, height: auto, margin: 0.6cm)
  grid(columns: (3.2cm, 1fr), align: horizon, column-gutter: 0.4cm, row-gutter: 0.35cm, ..rows.flatten())
}

#let texture-cell(label, body) = stack(spacing: 4pt, box(stroke: 0.4pt + luma(200), body), text(size: 8pt, raw(label)))

#set text(font: "Libertinus Serif", size: 10pt)

#if fig.starts-with("preset-") or fig == "hero" {
  let name = if fig == "hero" { "office-scan" } else { fig.slice(7) }
  set page(..page-setup)
  show: lookscanned.scan.with(preset: name, seed: 3)
  letter
  if fig == "hero" { lookscanned.stamp("Received", at: (x: 66%, y: 74%), size: 12pt) }
} else if fig.starts-with("tutorial-") {
  set page(..page-setup)
  let step = int(fig.slice(9))
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
  letter
  if step == 4 { lookscanned.stamp("Received", at: (x: 66%, y: 74%), size: 12pt) }
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
  [= Report
  #lorem(30)]
  pagebreak()
  lookscanned.page(stains: (amount: 1), skew: (page-rotation: 2deg), edges: (binding: true))[
    = Damaged appendix
    #lorem(30)
  ]
} else if fig == "region" {
  set page(width: 12cm, height: auto, margin: 0.8cm)
  [This paragraph stays clean. #lorem(18)]
  lookscanned.region(preset: "fax", seed: 2)[
    *Appendix B.* This part looks like it came in by fax. #lorem(22)
  ]
  [Back to clean text. #lorem(10)]
} else if fig == "decorations" {
  set page(width: 12cm, height: 6cm, margin: 0.8cm, fill: rgb("#f7f5ef"))
  lookscanned.stamp("Received", at: (x: 0cm, y: 0.4cm))
  lookscanned.stamp("Paid", color: rgb("#1f4e9c"), angle: 8deg, seed: 3, at: (x: 5.6cm, y: 0.2cm))
  lookscanned.scribble(body: "Seen, OK", at: (x: 0.2cm, y: 2.9cm))
  lookscanned.scribble(width: 3.5cm, seed: 4, at: (x: 4.2cm, y: 3cm))
  lookscanned.stain(at: (x: 9cm, y: 3.2cm), size: 22mm)
} else {
  panic("unknown figure " + repr(fig))
}
