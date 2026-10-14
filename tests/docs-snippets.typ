// Code shown in docs/ must keep compiling and mean what the docs say.
#import "/typst/lib.typ" as lookscanned

#set page(width: 12cm, height: 9cm)

// reference/api.md
#assert.eq(lookscanned.presets.keys(), ("clean-scan", "office-scan", "photocopy", "fax", "typewriter", "old-paper", "phone-scan"))

// how-to/custom-presets.md: theme-wise merge keeps the other ink keys.
#let p = lookscanned.presets
#let soft-fax = p.fax + (ink: p.fax.ink + (bleed: 0.2))
#assert.eq(soft-fax.ink, (bleed: 0.2, fade: 0.35, legibility: 0.6, wear: 0.45))
#let my-scan = (
  paper: (color: rgb("#eef4ff"), grain: 0.3),
  ink: (bleed: 0.5, fade: 0.2),
  skew: (page-rotation: 0.8deg),
  edges: (shadow: 0.4),
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

= Report
#lorem(20)

#lookscanned.stamp("Received")
#lookscanned.stamp("Paid", color: rgb("#1f4e9c"), angle: 8deg, at: (x: 70%, y: 80%))
#lookscanned.scribble(body: "Seen, OK", color: blue)
#lookscanned.scribble(width: 3.5cm, seed: 4)
#lookscanned.stain(at: (x: 60%, y: 20%), color: rgb("#6b4423"), size: 25mm)
#lookscanned.stain()

#pagebreak()
#lookscanned.page(preset: my-scan, stains: (amount: 1), skew: (page-rotation: 2deg), edges: (binding: true))[
  = Damaged appendix
  #lorem(20)
]

// how-to/raw-textures.md
#let grain = tiling(size: (4cm, 4cm), lookscanned.texture("grain", width: 4cm, height: 4cm, amount: 0.6))
#rect(width: 100%, height: 1cm, fill: grain)
#lookscanned.texture("stains", width: 2cm, height: 2cm, count: 1, min: 15mm, max: 18mm)
