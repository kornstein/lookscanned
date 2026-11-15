# Internals

## How it works

lookscanned never rasterises the document. Typst lays it out as usual; the package adds images behind and in front of each page and changes how text and strokes are painted.

### Components

```text
typst/                     Typst package (published as is)
├── lib.typ                Public API: scan, page, region, derive, re-exports
├── presets.typ            Neutral values (`base`) and built-in presets
├── validate.typ           Argument checks, merging, `none` resets, intensity
├── wasm.typ               Plugin bindings: texture(), random-table()
├── decor.typ              stamp, scribble, stain, highlighter
└── effects/
    ├── page.typ           Background and foreground layers, `page` overrides
    ├── jitter.typ         Seeded hashing, page rotation, show rules
    └── ink.typ            Ink paint for text and strokes

src/                       Rust plugin, compiled to wasm32-unknown-unknown
├── lib.rs                 Entry points
├── params.rs              CBOR parameter decoding
├── rng.rs                 SplitMix64, lattice hash, value noise, fBm
├── encode.rs              Raster buffer and PNG encoder
├── jitter.rs              Random table
└── texture/               One module per texture family
```

Rust generates pixels; Typst places and transforms content. The output remains an ordinary Typst document.

### Plugin protocol

[wasm-minimal-protocol](https://github.com/astrale-sharp/wasm-minimal-protocol), two pure functions (memoised by Typst).

**`texture(kind, params) -> png`.** `kind` is the UTF-8 name (`paper`, `grain`, `toner`, `ink`, `stains`, `dust`, `lines`, `edges`, `damage`, `marker`). `params` is a CBOR map of numbers, booleans, strings and number arrays. Before encoding, Typst converts lengths to pixels at `resolution × factor(kind)`, colours to `[r, g, b, a]` in 0–255, and the size to `w`, `h` plus `ppmm` (pixels per mm, so features keep a physical size). Dimensions are clamped to [1, 12000]. Output: 8-bit PNG, zlib, no row filter.

**`random(seed) -> bytes`.** 4096 random bytes. Typst reads them with `rnd(table, ..ints)`: hash the integers to an index, map the byte to [-1, 1]. Per-glyph randomness costs a hash and a lookup, no plugin call.

### Determinism

Everything derives from `seed`:

- textures seed the generator with `seed × 1000 + page` plus a per-layer offset;
- geometry reads the random table at an index built from the seed and stable data: page number, block position, a hash of the word.

No clock or counter is used, so the PDF is identical on every machine. Tileable kinds (`grain`, `toner`, `ink`) wrap the noise lattice on the tile period, so tiles repeat without seams.

### Pipeline of `scan`

1. **Validate** (`parse-args`): split `preset`, `intensity`, `seed`; check themes, keys, types and ranges against `base`.
2. **Resolve**: merge `base`, the preset and the overrides key by key (`none` → neutral); scale by `intensity`; draw the random table.
3. **Page layers** (`page.typ`): `page.background` (paper, grain, stains) and `page.foreground` (stains with `over: true`, damage, scanner, dust, lighting, punch holes), per page, after looking up `page` overrides.
4. **Block rotation** (`jitter.typ`): show rule on paragraphs, headings, lists, figures, block equations and code blocks.
5. **Paint** (`jitter.typ`, `ink.typ`): show rules on `text`, `math.equation`, and `line`, `rect`, `table`.

### Page rotation without reflow

Each block is rotated by the page angle θ about its top-left corner, then moved to where a rotation of the whole page about its centre would put it. For a block at (x, y) from the page centre:

```text
dx = x (cos θ − 1) − y sin θ
dy = x sin θ + y (cos θ − 1)
```

`rotate(reflow: false)` and `move` do not change the space content occupies, so breaks are unaffected. The angle is `page-rotation × ((1 − drift) r₁ + drift w)`: `r₁` is an independent draw, `w` is interpolated between draws every four pages.

### Ink

- The **fill** becomes a tiling of mottled ink with pinholes (`ink`, `mode: "fill"`).
- The **stroke** becomes a tiling of patchy coverage (`mode: "edge"`), as wide as `bleed` asks. Centred on the outline, it grows each glyph unevenly.
- **Fading** mixes the ink with the paper colour instead of adding transparency, since fill and stroke overlap.
- Fading has three levels and tiles are 8 mm, so the PDF holds few distinct tilings.
- Math glyphs are not `text`, so each equation gets the paint as a whole; its inner text runs see a tiling fill and are skipped.
- `line`, `rect` and `table` are rebuilt with an inked `stroke` (an explicit `stroke` beats `set`), labelled to stop re-entry.
- Strings from code (`#lorem(..)`) arrive as one run and are split into words, so per-word boxes never block line breaks.

### `page` overrides

`page` wraps its body in two labelled metadata elements. On each page, the layers query them and, if the page lies between a start and an end, resolve the stored arguments with the document configuration as parent. Text show rules do not consult them, which is why `page` affects page effects only.

## Limitations

### No blur, no perspective

Typst has neither. Bleed and blur are textured strokes and halos; `phone-scan` rotates the page and darkens one side, but the page is never trapezoidal.

### Layout and granularity

- `"page"` and `"line"`: layout identical to the clean document.
- `"word"`: words are boxed and cannot be hyphenated; justified paragraphs may break differently.
- `"char"`: characters move vertically only; kerning may shift slightly.
- `"line"` moves whole blocks: Typst has no per-line hook.

### Mathematics

Equations are inked as a whole. Fraction bars and radical lines do not bleed. Inline equations follow their paragraph.

### Pages without a fixed height

With `#set page(height: auto)`, only the paper colour and the tiled grain are drawn.

### Page background and foreground

`scan` replaces earlier `background`/`foreground`; a later `set page` replaces those of `scan`. See [Raw textures](guide/textures.md#raw-textures).

### `page` and `region`

`page` cannot change ink or text jitter, and cannot be nested. `region` inside `scan` applies text effects twice.

### Show rules on strokes

`scan` rebuilds `line`, `rect` and `table` to ink them, so your own show rules on these elements run twice: `show table: it => block(stroke: red, it)` draws two frames. Put such rules before `scan`, or use `set` rules.

### Long highlights

`highlighter` boxes every word. Beyond about 500 words in one call, Typst fails with `maximum grouping depth exceeded`: split the passage.

### Damage hides text

`dog-ear` and `torn` cover the text under them. Keep wide margins.

### PDF viewers

Textured ink uses tiling patterns as text paint:

| Viewer | Result |
|---|---|
| macOS Preview, Ghostscript, MuPDF | Correct |
| Poppler (Evince, Okular, `pdftoppm`) | Outline drawn as plain ink: bold, smudged text |

!!! danger "PNG export in Typst 0.15.1"

    Typst 0.15.1 panics when exporting to PNG text filled with an image tiling (a Typst bug). Export a PDF and convert it:

    ```sh
    typst compile doc.typ doc.pdf
    gs -dNOPAUSE -dBATCH -sDEVICE=png16m -r300 -dDownScaleFactor=2 -dMaxBitmap=2000000000 \
      -sOutputFile=doc-%d.png doc.pdf
    ```

    `-dDownScaleFactor=2` avoids over-thick strokes at low resolution; `-dMaxBitmap` avoids blank bands.

### Details on screen

Pinholes and the low-`legibility` halo are thinner than a screen pixel at normal zoom. They show in print or when zooming.

### Repeated words

Randomness comes from stable data, so the same word gets the same inking wherever it appears.

### `ghosting` and extraction

Ghost copies are tagged as PDF artifacts, but most extractors still return them. Off by default.

### Compile time

A few seconds per page is normal. See [Performance](guide/textures.md).

### Accessibility and responsible use

Text stays real: selectable, searchable, readable by screen readers (except with `ghosting`). The visual result is harder to read on purpose. When the content matters, also distribute a clean version: compile the same source with `intensity: 0`.

lookscanned is meant for design, illustration, fiction, games, props and testing OCR or document pipelines. Do not use it to forge documents or pass a generated document off as a genuine scan.
