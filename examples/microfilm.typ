#import "../typst/lib.typ" as lookscanned

#set page(paper: "a4", flipped: true, margin: (x: 18mm, y: 16mm), columns: 2)
#set columns(gutter: 14mm)
#set text(font: "Libertinus Serif", size: 10pt)
#set par(justify: true)

#show: lookscanned.scan.with(
  preset: "microfilm",
  seed: 21,
  ink: (bleed: 0.75, wear: 0.4),
)

#place(top, scope: "parent", float: true)[
  #grid(columns: (1fr, auto), align: bottom,
    text(size: 20pt, weight: "bold")[Acta Consilii Ipsum · MDCCCLXXII],
    text(font: "DejaVu Sans Mono", size: 8pt)[REEL 042 · FRAME 0137],
  )
  #line(length: 100%, stroke: 1pt)
]

== Sessio prima
#lorem(110)

#lorem(80)

== Rationes
#lorem(30)

#table(
  columns: (1fr, auto, auto),
  inset: 5pt,
  stroke: 0.5pt,
  align: (left, right, right),
  table.header[*Titulus*][*Accepta*][*Expensa*],
  [Lorem ipsum], [1 240], [—],
  [Dolor sit amet], [—], [385],
  [Consectetur], [612], [—],
  [Adipiscing elit], [—], [1 090],
  [*Summa*], [*1 852*], [*1 475*],
)

== Sessio secunda
#lorem(140)

#lorem(60)
