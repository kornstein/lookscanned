# Text and ink

Two themes act on text and its position: `ink` changes how glyphs are painted, `skew` moves pages, blocks, words or characters. Neither changes the glyphs, so text stays selectable. With the `"page"` and `"line"` granularities, neither changes the layout either.

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  ink: (bleed: 0.6, fade: 0.3, wear: 0.2, legibility: 0.9),
)
```

The figures below start from `clean-scan`; the labels give the values. Zoom in for details.

## `bleed`

Ink spreading into the paper; glyphs grow unevenly. `0.3` looks like ordinary print, above `1` the text gets heavy and smudged.

![bleed 0, 0.4, 0.8, 1.2](../assets/img/ink-bleed.png)

## `fade`

Uneven inking: each word (each character with `granularity: "char"`) is lightened towards the paper colour by a random amount up to `fade`.

![fade 0, 0.4, 0.8](../assets/img/ink-fade.png)

## `wear`

Pinholes and dropouts inside the glyphs: worn ribbon, dry toner. Meaningful up to `1.5`.

![wear 0, 0.5, 1](../assets/img/ink-wear.png)

## `legibility`

One control from `1` (sharp) to `0` (barely readable): softens the outline into a halo, adds dropouts, fades. The quickest way to degrade a document.

![legibility 1, 0.7, 0.4](../assets/img/ink-legibility.png)

## `ghosting`

`true` adds three faint offset copies of each word, like a blurred fax:

```typst
#show: lookscanned.scan.with(preset: "fax", ink: (ghosting: true))
```

Off by default. The copies are tagged as PDF artifacts, but most extractors (copy-paste, search, `pdftotext`) still return them.

## Movement

`quality.granularity` decides what moves; the `skew` theme sets how far.

| `granularity` | What jitters | Layout |
|---|---|---|
| `"page"` | Blocks, for the page rotation only | unchanged |
| `"line"` | Blocks, for the page rotation and a rotation per block (`line-jitter`) | unchanged |
| `"word"` | Blocks for the page rotation, plus each word: offset (`char-jitter`) and rotation (`line-jitter`) | words cannot be hyphenated; justified paragraphs may break differently |
| `"char"` | Blocks for the page rotation, plus each character, vertically (`char-jitter`), without boxes | kerning may shift slightly |

| `skew` key | Effect |
|---|---|
| `page-rotation` | Maximum rotation of a page; each page draws its angle from the seed. |
| `line-jitter` | Extra rotation of each block (`"line"`) or each word (`"word"`). |
| `char-jitter` | Offset of each word (`"word"`) or vertical shift of each character (`"char"`). |
| `drift` | `0`: pages are independent. `1`: the angle wanders slowly from page to page. |

```typst
#show: lookscanned.scan.with(
  preset: "fax",
  skew: (page-rotation: 0.9deg, line-jitter: 0.3deg),
  quality: (granularity: "word"),
)
```

`"line"` moves whole blocks: Typst has no per-line hook. The other layout effects are in the table above.

## Equations

Every equation is inked as a whole, with the same `bleed`, `fade` and `wear` as the text. Block equations rotate with the page; inline equations move with their paragraph. Equations stay selectable and the layout is unchanged.

Fraction bars and radical lines are drawn as lines, not glyphs: they do not bleed.

```typst
= Lorem ipsum

#lorem(20)

$ integral_0^1 x^2 dif x = 1/3 $

#lorem(10)
```

## Lines, rectangles and tables

The strokes of `line`, `rect` and `table` (including `table.hline`, `table.vline` and cell strokes) get the same ink: faded, thickened by `bleed`, with dropouts.

![A table, a rule and a framed remark under photocopy](../assets/img/strokes.png)

`scan` rebuilds these elements to ink them, so your own `show line`, `show rect` and `show table` rules run twice. See [Limitations](../internals.md#show-rules-on-strokes).

## What is left untouched

- Text or strokes already painted with a gradient or a tiling.
