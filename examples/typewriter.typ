#import "../typst/lib.typ" as lookscanned

#set page(paper: "a4", margin: (x: 25mm, y: 30mm))
#set text(font: "DejaVu Sans Mono", size: 10pt)
#set par(leading: 0.9em)

#show: lookscanned.scan.with(
  preset: "typewriter",
  seed: 9,
  intensity: 1.3,
  ink: (fade: 0.65, wear: 0.5),
  edges: (folds: 2, paperclip: true),
)

#align(right)[Lutetia, 12 October 1957]

#v(1.5em)
LOREM IPSUM & SONS \
14, Via Dolor Sit Amet \
LUTETIA

#v(1.5em)
REF: AD/1957/042 #h(1fr) SUBJ: #lorem(2)

#v(1em)
Dear Sir,

#lorem(60)

#lorem(45)

#lorem(55)

#v(1em)
Yours faithfully,

#v(1em)
#text(size: 20pt, lookscanned.scribble(body: "A. Dolor", color: rgb("#1b2a6b"), angle: -2deg))

A. DOLOR \
Secretary General

#lookscanned.stamp("Received 15 Oct 1957", color: rgb("#5b3a8c"), angle: 5deg, size: 10pt, seed: 3, at: (x: 60%, y: 85%))
