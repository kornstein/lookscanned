# Limitations

lookscanned works within the features of Typst and of PDF. This page lists the resulting constraints.

## No blur or perspective

Typst has no blur filter and no perspective transform. Bleed and blur are approximated with textured strokes and soft halos. `phone-scan` rotates the page and adds uneven lighting; the page is never trapezoidal.

## Layout and granularity

- With `"page"` and `"line"` granularity, the layout is identical to the clean document.
- With `"word"`, each word is boxed. Boxed words cannot be hyphenated, so a justified, hyphenated paragraph may break differently.
- With `"char"`, characters move vertically only, which keeps words whole; kerning may change slightly.
- `"line"` moves whole blocks, since Typst exposes no per-line hook.

## Mathematics

- Equations are inked as a whole; fraction bars and radical overlines are lines and do not bleed.
- Inline equations follow their paragraph; they are not jittered individually.

## Pages without a fixed height

Page-sized textures need the page height. With `#set page(height: auto)`, only the paper colour and the tiled grain are drawn.

## Page background and foreground

`scan` sets the page `background` and `foreground`, replacing earlier values; a later `set page` replaces those of `scan`. See [Raw textures](../guide/textures.md#combining-with-scan) to combine layers.

## `page` and `region`

- `page` overrides page-level effects only; ink and text jitter keep the `scan` configuration. Calls cannot be nested.
- `region` inside a `scan` document applies the text effects twice.

## PDF viewers

Textured ink relies on tiling patterns used as text paint, which viewers support unevenly:

| Viewer | Result |
|---|---|
| macOS Preview, Ghostscript | Rendered fully |
| Poppler-based (Evince, Okular, `pdftoppm`) | Outline drawn as plain ink: text looks bold and smudged |

!!! danger "PNG export in Typst 0.15.1"

    Typst 0.15.1 panics (`crates/typst-render/src/paint.rs`) when exporting to PNG text whose fill is an image tiling. This is a Typst bug, reproducible without lookscanned. Export a PDF and convert it with Ghostscript:

    ```sh
    typst compile doc.typ doc.pdf
    gs -dNOPAUSE -dBATCH -sDEVICE=png16m -r300 -dDownScaleFactor=2 -dMaxBitmap=2000000000 \
      -sOutputFile=doc-%d.png doc.pdf
    ```

    `-dDownScaleFactor=2` renders at twice the resolution and halves it: at low resolution Ghostscript widens the thin textured strokes. `-dMaxBitmap` disables banding, which otherwise leaves blank bands where tilings cross band boundaries.

## Fine details on screen

Pinholes and the low-`legibility` halo are narrower than a screen pixel at normal zoom. They show in print and when zooming in.

## Repeated words

Randomness is derived from stable data, so the same word receives the same inking variation wherever it appears.

## `ghosting` and text extraction

`ink.ghosting` adds offset copies of each word. They are tagged as PDF artifacts, but many tools still extract them. The option is off by default.

## Compile time

Plugins run in an interpreter. Texture generation dominates compile time; a few seconds per page is normal. See [Performance](../guide/performance.md).

## Accessibility and responsible use

The text of a lookscanned document remains real text: it can be selected, searched, copied and read by a screen reader (except with `ghosting`). The visual result is nevertheless harder to read on purpose, especially for readers with low vision or dyslexia. When the content matters, distribute a clean version alongside; compiling the same source with `intensity: 0` produces one.

The package is intended for design, illustration, fiction, games, stage and film props, and testing OCR or document-processing software. Do not use it to forge documents or to pass a generated document off as a genuine scan.
