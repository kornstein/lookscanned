# Architecture

lookscanned never rasterises the document. Typst lays it out as usual; the package adds images behind and in front of each page and changes how text is painted. This page describes the components, the plugin protocol and the rendering pipeline.

## Components

```text
typst/                     Typst package (published as is)
├── lib.typ                Public API: scan, page, region, re-exports
├── presets.typ            Neutral values (`base`) and built-in presets
├── validate.typ           Argument parsing, validation, merging, intensity scaling
├── wasm.typ               Plugin bindings: texture(), random-table()
├── decor.typ              stamp, stain, scribble
└── effects/
    ├── page.typ           Page background and foreground, per-page overrides
    ├── jitter.typ         Seeded hashing, page rotation, block and text show rules
    └── ink.typ            Ink paint: textured fill and stroke, fading, ghosting

src/                       Rust plugin, compiled to wasm32-unknown-unknown
├── lib.rs                 Plugin entry points
├── params.rs              CBOR parameter decoding
├── rng.rs                 SplitMix64, lattice hash, value noise, fBm
├── encode.rs              Raster buffer and PNG encoder
├── jitter.rs              Random table
└── texture/               One module per family of textures
```

The split follows what each side does efficiently. Generating millions of noisy pixels is cheap in compiled code and impractical in Typst; placing and transforming content is what Typst is for, and keeping it there means the output remains an ordinary Typst document.

## Plugin protocol

The plugin uses the [wasm-minimal-protocol](https://github.com/astrale-sharp/wasm-minimal-protocol) and exports two functions. Both are pure, so Typst memoises them.

### `texture(kind, params) -> png`

| Argument | Encoding |
|---|---|
| `kind` | UTF-8 name: `paper`, `grain`, `toner`, `ink`, `stains`, `dust`, `lines`, `edges` |
| `params` | CBOR map with string keys |

Parameter values are numbers, booleans, strings or arrays of numbers. The Typst side converts before encoding:

- lengths to pixels, at `resolution × factor(kind)` (see [Performance](../guide/performance.md#resolution));
- colours to `[r, g, b, a]` in 0–255;
- the target size to `w`, `h` in pixels, plus `ppmm` (pixels per millimetre) so that features keep a physical size.

Pixel dimensions are clamped to [1, 12000]. The result is an 8-bit PNG (grey + alpha, RGB or RGBA), zlib-compressed with no row filtering. An unknown kind returns an error, which Typst reports at the call site.

### `random(seed) -> bytes`

`seed` is a CBOR integer. The result is a table of 4096 random bytes. Typst reads it through `rnd(table, ..ints)`, which hashes its integer arguments to an index and maps the byte to [-1, 1]. Per-glyph randomness thus costs a hash and an array lookup, with no plugin call.

## Randomness and determinism

All randomness derives from the user `seed`:

- **Textures**: the plugin seeds a SplitMix64 generator, or a stateless lattice hash for noise, with `seed × 1000 + page` plus a per-layer offset.
- **Geometry**: rotations and offsets read the random table at an index computed from the seed and stable data: page number, vertical position of a block, a hash of the word's text.

No clock, counter or unseeded source is used, so a document compiles to the same PDF on every machine. A consequence is that equal words receive equal inking variations.

Noise is value noise with smoothstep interpolation, summed over octaves (fBm). Tileable textures (`grain`, `toner`, `ink`) wrap the noise lattice on the tile period, so tiles repeat without seams.

## Rendering pipeline

`scan(..args, body)` performs these steps:

1. **Parse and validate** (`validate.parse-args`): split `preset`, `intensity` and `seed` from theme dictionaries; check every theme, key, type and range against `base`.
2. **Resolve** (`validate.resolve`): merge `base`, the preset and the user's themes, one level deep; scale by `intensity`; draw the random table.
3. **Page layers** (`effects/page.typ`): set `page.background` and `page.foreground` to context blocks that, for each page, look up `lookscanned.page` overrides and place the textures.
4. **Block rotation** (`effects/jitter.typ`): a show rule on paragraphs, headings, lists, enumerations, term lists, figures, block equations and code blocks.
5. **Text paint** (`effects/jitter.typ`, `effects/ink.typ`): show rules on `text` and `math.equation`.

### Page rotation without reflow

Typst cannot rotate a page of flowing content without affecting pagination. Each block is instead rotated by the page angle θ about its own top-left corner and translated so that it lands where a rotation of the whole page about its centre would put it. For a block at (x, y) relative to the page centre:

```text
dx = x (cos θ − 1) − y sin θ
dy = x sin θ + y (cos θ − 1)
```

A small seeded translation, proportional to θ, is added per page. `rotate(.., reflow: false)` and `move` change where content is drawn, not the space it occupies, so line and page breaks are unaffected. The page angle is `page-rotation × ((1 − drift) r₁ + drift w)`, where `r₁` is an independent draw and `w` a value interpolated between draws every four pages.

Typst exposes no per-line hook, so `"line"` granularity jitters each block as a unit.

### Ink

Ink changes paint, not glyphs:

- the **fill** becomes a `tiling` of mottled ink with pinholes (`ink` texture, `mode: "fill"`);
- the **stroke** becomes a `tiling` of patchy coverage (`mode: "edge"`) of width proportional to `bleed`. A stroke is centred on the outline, so a patchy stroke grows each glyph by different amounts at different places;
- **fading** mixes the ink colour with the paper colour rather than adding transparency, because fill and stroke overlap inside the outline and transparency would draw a dark contour;
- fading is quantised to three levels and tiles are 8 mm squares, so a document contains few distinct tilings.

Math letters and symbols are not `text` elements, so the same paint is set on each `math.equation`. Text runs inside the equation then find a tiling fill and are left alone, which avoids double application.

### Strings from code

Strings produced by code (`#lorem(..)`, `#"a b"`) reach the `text` show rule as a single run. The rule splits them into words so that per-word boxes never prevent line breaks.

## Configuration flow for `page`

`lookscanned.page` emits two labelled metadata elements around its body. At each page, the background and foreground query these labels and, if the page lies between a start and an end, resolve the stored arguments with the document configuration as parent. Text show rules do not consult the overrides, which is why `page` affects page-level effects only.
