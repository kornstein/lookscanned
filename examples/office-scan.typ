#import "../typst/lib.typ" as lookscanned

#set page(paper: "a4", margin: (x: 20mm, y: 18mm))
#set text(font: "Libertinus Serif", size: 11pt)

#show: lookscanned.scan.with(
  preset: "office-scan",
  seed: 17,
  ink: (bleed: 0.45, fade: 0.25, wear: 0.15),
  edges: (punch-holes: true, paperclip: true),
)

#let pen = rgb("#1b3a8f")
#let field(label, value) = block(width: 100%, below: 10pt, {
  text(size: 7pt, upper(label))
  block(width: 100%, inset: (x: 3pt, y: 4pt), stroke: (bottom: 0.6pt), text(fill: pen, style: "italic", value))
})
#let check(on) = box(width: 8pt, height: 8pt, stroke: 0.7pt, baseline: 1pt, if on { align(center + horizon, text(fill: pen)[×]) })
#let section(title) = block(width: 100%, fill: luma(30), inset: (x: 6pt, y: 4pt), above: 16pt, below: 10pt,
  text(fill: white, weight: "bold", size: 9pt, upper(title)))

#grid(columns: (1fr, auto), align: horizon,
  [
    #text(size: 16pt, weight: "bold")[Lorem Ipsum Application] \
    #text(size: 9pt)[Form LX-42 · #lorem(6)]
  ],
  box(stroke: 0.8pt, inset: 6pt, text(size: 8pt)[No. *15497\*03*]),
)

#text(size: 8pt, style: "italic")[#lorem(25)]

#section[Applicant]
#grid(columns: (1fr, 1fr), column-gutter: 12pt,
  field("Surname", "Dolor"), field("First name", "Sit Amet"),
  field("Date of birth", "14 / 03 / 1987"), field("Place of birth", "Lutetia"),
)
#field("Address", "12, Via Consectetur, Lutetia")

#section[Purpose]
#grid(columns: (1fr, 1fr), row-gutter: 8pt,
  [#check(true) #h(4pt) Lorem ipsum], [#check(false) #h(4pt) Dolor sit],
  [#check(false) #h(4pt) Amet consectetur], [#check(true) #h(4pt) Adipiscing elit],
)

#section[Documents]
#table(
  columns: (auto, 1fr, auto),
  inset: 5pt,
  stroke: 0.5pt,
  align: (center, left, center),
  table.header[*No.*][*Document*][*Enclosed*],
  [1], [#lorem(5)], check(true),
  [2], [#lorem(7)], check(true),
  [3], [#lorem(4)], check(false),
)

#section[Declaration]
#lookscanned.highlighter[#lorem(18)] #lorem(20)

#v(8pt)
#grid(columns: (1fr, 1fr), column-gutter: 14pt,
  field("Place and date", "Lutetia, 28 / 10 / 2026"),
  block(width: 100%, height: 18mm, stroke: 0.6pt, inset: 6pt)[
    #text(size: 7pt)[SIGNATURE]
    #lookscanned.scribble(width: 34mm, color: pen, seed: 6, angle: -6deg)
  ],
)

#v(12pt)
#block(width: 100%, stroke: (dash: "dashed", thickness: 0.6pt), inset: 8pt)[
  #text(size: 8pt, weight: "bold")[FOR OFFICIAL USE ONLY]
  #grid(columns: (1fr, 1fr, 1fr), [File no.: LX-2026-0815], [Officer: M.R.], [Decision:])
]

#lookscanned.stamp("Received 29 Oct 2026", color: rgb("#1d3f8f"), angle: -6deg, size: 11pt, seed: 2, at: (x: 60%, y: 25%))
#lookscanned.stamp("Granted", color: rgb("#1f7a3a"), angle: 9deg, size: 18pt, seed: 5, at: (x: 72%, y: 93%))
