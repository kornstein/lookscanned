// Images of the README, one per compilation:
//
//   typst compile --root . --input fig=hero examples/docs/readme.typ out.pdf
//
// `hero` and `presets` lay out the examples compiled beforehand into `dir`; `just readme-images` does it all.
#import "/typst/lib.typ" as lookscanned

#let fig = sys.inputs.at("fig", default: "hero")
#let dir = "/" + sys.inputs.at("dir", default: "target/readme")

// Soft shadow of a w × h sheet.
#let shadow(w, h) = for (d, a) in ((14pt, 90%), (9pt, 84%), (5pt, 76%), (2pt, 66%)) {
  place(dx: d * 0.5, dy: d, rect(width: w, height: h, radius: 2pt, stroke: none, fill: black.transparentize(a)))
}

// A page lying on the desk.
#let sheet(file, height, angle) = rotate(angle, reflow: true, {
  let page = image(dir + "/" + file + ".pdf", page: 1, height: height)
  context {
    let s = measure(page)
    shadow(s.width, s.height)
  }
  page
})

// First page of a PDF at its natural ratio: in a smaller container, `image` would crop it to cover it.
#let pdf(file, width: auto, height: auto) = context {
  let path = dir + "/" + file + ".pdf"
  let s = measure(image(path, page: 1, width: width, height: height))
  image(path, page: 1, width: s.width, height: s.height)
}

#if fig == "hero" {
  let (W, H) = (36cm, 15.2cm)
  set page(width: W, height: H, margin: 0pt, fill: none)
  let fan = (
    ("typewriter", 11.6cm, -10deg, 0.6cm, 1.4cm),
    ("fax", 11.6cm, 9deg, 25.4cm, 1.2cm),
    ("old-paper", 12.4cm, -4.5deg, 6.2cm, 0.8cm),
    ("mimeograph", 12.4cm, 4.5deg, 20cm, 0.6cm),
    ("newsprint", 13.4cm, 0deg, 13.3cm, 0.4cm),
  )
  for (file, h, a, x, y) in fan { place(dx: x, dy: y, sheet(file, h, a)) }
} else if fig == "presets" {
  // The examples, one per preset, cropped to their top.
  let names = ("clean-scan", "office-scan", "photocopy", "fax", "typewriter",
    "old-paper", "phone-scan", "mimeograph", "microfilm", "newsprint")
  let looks = ("almost pristine", "the office copier", "toner and drum bands", "transmission lines", "worn ribbon",
    "foxing and stains", "uneven light", "stencil duplicator", "grey film, scratches", "pulp paper, folded")
  let (tw, th, gap, label, m) = (8cm, 8.4cm, 0.9cm, 1.5cm, 0.2cm)
  set page(width: 2 * m + 5 * tw + 4 * gap, height: 2 * m + 2 * (th + label) + gap, margin: 0pt, fill: none)
  set text(font: "DejaVu Sans Mono")
  for (i, n) in names.enumerate() {
    let (col, row) = (calc.rem(i, 5), calc.quo(i, 5))
    place(dx: m + col * (tw + gap), dy: m + row * (th + label + gap), {
      place(block(width: tw, height: th, clip: true, place(top + left,
        if n == "microfilm" { pdf(n, height: th) } else { pdf(n, width: tw) })))
      place(rect(width: tw, height: th, stroke: 0.4pt + black))
      place(dy: th + 0.4cm, stack(spacing: 0.22cm,
        text(size: 14pt, weight: "bold", fill: rgb("#7d8590"), n),
        text(size: 10pt, fill: rgb("#7d8590"), looks.at(i))))
    })
  }
} else if fig == "details" {
  set page(width: 21cm, height: 13cm, margin: (x: 2cm, top: 1.8cm, bottom: 1.2cm))
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true)
  show: lookscanned.scan.with(
    preset: "office-scan",
    seed: 9,
    paper: (color: rgb("#f6f1e4"), aging: 0.25),
    edges: (staple: true, paperclip: true, dog-ear: true, folds: 1, torn: true, punch-holes: true),
  )
  grid(columns: (1fr, auto),
    [*LOREM IPSUM* \ #text(size: 9pt)[#lorem(9)]],
    lookscanned.stamp("Lorem", size: 12pt, angle: -9deg, seed: 5))
  v(0.2em)
  line(length: 100%, stroke: 0.6pt)
  [#lorem(10) #lookscanned.highlighter[#lorem(7)] #lorem(42)]
  v(0.2em)
  [#lorem(30) #lookscanned.highlighter(color: rgb("#9be36d"))[#lorem(8)] #lorem(26)]
  lookscanned.scribble(body: "lorem ipsum", color: rgb("#1f3a93"), at: (x: 64%, y: 74%))
  lookscanned.scribble(width: 3.4cm, color: rgb("#1f3a93"), seed: 2, at: (x: 12%, y: 82%))
  lookscanned.stain(at: (x: 86%, y: 58%), size: 26mm, seed: 4, over: true)
} else {
  panic("unknown figure " + repr(fig))
}
