# lookscanned

Make a Typst document look scanned, photocopied, faxed or typed on a typewriter: paper grain, stains, dust, bleeding ink, slightly rotated pages. Textures and randomness come from a small WASM plugin. Typst applies the effects, so the text stays selectable and the layout stays the same.

```typst
#import "@preview/lookscanned:0.1.0"

#show: lookscanned.scan.with(preset: "office-scan")

= Rental agreement
The undersigned have agreed as follows…
```

Rendering is deterministic: the same `seed` always gives the same result.

## Presets

| Preset | Look |
|---|---|
| `"clean-scan"` | Very slight rotation, little grain, off-white paper |
| `"office-scan"` (default) | Moderate grain, edge shadows, slight drift |
| `"photocopy"` | High contrast, bands, dust, scratches, heavy bleed |
| `"fax"` | Transmission lines, irregular words, very degraded |
| `"typewriter"` | Per-character jitter, uneven inking, worn ribbon |
| `"old-paper"` | Yellowing, foxing, stains, vignette |
| `"phone-scan"` | Skew and uneven lighting (no true perspective) |

`lookscanned.presets` is a plain dictionary. You can read it, extend it, or pass your own dictionary as `preset`:

```typst
#let mine = lookscanned.presets.fax + (paper: (color: rgb("#eef4ff"), grain: 0.2))
#show: lookscanned.scan.with(preset: mine)
```

## Fine tuning

`intensity` multiplies every effect: 0 means none, 1 is the preset as is, and values above 1 exaggerate it. Each theme is a dictionary. Any key you leave out keeps the preset's value.

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  intensity: 0.7,
  seed: 7,
  paper: (color: rgb("#f4efe4"), grain: 0.4, aging: 0.2, fibers: 0),
  stains: (color: rgb("#8b5a2b"), amount: 0.3, size: (min: 2mm, max: 15mm), dust: 0.5, scratches: 0),
  ink: (bleed: 0.4, fade: 0.2, legibility: 0.8, wear: 0, ghosting: false),
  skew: (page-rotation: 0.6deg, line-jitter: 0.15deg, char-jitter: 0pt, drift: 0.3),
  edges: (shadow: 0.5, vignette: 0.3, uneven: 0, binding: false, punch-holes: false),
  scanner: (lines: 0, bands: 0),
  quality: (resolution: 150, tile: true, granularity: "line"),
)
```

| Key | Effect |
|---|---|
| `paper.grain`, `aging`, `fibers` | Grain and mottling, yellowing and foxing, paper fibres |
| `stains.amount`, `size`, `color` | Stains: blotches, coffee rings, splatters |
| `stains.dust`, `scratches` | Dust and hairs, long scratches on the scanner glass |
| `ink.bleed` | Ink spreading into the paper: each glyph grows unevenly, with blotchy edges |
| `ink.fade` | Uneven inking per word (per character with `"char"`): lighter, towards the paper colour |
| `ink.legibility` | 1 is sharp, 0 is barely readable (soft halo, more dropouts, fading) |
| `ink.wear` | Pinholes and dropouts inside the glyphs (worn ribbon, dry toner) |
| `ink.ghosting` | Faint offset copies of the text. Off by default: some text extractors read the copies too |
| `skew.page-rotation` | Maximum rotation per page, drawn from the seed |
| `skew.drift` | 0 means each page is independent; 1 means the angle wanders slowly from page to page |
| `skew.line-jitter` | Rotation per block (`"line"`) or per word (`"word"`) |
| `skew.char-jitter` | Offset per word, or baseline shift per character (`"char"`) |
| `edges.*` | Scanner edge shadow, vignette, uneven light, binding shadow, two punch holes |
| `scanner.lines`, `bands` | Fax lines, photocopier bands |
| `quality.resolution` | DPI of the generated textures (affects PDF size) |
| `quality.tile` | Reuse one grain tile on every page (smaller PDF) |
| `quality.granularity` | `"page"`, `"line"`, `"word"` or `"char"` jitter (char is the slowest) |

## Per page, per region

```typst
#lookscanned.page(stains: (amount: 0.8), skew: (page-rotation: 2deg))[
  This page is particularly damaged.
]

#lookscanned.region(preset: "fax")[
  This appendix looks like it came in by fax.
]
```

`page` changes the page-level effects (paper, stains, edges, scanner, page rotation) of the pages its body covers. Text effects stay the ones set by `scan`. `region` applies text effects to a block on a paper background, and it works without `scan`.

## Decorations

```typst
#lookscanned.stamp("Received", color: rgb("#c0392b"), angle: -12deg)
#lookscanned.scribble(body: "Seen, OK", color: blue)   // wobbly italic
#lookscanned.scribble(color: blue, width: 4cm)          // scrawl
#lookscanned.stain(at: (x: 60%, y: 20%), color: rgb("#6b4423"), size: 25mm)
```

`stamp` and `scribble` also accept `at: (x: .., y: ..)` to place them absolutely.

## Raw textures

```typst
#set page(background: lookscanned.texture("paper", seed: 3, color: rgb("#f0e6d2"), grain: 0.5))
#set page(foreground: lookscanned.texture("dust", seed: 3, amount: 0.4))
```

The available kinds are `"paper"`, `"grain"`, `"toner"`, `"ink"`, `"stains"`, `"dust"`, `"lines"` and `"edges"`. Without `width` and `height`, a texture takes the size of the page.

## How the ink works

The glyphs are never rasterised. Their paint is replaced instead: the fill becomes a tiling of mottled ink with pinholes, and the outline becomes a stroke painted with patchy ink, so `bleed` thickens each glyph unevenly. The text stays real, selectable and searchable, with no duplicated copies.

## Limitations

- Typst cannot do true perspective or real blur. Bleed and blur are approximated with strokes, transparency and textures.
- Typst has no per-line hook, so `"line"` granularity rotates each block (paragraph, heading, list…) as a unit.
- With `"word"` or `"char"` granularity, words are boxed. They can no longer be hyphenated, so justified text with hyphenation can break differently. `"line"` and `"page"` never change the layout.
- The same word always gets the same inking variation.
- `scan` replaces the page `background` and `foreground`.
- Textured ink depends on the PDF viewer. macOS Preview and Typst's own renderer show it fully. Poppler-based viewers draw the outline as plain ink, so the text only looks bolder and bled.
- `"char"` granularity moves characters vertically only, to keep words whole without boxing them. It can slightly change kerning.

## Accessibility and fair use

The text remains real, selectable and searchable text. A "scanned" document is still harder to read, especially for people using assistive technologies, so keep a clean version available.

This package is meant for design, staging, fiction, games and OCR testing. Do not use it to forge documents.
