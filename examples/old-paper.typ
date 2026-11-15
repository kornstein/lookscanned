#import "../typst/lib.typ" as lookscanned

#set page(width: 139.7mm, height: 215.9mm, margin: (x: 18mm, top: 20mm, bottom: 22mm))
#set text(font: "Libertinus Serif", size: 10.5pt)
#set par(justify: true, first-line-indent: 1em)

#show: lookscanned.scan.with(
  preset: "old-paper",
  seed: 12,
  ink: (bleed: 0.45, fade: 0.5, wear: 0.2),
  edges: (binding: true, dog-ear: true),
)

#lookscanned.stain(at: (x: 80%, y: 32%), color: rgb("#4a2a10"), size: 32mm, seed: 3, over: true)
#lookscanned.stamp("Bibl. Univ. Ipsum", color: rgb("#5b3a8c"), angle: 7deg, size: 8pt, seed: 4, at: (x: 50%, y: 92%))

#align(center)[
  #text(size: 8pt, tracking: 0.2em)[CAPUT III]
  #v(-0.4em)
  #text(size: 16pt)[De Lorem Geometria]
]

#v(1em)
#lorem(60)

#block(inset: (left: 1em), stroke: (left: 0.6pt))[
  *Theorema 3.1.* _If $A$, $B$, $C$ lie on a circle and $[A B]$ is a diameter,
  then $angle A C B$ is a right angle._
]
#align(right, lookscanned.scribble(body: "cf. Euclid III.31", color: rgb("#4a4a52"), angle: -4deg))

#lorem(30) #lookscanned.highlighter(color: rgb("#e8b04a"))[#lorem(14)] #lorem(20)

$ angle A C B = (pi - angle A O C) / 2 + (pi - angle B O C) / 2 = pi / 2 $

#lorem(45)
