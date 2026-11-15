# Decorations

Functions that return content. They work with or without `scan`; inside `scan`, their text is inked too.

![Stamps, a note, a scrawl and a stain](../assets/img/decorations.png)

**Placement.** Without `at`, a decoration is inline. With `at: (x: .., y: ..)`, it is placed like `place(top + left, dx: x, dy: y)`, relative to the current container (the text area, a block, a grid cell) and without affecting the layout.

## `stamp`

Bold capitals in a double frame, with patchy ink. `at` is the top-left corner.

```typst
#lookscanned.stamp("Library copy", color: rgb("#5b3a8c"))
#lookscanned.stamp("Marked", angle: 9deg, at: (x: 70%, y: 80%))
```

## `scribble`

With `body`: a wobbly italic note. Without: a scrawl of the given `width` (signature, initials, crossing-out).

```typst
#lookscanned.scribble(body: "see Thm 1.4", color: blue)
#lookscanned.scribble(width: 3.2cm, seed: 4)
```

A handwriting font helps: `#text(font: "Caveat", lookscanned.scribble(body: "QED?"))`.

## `stain`

One blotch, ring or splatter (from `seed`) of diameter `size`. Here `at` is the **centre**.

```typst
#lookscanned.stain(at: (x: 60%, y: 20%), color: rgb("#6b4423"), size: 25mm)
#lookscanned.stain(at: (x: 30%, y: 50%), over: true)
```

By default the stain is under the text. `over: true` paints it above, as if spilled on the printed page (inside `scan` only; elsewhere it stays under).

To scatter stains on every page, use the [`stains` theme](paper.md#stains-dust-scratches).

## `highlighter`

A hand-drawn marker stroke under the text, one per line: uneven ends, slight wobble, heavier where the pen lands.

```typst
Some #lookscanned.highlighter[highlighted words]
and #lookscanned.highlighter(color: rgb("#7be07b"), seed: 5)[a green one].
```

![Yellow and green highlights, and a stain over the text](../assets/img/highlighter.png)

- The body stays text and may span lines and pages; its words are not hyphenated.
- `opacity` sets the ink density, `seed` changes every stroke.
- No clash with Typst's `highlight`, even after `import ..: *`.
- Above about 500 words in one call, Typst fails with `maximum grouping depth exceeded`: split the passage.
