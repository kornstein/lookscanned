#import "../typst/lib.typ" as lookscanned

#set page(paper: "a4", margin: (x: 25mm, y: 22mm))
#set text(font: "New Computer Modern", size: 11pt)
#set par(justify: true)
#set enum(numbering: n => strong[#n.])

#show: lookscanned.scan.with(
  preset: "photocopy",
  seed: 9,
  ink: (bleed: 0.9, wear: 0.35),
  edges: (staple: true),
)

#grid(columns: (1fr, auto),
  [*Lorem Analysis II* \ Problem sheet 3],
  align(right)[Week 5 \ Due Monday],
)
#line(length: 100%, stroke: 0.6pt)

= Exercitationes

+ #lorem(30)
  $ sum_(n = 1)^infinity 1 / n^2 = pi^2 / 6 $

+ #lorem(25) Show that for all $x > 0$,
  $ ln(1 + x) <= x . $

+ #lorem(40)

  #align(right, lookscanned.scribble(body: "→ same idea as Ex. 2", color: rgb("#1a4fa0")))

+ Let $A in cal(M)_n (RR)$ be symmetric. #lorem(20)
  $ A = P D P^(-1), quad D = mat(lambda_1, , ; , dots.down, ; , , lambda_n) $

#pagebreak()

#lookscanned.page(skew: (page-rotation: 2deg), scanner: (bands: 0.9), stains: (dust: 1))[
  = Solutiones

  #lorem(60)

  $ integral_0^1 x^n dif x = 1 / (n + 1) $

  #lorem(80)

  #table(
    columns: (1fr, 1fr, 1fr),
    inset: 6pt,
    table.header[*$n$*][*$u_n$*][*$S_n$*],
    [1], [1.000], [1.000],
    [2], [0.250], [1.250],
    [3], [0.111], [1.361],
    [4], [0.063], [1.424],
  )

  #lorem(50)
]
