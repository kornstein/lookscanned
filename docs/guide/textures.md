# Performance and textures

Textures are generated at compile time by the WebAssembly plugin and embedded as images. Plugins run in an interpreter, so texture generation dominates compile time.

## The `quality` theme

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  quality: (resolution: 100, tile: true, granularity: "line"),
)
```

| Key | Default | Effect on cost |
|---|---|---|
| `resolution` | `150` | Texture DPI. Cost grows with its square: `100` is about 45 % of `150`. |
| `tile` | `true` | One 40 mm grain tile shared by every page. `false`: a full-page grain per page, much heavier. |
| `granularity` | `"line"` | What jitters. See below. |

| `granularity` | Moves | Cost |
|---|---|---|
| `"page"` | Page rotation only | lowest |
| `"line"` | Each block: paragraph, heading, list, figure, block equation, code block | low |
| `"word"` | Each word; prevents hyphenation | higher |
| `"char"` | Each character, vertically | highest |

Each texture kind uses a fraction of `resolution` suited to its detail: `paper` 1/8, `edges` 1/10, `stains` 1/3, `damage` 1/2, ink 4×, others 1×.

Typst memoises plugin calls, so identical textures are generated once. Ink fading is quantised to three levels to keep the number of distinct ink tiles low.

**Typical figures** (Typst 0.15.1, Apple Silicon, uncached): one A5 page with equations, 1.3–1.9 s, 130–220 KB; a two-page problem sheet with a page override, 2.5 s, 280 KB.

## Raw textures

`lookscanned.texture(kind, ..)` returns a generated image on its own, for custom backgrounds or fills.

![The ten texture kinds](../assets/img/textures.png)

```typst
#set page(background: lookscanned.texture("paper", seed: 3, color: rgb("#f0e6d2"), grain: 0.5))
#lookscanned.texture("stains", width: 4cm, height: 4cm, count: 1, min: 25mm, max: 30mm)
```

Without `width` and `height`, the image takes the page size (needs a fixed page height).

`grain`, `toner` and `ink` tile seamlessly:

```typst
#let grain = tiling(size: (4cm, 4cm), lookscanned.texture("grain", width: 4cm, height: 4cm, amount: 0.6))
#rect(width: 100%, height: 3cm, fill: grain)
```

`scan` owns the page `background` and `foreground`, and a later `set page(background: ..)` replaces them. To mix your own layers with textures, build the background yourself instead of using `scan`:

```typst
#set page(background: {
  place(lookscanned.texture("paper", seed: 1, color: rgb("#f4efe4"), aging: 0.3))
  place(center + horizon, text(60pt, fill: luma(225))[DRAFT])
})
```

Kinds and parameters: [Textures reference](../reference/textures.md).
