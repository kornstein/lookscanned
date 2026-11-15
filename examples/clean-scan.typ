#import "../typst/lib.typ" as lookscanned

#set page(paper: "a4", margin: (x: 18mm, y: 22mm), columns: 2)
#set text(font: "New Computer Modern", size: 10pt)
#set par(justify: true)
#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")

#show: lookscanned.scan.with(
  preset: "clean-scan",
  seed: 2,
  ink: (bleed: 0.3, fade: 0.1, wear: 0.1),
  edges: (staple: true),
)

#place(top + center, scope: "parent", float: true)[
  #text(size: 18pt, weight: "bold")[Lorem ipsum dolor sit amet]
  #v(0.2em)
  D. Sit #h(2em) A. Consectetur #h(2em) E. Adipiscing
  #v(0.6em)
  #block(width: 85%, align(left, text(size: 9pt)[*Abstract.* #lorem(60)]))
  #v(1em)
]

= Introduction

#lorem(90)

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2 $

#lorem(70)

= Methodus

#lorem(45)

$ f(x) = sum_(n = 0)^infinity (f^((n))(a)) / n! (x - a)^n $

#lorem(40)

#figure(
  table(
    columns: 3,
    stroke: none,
    align: (left, right, right),
    table.hline(),
    table.header[*Lorem*][*Ipsum*][*Dolor*],
    table.hline(stroke: 0.5pt),
    [Sit amet], [0.42], [1.73],
    [Consectetur], [0.57], [2.08],
    [Adipiscing], [0.61], [2.45],
    [Elit sed], [0.38], [1.12],
    table.hline(),
  ),
  caption: [#lorem(10)],
)

#lorem(60)

= Conclusio

#lorem(110)
