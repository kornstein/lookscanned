# How it works

lookscanned never turns your document into an image. Typst lays the document out as usual, and lookscanned adds images around the text and changes how the text is painted. This page explains the pieces and why they are built this way.

## Two halves: a plugin and Typst code

The package has two parts.

**A WebAssembly plugin, written in Rust**, generates two things:

- **textures**: paper, grain, stains, dust, lighting, ink. Each is returned as a PNG image.
- **randomness**: a table of 4096 random values derived from the seed.

**Typst code** does everything else: it reads your settings, checks them, merges them with the preset, and applies the effects with ordinary Typst features. These are page backgrounds and foregrounds, show rules, `rotate`, `move`, text fills and strokes.

This split follows what each side does well. Generating millions of noisy pixels is cheap in compiled code and impossible to do efficiently in Typst. Placing and transforming content is what Typst is for, and keeping that part in Typst means the document stays a real Typst document.

## Determinism

Nothing in lookscanned uses unseeded randomness. Every texture takes a seed derived from your `seed` and, for per-page textures, the page number. Every jitter reads the random table at a position computed from the seed and from stable data: the page number, the position of a block, the text of a word.

The same document with the same seed therefore produces the same PDF on every machine, every time. A side effect is that the same word always gets the same inking variation.

## The page: images behind and in front

`scan` sets the page `background` and `foreground`.

- **Behind the text**: the paper (a low-resolution image, since its colour varies slowly), the grain (one small seamless tile repeated over the page), and the stains.
- **In front of the text**: fax lines or photocopier bands, dust and scratches, the lighting (shadows, vignette, binding), and punch holes.

Each texture is generated at the resolution its content needs. Smooth ones such as the paper colour or the lighting use a fraction of `quality.resolution`, and sharp ones such as dust use all of it. That keeps PDFs small.

## Rotation without moving the layout

Typst cannot rotate a whole page of flowing content without breaking pagination. Instead, lookscanned rotates each block separately: paragraphs, headings, lists, figures, block equations and code blocks. It also moves each block by the amount it would move if the whole page turned around its centre. Seen together, the blocks look like a rotated page.

`rotate(.., reflow: false)` and `move` change where content is drawn, not the space it takes. Line breaks, page breaks and spacing therefore stay exactly the same. The test suite checks this by comparing the extracted text of every preset with the plain document.

Typst gives no access to individual lines of a paragraph, so the `"line"` granularity jitters each block as a unit.

## Ink without rasterising the text

To make letters look printed, lookscanned changes their paint and keeps the text itself:

- the **fill** of each glyph becomes a tiling of mottled ink with pinholes;
- the **stroke** of each glyph becomes a tiling of patchy ink. A stroke is drawn on the outline, half outside, so a patchy stroke makes each letter grow by different amounts in different places, like ink soaking into paper fibres;
- **fading** mixes the ink colour with the paper colour rather than making it transparent. Fill and stroke overlap on the inside of the outline, and transparency there would draw a dark outline around a lighter letter.

Because the glyphs are still glyphs, the text remains selectable and searchable, with no duplicated copy, unless you turn on `ghosting`.

The ink tiles are 8 mm squares. To keep the number of different tiles low, fading is rounded to three levels.

## Why some things are approximations

Typst has no blur filter and no perspective transform. Blur is approximated with soft-edged textures, and the phone-photo look uses rotation and uneven light only. See [Limitations](limitations.md).
