#import "../typst/lib.typ" as lookscanned

#set page(paper: "a4", margin: (x: 22mm, y: 20mm))
#set text(font: "Libertinus Serif", size: 12pt, fill: rgb("#5b3a8c"))
#set enum(numbering: "1.")

#show: lookscanned.scan.with(
  preset: "mimeograph",
  seed: 6,
  ink: (bleed: 0.95, wear: 0.45),
)

#let blank(n) = for _ in range(n) { block(width: 100%, height: 7mm, stroke: (bottom: 0.5pt), above: 0pt, below: 0pt) }

#grid(columns: (1fr, auto),
  [Name: #box(width: 50mm, stroke: (bottom: 0.5pt))],
  [Class: #box(width: 20mm, stroke: (bottom: 0.5pt))],
)

#v(1em)
#align(center, text(size: 20pt, weight: "bold")[Lorem Ipsum Dolor])
#align(center, text(size: 11pt, style: "italic")[#lorem(8)])

#v(1em)
#lorem(50)

+ #lorem(12)
  #blank(2)
+ #lorem(15)
  #blank(2)
+ Compute $3/4 + 5/6$ and $2^5 - 3^3$.
  #blank(2)
+ #lorem(10)
  #blank(3)

#v(1em)
#align(center, box(stroke: 1pt, inset: 10pt, width: 80%)[*Nota bene.* #lorem(20)])
