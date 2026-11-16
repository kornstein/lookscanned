// Test cases, run one by one by `run.typ`.
#import "/typst/lib.typ" as lookscanned
#import "/typst/presets.typ": base
#import "/typst/validate.typ": parse-args, resolve

#let cases = (
  // Text and line breaks must match `--input preset=none`.
  layout: () => [
    #let name = sys.inputs.at("preset", default: "office-scan")
    #set page(paper: "a5")
    #show: if name == "none" { x => x } else { lookscanned.scan.with(preset: name, seed: 3) }

    = Convergence of series

    Let $(u_n)$ be a sequence of non-negative real numbers. The series $sum u_n$
    converges if and only if its partial sums are bounded. #lorem(50)

    - Comparison: if $0 <= u_n <= v_n$ and $sum v_n$ converges, so does $sum u_n$.
    - Ratio test: if $u_(n+1) \/ u_n -> ell < 1$, then $sum u_n$ converges.

    $ sum_(n=1)^infinity 1 / n^2 = pi^2 / 6 $

    #line(length: 100%, stroke: 0.6pt)
    #rect[Bounded partial sums]
    #table(columns: 2, stroke: (x: none, y: 0.5pt), table.header[Test][Condition], table.hline(stroke: 1pt), [Ratio], [$ell < 1$])

    #lorem(70)
  ],

  // Custom preset, intensity, every granularity, page without height.
  settings: () => [
    #let mine = lookscanned.derive("fax", ink: (bleed: 0.2, ghosting: true))
    #set page(width: 10cm, height: auto)
    #show: lookscanned.scan.with(preset: mine, intensity: 1.5, seed: 9, quality: (granularity: "char", tile: false))

    = Titre
    #lorem(25)

    $ x^2 + y^2 = z^2 $

    #for g in ("page", "line", "word", "char") {
      lookscanned.region(preset: "typewriter", quality: (granularity: g))[#g : #lorem(8)]
    }
  ],

  rotation: () => [
    #set page(paper: "a6")
    #show: lookscanned.scan.with(preset: "clean-scan", skew: (page-rotation: 5deg, drift: 0), seed: 1)
    = Titre
    #lorem(30)

    #lorem(20)
  ],

  // `none` resets a theme or a key.
  neutral: () => [
    #let cfg(..args) = resolve(parse-args(args, "test"))
    #let c = cfg(preset: "old-paper", stains: none, paper: none, ink: (bleed: none))
    #assert.eq(c.stains, base.stains)
    #assert.eq(c.paper, base.paper)
    #assert.eq(c.ink.bleed, 0)
    #assert.eq(c.ink.fade, 0.4)
    #assert.eq(cfg(preset: "photocopy", edges: (shadow: 0.3, vignette: none)).edges.vignette, 0)
    #assert.eq(cfg(preset: lookscanned.presets.fax + (scanner: none)).scanner, base.scanner)

    #set page(paper: "a6")
    #show: lookscanned.scan.with(preset: "old-paper", seed: 2)
    #lookscanned.page(stains: none, edges: none)[= Title]
    #pagebreak()
    #lookscanned.region(ink: none, skew: none)[#lorem(20)]
  ],

  damage: () => [
    #set page(paper: "a5")
    #show: lookscanned.scan.with(
      preset: "old-paper",
      seed: 4,
      edges: (folds: 2, dog-ear: true, staple: true, paperclip: true, torn: true),
    )
    = Letter
    #lorem(220)
  ],

  // Every kind, with and without the page as reference size.
  textures: () => [
    #set page(width: 12cm, height: 8cm, margin: 0pt)
    #set page(background: lookscanned.texture("paper", seed: 3, color: rgb("#f0e6d2"), grain: 0.5, aging: 0.6))
    #set page(foreground: lookscanned.texture("dust", seed: 3, amount: 0.4, scratches: 0.5))
    #grid(
      columns: 4,
      ..("grain", "toner", "stains", "edges", "damage").map(k => lookscanned.texture(
        k, width: 3cm, height: 3cm, amount: 1, shadow: 1, color: red, min: 5mm, max: 12mm, folds: 1, staple: true,
      )),
      lookscanned.texture("lines", width: 3cm, height: 3cm, amount: 1, axis: "h"),
      lookscanned.texture("lines", width: 3cm, height: 3cm, amount: 1, axis: "v"),
    )
  ],

  // docs/reference/api.md, docs/guide/presets.md, docs/reference/themes.md
  docs-presets: () => [
    #assert.eq(lookscanned.presets.keys(), ("clean-scan", "office-scan", "photocopy", "fax", "typewriter", "old-paper", "phone-scan", "mimeograph", "microfilm", "newsprint"))
    #let p = lookscanned.presets
    #let soft-fax = lookscanned.derive("fax", ink: (bleed: 0.2))
    #assert.eq(soft-fax.ink, (bleed: 0.2, fade: 0.35, legibility: 0.6, wear: 0.45))
    #assert.eq(soft-fax, lookscanned.derive(p.fax, ink: (bleed: 0.2)))
    #assert.eq(soft-fax.paper, p.fax.paper)
    #assert.eq(lookscanned.derive("fax", ink: none).ink, base.ink)
    #assert.eq(lookscanned.derive("fax", ink: (fade: none)).ink.fade, base.ink.fade)
    #assert.eq(lookscanned.derive("fax"), p.fax)
    #let my-scan = (
      paper: (color: rgb("#eef4ff"), grain: 0.3),
      ink: (bleed: 0.5, fade: 0.2),
      skew: (page-rotation: 0.8deg),
      edges: (shadow: 0.4),
    )
    #let library-copy = lookscanned.derive("old-paper", edges: (binding: true, shadow: 0.4))

    #set page(width: 12cm, height: 9cm)
    #show: lookscanned.scan.with(
      preset: soft-fax,
      seed: 7,
      intensity: 0.7,
      paper: (color: rgb("#f4efe4"), grain: 0.4, aging: 0.2, fibers: 0),
      stains: (color: rgb("#8b5a2b"), amount: 0.3, size: (min: 2mm, max: 15mm), dust: 0.5, scratches: 0),
      ink: (bleed: 0.4, fade: 0.2, legibility: 0.8, wear: 0, ghosting: false),
      skew: (page-rotation: 0.6deg, line-jitter: 0.15deg, char-jitter: 0pt, drift: 0.3),
      edges: (shadow: 0.5, vignette: 0.3, uneven: 0, binding: false, punch-holes: true,
        folds: 2, dog-ear: true, staple: false, paperclip: true, torn: false),
      scanner: (lines: 0.5, bands: 0.4),
      quality: (resolution: 100, tile: true, granularity: "line"),
    )

    = Lorem ipsum
    #lorem(20)

    $ integral_0^1 x^2 dif x = 1/3 $

    #pagebreak()
    #lookscanned.page(preset: my-scan, stains: (amount: 1), skew: (page-rotation: 2deg), edges: (binding: true))[
      = Dolor sit amet
      #lorem(20)
    ]

    #pagebreak()
    #lookscanned.page(preset: library-copy)[#lorem(10)]
  ],

  // docs/getting-started.md
  docs-start: () => [
    #set page(width: 12cm, height: 7cm, margin: (x: 1cm, y: 0.9cm))
    #set text(font: "New Computer Modern", size: 10pt)
    #set par(justify: true)
    #show: lookscanned.scan.with(
      preset: "office-scan",
      seed: 7,
      intensity: 1.6,
      paper: (color: rgb("#f3ead6"), aging: 0.4),
      ink: (bleed: 0.6),
    )

    = Lorem ipsum

    #lorem(30)

    $ integral_0^1 x^2 dif x = 1/3 $

    #lookscanned.stamp("Lorem ipsum", color: rgb("#5b3a8c"), at: (x: 62%, y: 76%), size: 10pt)
  ],

  // docs/guide/text.md
  docs-text: () => [
    #set page(width: 12cm, height: 9cm)
    #show: lookscanned.scan.with(
      preset: "fax",
      ink: (bleed: 0.6, fade: 0.3, wear: 0.2, legibility: 0.9, ghosting: true),
      skew: (page-rotation: 0.9deg, line-jitter: 0.3deg),
      quality: (granularity: "word"),
    )

    = Lorem ipsum
    #lorem(30)

    $ integral_0^1 x^2 dif x = 1/3 $

    #lorem(10)

    #line(length: 100%, stroke: 0.6pt)
    #rect[#lorem(6)]
    #table(columns: 2, stroke: (x: none, y: 0.5pt), table.header[Lorem][Ipsum], table.hline(stroke: 1pt), [Dolor], [Sit])
  ],

  // docs/guide/page.md
  docs-page: () => [
    #set page(width: 12cm, height: 9cm)
    #show: lookscanned.scan.with(
      preset: "old-paper",
      paper: (color: rgb("#f4efe4"), grain: 0.5, aging: 0.4, fibers: 0.4),
      stains: (color: rgb("#8b5a2b"), amount: 0.4, size: (min: 5mm, max: 25mm), dust: 0.6, scratches: 0.3),
      edges: (shadow: 0.6, vignette: 0.4, uneven: 0.3, binding: true, punch-holes: true,
        folds: 1, dog-ear: true, staple: true, paperclip: true, torn: true),
      scanner: (lines: 0.5, bands: 0.4),
    )

    = Lorem ipsum
    #lorem(60)
  ],

  // docs/guide/pages-and-regions.md
  docs-pages: () => [
    #set page(width: 12cm, height: 9cm)
    #lookscanned.region(preset: "typewriter", seed: 2)[
      = Lorem ipsum
      #lorem(20)
    ]
    #show: lookscanned.scan.with(preset: "office-scan")

    = Lorem ipsum
    #lorem(20)

    #pagebreak()
    #lookscanned.page(stains: (amount: 1), skew: (page-rotation: 2deg), edges: (binding: true))[
      = Dolor sit amet
      #lorem(20)
    ]
  ],

  // docs/guide/templates.md
  docs-templates: () => [
    #set page(width: 10cm, height: 8cm)
    #show: lookscanned.scan.with(preset: "old-paper", seed: 12, edges: (binding: true))
    #show heading: it => block(stroke: 0.4pt, inset: 4pt, it)

    = Lorem ipsum

    #block[#lorem(30)]
  ],

  // docs/guide/decorations.md
  docs-decorations: () => [
    #set page(width: 12cm, height: 9cm)
    #show: lookscanned.scan.with(preset: "office-scan", seed: 7)
    #lookscanned.stamp("Lorem ipsum", color: rgb("#5b3a8c"))
    #lookscanned.stamp("Dolor sit amet", angle: 9deg, at: (x: 70%, y: 80%))
    #lookscanned.scribble(body: "lorem ipsum", color: blue)
    #lookscanned.scribble(width: 3.2cm, seed: 4)
    #lookscanned.stain(at: (x: 60%, y: 20%), color: rgb("#6b4423"), size: 25mm)
    #lookscanned.stain()
    #lookscanned.stain(at: (x: 30%, y: 50%), over: true)
    #lorem(8) #lookscanned.highlighter[#lorem(4)] #lorem(8) #lookscanned.highlighter(color: rgb("#7be07b"), seed: 5)[#lorem(6)]
  ],

  // docs/guide/textures.md
  docs-textures: () => [
    #set page(width: 12cm, height: 9cm)
    #let grain = tiling(size: (4cm, 4cm), lookscanned.texture("grain", width: 4cm, height: 4cm, amount: 0.6))
    #rect(width: 100%, height: 1cm, fill: grain)
    #lookscanned.texture("stains", width: 2cm, height: 2cm, count: 1, min: 15mm, max: 18mm)

    #set page(background: {
      place(lookscanned.texture("paper", seed: 1, color: rgb("#f4efe4"), aging: 0.3))
      place(center + horizon, text(60pt, fill: luma(225))[Lorem ipsum])
    })
    #lorem(10)
  ],

  // Regressions: flipped page without height, intensity 0, labels, stain outside scan.
  regressions: () => [
    #let cfg(..args) = resolve(parse-args(args, "test"))
    #let off = cfg(preset: "mimeograph", intensity: 0, edges: (dog-ear: true, staple: true, binding: true), ink: (ghosting: true))
    #assert.eq(off.edges, base.edges)
    #assert.eq(off.ink.ghosting, false)
    #set page(width: 8cm, height: auto, flipped: true)
    #lookscanned.stain(over: true)
    #lookscanned.region[#lookscanned.stain(over: true, at: (x: 50%, y: 0%))]
    #show: lookscanned.scan.with(preset: "photocopy")
    #lorem(20)
    #table(columns: 2, [a], [b]) <labelled>
    #rect[labelled] <box>
    #lookscanned.highlighter[#lorem(5)]
    #columns(2)[#lorem(30) #lookscanned.highlighter[normal #text(size: 16pt)[big] #lorem(40)]]
  ],
)
