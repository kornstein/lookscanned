# Ink

The `ink` theme changes how glyphs are painted, never the glyphs themselves: text stays selectable and the layout does not move.

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  ink: (bleed: 0.6, fade: 0.3, wear: 0.2, legibility: 0.9),
)
```

Figures below: `clean-scan`, one key changed. Zoom in for details.

## `bleed`

Ink spreading into the paper; glyphs grow unevenly. `0.3` looks like ordinary print, above `1` the text gets heavy and smudged.

![bleed 0, 0.4, 0.8, 1.2](../assets/img/ink-bleed.png)

## `fade`

Uneven inking: each word (each character with `granularity: "char"`) is lightened towards the paper colour by a random amount up to `fade`.

![fade 0, 0.4, 0.8](../assets/img/ink-fade.png)

## `wear`

Pinholes and dropouts inside glyphs: worn ribbon, dry toner. Meaningful up to `1.5`.

![wear 0, 0.5, 1](../assets/img/ink-wear.png)

## `legibility`

One control from `1` (sharp) to `0` (barely readable): softens the outline into a halo, adds dropouts, fades. The quickest way to degrade a document.

![legibility 1, 0.7, 0.4](../assets/img/ink-legibility.png)

## `ghosting`

`true` adds three faint offset copies of each word, like a blurred fax. Off by default: the copies are tagged as PDF artifacts but most extractors (copy-paste, search, `pdftotext`) still pick them up.

```typst
#show: lookscanned.scan.with(preset: "fax", ink: (ghosting: true))
```

## Lines, rectangles and tables

Strokes of `line`, `rect` and `table` (including `table.hline`, `table.vline` and cell strokes) get the same ink: faded, thickened by `bleed`, with dropouts.

![A table, a rule and a framed remark under photocopy](../assets/img/strokes.png)

`scan` rebuilds these elements to ink them, so your own `show line`/`show rect`/`show table` rules run twice. See [Limitations](../internals.md#show-rules-on-strokes).

## Scope

- Every text run and every equation is inked ([Mathematics](mathematics.md)).
- Text or strokes painted with a gradient or a tiling are left untouched.
- Some PDF viewers draw the textured outline as plain ink ([Limitations](../internals.md#pdf-viewers)).
