#import "../typst/lib.typ" as lookscanned

#set page(paper: "a4", margin: 20mm)
#set text(font: "Libertinus Serif", size: 11pt)

#let urgent-fax = lookscanned.derive("fax", scanner: (lines: 1), ink: (bleed: 0.95, legibility: 0.5, wear: 0.55))

#show: lookscanned.scan.with(preset: urgent-fax, seed: 5)

#grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
  text(size: 30pt, weight: "bold")[FAX],
  text(font: "DejaVu Sans Mono", size: 9pt)[PAGE 1/3 \ 30.10.2026 09:42],
)
#line(length: 100%, stroke: 1.5pt)

#table(columns: (auto, 1fr), stroke: none, inset: 4pt,
  [*To*], [Lorem Ipsum & Co.],
  [*From*], [Dolor Sit Amet],
  [*Fax*], [+33 1 23 45 67 89],
  [*Re*], [#lorem(4)],
)
#line(length: 100%, stroke: 0.6pt)

#v(1em)
Dear Mr. Ipsum,

#lorem(70)

#lorem(50)

#table(
  columns: (1fr, auto, auto),
  inset: 6pt,
  stroke: 0.6pt,
  align: (left, right, right),
  table.header[*Item*][*Qty*][*Price*],
  [Lorem ipsum dolor], [12], [340.00],
  [Sit amet consectetur], [3], [1 250.00],
  [Adipiscing elit], [40], [86.40],
  [*Total*], [], [*1 676.40*],
)

#lorem(40)

#v(1.5em)
Sincerely, \
_D. S. Amet_

#lookscanned.stamp("Urgent", color: rgb("#b0201b"), angle: 8deg, size: 20pt, at: (x: 68%, y: 9%))
