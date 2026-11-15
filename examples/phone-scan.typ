#import "../typst/lib.typ" as lookscanned

#set page(paper: "a5", margin: 15mm)
#set text(font: "New Computer Modern", size: 10pt)

#show: lookscanned.scan.with(
  preset: "phone-scan",
  seed: 4,
  intensity: 1.4,
  ink: (bleed: 0.4, fade: 0.2, wear: 0.15),
  edges: (torn: true),
)

#let red = rgb("#c8231a")
#let answer(body) = block(inset: (left: 4mm), above: 6pt, below: 12pt,
  text(fill: rgb("#1b3a8f"), style: "italic", body))

#grid(columns: (1fr, auto), align: horizon,
  [
    #text(size: 14pt, weight: "bold")[Midterm examination] \
    #text(size: 8pt)[Lorem Analysis II · 2 h]
  ],
  lookscanned.stamp("12/20", color: red, size: 18pt, angle: -8deg),
)
#line(length: 100%, stroke: 1pt)

*Exercise 1.* Let $f(x) = x^2 e^(-x)$. Compute $f'(x)$.

#answer[$f'(x) = x (2 - x) e^(-x)$, so $f$ increases on $[0, 2]$.]

*Exercise 2.* #lorem(18)
$ sum_(n = 1)^infinity (-1)^(n + 1) / n = ln 2 $

#answer[#lorem(20)]
#align(right, lookscanned.scribble(body: "only for |x| < 1 !", color: red))

*Exercise 3.* #lorem(15)

#answer[#lorem(12) #lookscanned.scribble(width: 2cm, color: red, seed: 2)]

*Exercise 4.* #lorem(20)
$ integral_0^1 x^n dif x = 1 / (n + 1) $

#answer[#lorem(25)]
