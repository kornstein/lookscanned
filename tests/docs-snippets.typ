// Code shown in docs/ must keep compiling and mean what the docs say.
#import "/typst/lib.typ" as lookscanned

#set page(width: 12cm, height: 9cm)

// reference/api.md
#assert.eq(lookscanned.presets.keys(), ("clean-scan", "office-scan", "photocopy", "fax", "typewriter", "old-paper", "phone-scan"))

// guide/custom-presets.md: theme-wise merge keeps the other ink keys.
#let p = lookscanned.presets
#let soft-fax = p.fax + (ink: p.fax.ink + (bleed: 0.2))
#assert.eq(soft-fax.ink, (bleed: 0.2, fade: 0.35, legibility: 0.6, wear: 0.45))
#let my-scan = (
  paper: (color: rgb("#eef4ff"), grain: 0.3),
  ink: (bleed: 0.5, fade: 0.2),
  skew: (page-rotation: 0.8deg),
  edges: (shadow: 0.4),
)
#let library-copy = lookscanned.presets.at("old-paper") + (
  edges: (binding: true, shadow: 0.4, vignette: 0.5),
)

#show: lookscanned.scan.with(
  preset: soft-fax,
  seed: 7,
  intensity: 0.7,
  paper: (color: rgb("#f4efe4"), grain: 0.4, aging: 0.2, fibers: 0),
  stains: (color: rgb("#8b5a2b"), amount: 0.3, size: (min: 2mm, max: 15mm), dust: 0.5, scratches: 0),
  ink: (bleed: 0.4, fade: 0.2, legibility: 0.8, wear: 0, ghosting: false),
  skew: (page-rotation: 0.6deg, line-jitter: 0.15deg, char-jitter: 0pt, drift: 0.3),
  edges: (shadow: 0.5, vignette: 0.3, uneven: 0, binding: false, punch-holes: true),
  scanner: (lines: 0.5, bands: 0.4),
  quality: (resolution: 100, tile: true, granularity: "line"),
)

= Cauchy sequences
A sequence $(u_n)$ is a _Cauchy sequence_ if for every $epsilon > 0$ there
exists $N$ such that $abs(u_p - u_q) <= epsilon$ for all $p, q >= N$.

// guide/decorations.md
#lookscanned.stamp("Library copy", color: rgb("#5b3a8c"))
#lookscanned.stamp("Marked", angle: 9deg, at: (x: 70%, y: 80%))
#lookscanned.scribble(body: "see Thm 1.4", color: blue)
#lookscanned.scribble(width: 3.2cm, seed: 4)
#lookscanned.stain(at: (x: 60%, y: 20%), color: rgb("#6b4423"), size: 25mm)
#lookscanned.stain()

#pagebreak()
#lookscanned.page(preset: my-scan, stains: (amount: 1), skew: (page-rotation: 2deg), edges: (binding: true))[
  = Appendix: tables
  #lorem(20)
]

#pagebreak()
#lookscanned.page(preset: library-copy)[#lorem(10)]

// guide/textures.md
#let grain = tiling(size: (4cm, 4cm), lookscanned.texture("grain", width: 4cm, height: 4cm, amount: 0.6))
#rect(width: 100%, height: 1cm, fill: grain)
#lookscanned.texture("stains", width: 2cm, height: 2cm, count: 1, min: 15mm, max: 18mm)

#set page(background: {
  place(lookscanned.texture("paper", seed: 1, color: rgb("#f4efe4"), aging: 0.3))
  place(center + horizon, text(60pt, fill: luma(225))[DRAFT])
})
