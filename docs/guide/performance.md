# Performance

Textures are generated during compilation by the WebAssembly plugin and embedded as images in the PDF. Typst runs plugins in an interpreter, so texture generation dominates compile time. The `quality` theme trades appearance against time and size.

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  quality: (resolution: 100, tile: true, granularity: "line"),
)
```

## `resolution`

DPI of the generated textures, default `150`. Pixel count grows with its square: `100` produces images about 45 % the size of `150`. Each kind is rendered at a fraction of it suited to its content:

| Kind | Resolution |
|---|---|
| `paper` | 1/8 |
| `stains` | 1/3 |
| `edges` | 1/10 |
| `ink` | 4× (glyph details are smaller than a stroke) |
| others | 1× |

## `tile`

With `tile: true` (default), one 40 mm grain tile is repeated on every page and stored once in the PDF. With `tile: false`, each page gets its own full-page grain: more varied, much heavier.

## `granularity`

| Value | Moves | Cost |
|---|---|---|
| `"page"` | Page rotation only | lowest |
| `"line"` | Each block (paragraph, heading, list, figure, block equation, code block) | low |
| `"word"` | Each word | higher; prevents hyphenation |
| `"char"` | Each character, vertically | highest |

## Caching

Typst memoises plugin calls: identical textures (same kind, size, seed and parameters) are generated once per compilation. Ink tiles are shared across the document, and fading is quantised to three levels so that only a few distinct ink tiles exist.

## Typical figures

| Document | Compile time | PDF size |
|---|---|---|
| One A5 page with equations (`tests/layout.typ`), built-in preset | 1.3–1.9 s | 130–220 KB |
| Four-page textbook excerpt (`examples/old-textbook.typ`) | 4.5 s | 470 KB |

Measured with Typst 0.15.1 on an Apple Silicon laptop; times include the first, uncached compilation.
