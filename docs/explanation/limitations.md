# Limitations

lookscanned works within what Typst can do. This page lists what it cannot do, and the trade-offs it makes.

## No true blur or perspective

Typst has no blur filter and no perspective transform. Bleeding and blur are approximated with textured strokes and soft halos. The `phone-scan` preset only rotates the page and adds uneven light: the page is never trapezoidal.

## Layout and granularity

- With `"page"` and `"line"` granularity, the layout never changes.
- With `"word"`, each word is placed in a box so it can move. Boxed words cannot be hyphenated, so a justified, hyphenated text may break lines differently.
- With `"char"`, characters only move vertically, which keeps words whole. Kerning between characters can change slightly.
- Typst has no per-line hook: `"line"` moves whole blocks (paragraphs, headings, lists…).

## Pages without a fixed height

Page-sized textures need to know the page height. With `#set page(height: auto)`, only the paper grain is drawn; paper colour variations, stains, dust, lighting and scanner lines are skipped.

## Page backgrounds

`scan` sets the page `background` and `foreground`, replacing yours. To combine them, use [raw textures](../how-to/raw-textures.md) and build your own background.

## `page` and `region`

- `lookscanned.page` changes page-level effects only; ink and text jitter stay those of `scan`. It cannot be nested.
- `lookscanned.region` inside a `scan` document applies the text effects twice.

## PDF viewers and exports

The textured ink is made of tiling patterns on text, a PDF feature that viewers render with varying fidelity:

- **macOS Preview** and **Ghostscript** render it fully.
- **Poppler**-based viewers (Evince, Okular, `pdftoppm`) draw the textured outline as plain ink: the text looks bold and smudged, without blotchy edges.

!!! danger "Typst's PNG export"

    Typst 0.15.1 crashes (`panicked at crates/typst-render/src/paint.rs`) when it exports to PNG text whose fill is an image tiling, which the textured ink uses. This is a Typst bug, reproducible without lookscanned. To get images, export a PDF and convert it, for example with Ghostscript:

    ```sh
    typst compile doc.typ doc.pdf
    gs -dNOPAUSE -dBATCH -sDEVICE=png16m -r300 -dDownScaleFactor=2 -sOutputFile=doc-%d.png doc.pdf
    ```

    Rendering at twice the resolution and halving it (`-dDownScaleFactor=2`) matters: at low resolution, Ghostscript widens the thin textured strokes and the text looks too bold.

## Ink details on screen

Pinholes and the low-`legibility` halo are finer than a screen pixel at normal zoom. They show on paper and when you zoom in.

## Repeated words

Randomness is derived from stable data so that output is deterministic. As a consequence, the same word gets the same inking variation wherever it appears.

## Text extraction with `ghosting`

`ink.ghosting` adds offset copies of each word. They are marked as PDF artifacts, but many tools still read them, so search and copy return each word several times. That is why `ghosting` is off by default.

## Compile time

Typst runs plugins in an interpreter. Generating textures takes most of the compile time: a few seconds per page is normal. See [Control PDF size and compile time](../how-to/control-pdf-size.md).
