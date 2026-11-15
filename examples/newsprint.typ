#import "../typst/lib.typ" as lookscanned

#set page(paper: "a4", margin: (x: 14mm, y: 12mm))
#set text(font: "Libertinus Serif", size: 8.5pt)
#set par(justify: true, leading: 0.5em)
#show heading: set text(size: 12pt)

#show: lookscanned.scan.with(
  preset: "newsprint",
  seed: 14,
  ink: (bleed: 0.8, wear: 0.35),
)

#align(center)[
  #text(size: 40pt, weight: "bold")[The Daily Ipsum]
  #v(-1.2em)
  #line(length: 100%, stroke: 2pt)
  #v(-0.8em)
  #grid(columns: (1fr, 1fr, 1fr),
    align(left)[Vol. XII · No. 42], [Lutetia, Tuesday 14 March 1957], align(right)[Price 15 c.],
  )
  #v(-0.8em)
  #line(length: 100%, stroke: 0.6pt)
  #text(size: 24pt, weight: "bold")[Lorem Ipsum Dolor Sit Amet]
  #v(-0.6em)
  #text(size: 11pt, style: "italic")[#lorem(14)]
]

#columns(3, gutter: 5mm)[
  #lorem(120)

  #lorem(90) #lookscanned.highlighter[#lorem(12)] #lorem(40)

  = #lorem(5)

  #lorem(130)

  #block(stroke: (y: 0.6pt), inset: (y: 6pt))[
    #text(size: 11pt, style: "italic")[« #lorem(14) »]
  ]

  #lorem(110)

  = #lorem(4)

  #lorem(150)

  #lorem(80)

  #block(width: 100%, stroke: 0.8pt, inset: 6pt)[
    #align(center)[*Classified*]
    *For sale.* #lorem(14) \
    *Wanted.* #lorem(12) \
    *To let.* #lorem(16)
  ]
]

#lookscanned.stamp("Archives", color: rgb("#1d3f8f"), angle: 6deg, size: 12pt, seed: 7, at: (x: 82%, y: 1%))
