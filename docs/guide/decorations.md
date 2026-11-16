# Decorations

Functions that return content. They work with or without `scan`; inside `scan`, their text is inked too.

![Stamps, a note, a scrawl and a stain](../assets/img/decorations.png)

**Placement.** Without `at`, a decoration is inline. With `at: (x: .., y: ..)`, it is placed like `place(top + left, dx: x, dy: y)`, relative to the current container (the text area, a block, a grid cell) and without affecting the layout. `stain` is the exception: its `at` is the **centre** of the stain.

## `stamp`

Bold capitals in a double frame, with patchy ink. `at` is the top-left corner.

```typst
#lookscanned.stamp("Lorem ipsum", color: rgb("#5b3a8c"))
#lookscanned.stamp("Dolor sit amet", angle: 9deg, at: (x: 70%, y: 80%))
```

## `scribble`

With `body`: a wobbly italic note. Without: a scrawl of the given `width` (signature, initials, crossing-out).

```typst
#lookscanned.scribble(body: "lorem ipsum", color: blue)
#lookscanned.scribble(width: 3.2cm, seed: 4)
```

A handwriting font helps: `#text(font: "Caveat", lookscanned.scribble(body: "lorem ipsum"))`.

## `stain`

One blotch, ring or splatter (chosen by `seed`) of diameter `size`.

```typst
#lookscanned.stain(at: (x: 60%, y: 20%), color: rgb("#6b4423"), size: 25mm)
#lookscanned.stain(at: (x: 30%, y: 50%), over: true)
```

By default the stain is under the text. `over: true` paints it above, as if spilled on the printed page; inside `scan` only, elsewhere it stays under.

To scatter stains on every page, use the [`stains` theme](page.md#stains-dust-and-scratches) or [`page`](pages-and-regions.md#page) for a few pages.

## `highlighter`

A hand-drawn marker stroke under the text, one per line: uneven ends, slight wobble, heavier where the pen lands.

```typst
#lorem(8) #lookscanned.highlighter[#lorem(4)] #lorem(8)
#lorem(4) #lookscanned.highlighter(color: rgb("#7be07b"), seed: 5)[#lorem(6)] #lorem(6)
```

![Yellow and green highlights, and a stain over the text](../assets/img/highlighter.png)

- The body stays text and may span lines and pages; its words are not hyphenated.
- `opacity` sets the ink density, `seed` changes every stroke.
- No clash with Typst's `highlight`, even after `import ..: *`.
- Above about 500 words in one call, Typst fails with `maximum grouping depth exceeded`: split the passage.

## Signatures

```typst
#lookscanned.stamp(body, color: rgb("#c0392b"), angle: -12deg, size: 16pt, seed: 0, at: none)
#lookscanned.scribble(body: none, color: blue, width: 4cm, seed: 0, angle: -3deg, at: none)
#lookscanned.stain(at: none, color: rgb("#6b4423"), size: 20mm, seed: 0, over: false)
#lookscanned.highlighter(body, color: rgb("#ffe94d"), opacity: 0.55, seed: 0)
```

Every argument: [API](../reference/api.md#stamp).
