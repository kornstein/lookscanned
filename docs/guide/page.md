# Paper and page effects

Four themes act on the sheet rather than on the text: `paper`, `stains`, `edges` and `scanner`. They are drawn in the page background and foreground layers. Every key is listed in the [Themes reference](../reference/themes.md).

!!! note "Fixed page height"

    Page-sized images need a fixed page height. With `#set page(height: auto)`, only the paper colour and the tiled grain are drawn.

## Paper

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  paper: (color: rgb("#f4efe4"), grain: 0.5, aging: 0.4, fibers: 0.4),
)
```

| Key | Effect |
|---|---|
| `color` | Sheet colour. Faded ink also tends towards it. |
| `grain` | Fine noise and low-frequency mottling. |
| `aging` | Yellowing, stronger near the edges, and foxing spots. |
| `fibers` | Short paper fibres. |

![aging 0, 0.3, 0.6, 1](../assets/img/paper-aging.png)

## Stains, dust and scratches

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  stains: (color: rgb("#8b5a2b"), amount: 0.4, size: (min: 5mm, max: 25mm), dust: 0.6, scratches: 0.3),
)
```

| Key | Effect |
|---|---|
| `amount` | Stains per page (blotches, rings, splatters), scaled to the page area. |
| `color` | Brown for coffee, grey for toner, blue for ink. |
| `size` | Range of diameters. |
| `dust` | Specks and hairs on the glass, above the text. |
| `scratches` | Long faint lines, mostly vertical. |

For one stain at a given spot, use [`stain`](decorations.md#stain). For stains on some pages only, use [`page`](pages-and-regions.md#page).

## Lighting

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  edges: (shadow: 0.6, vignette: 0.4, uneven: 0.3, binding: true, punch-holes: true),
)
```

| Key | Effect |
|---|---|
| `shadow` | Dark borders, usually stronger on one side. |
| `vignette` | Darker corners. |
| `uneven` | Light falling off from one side, as in a phone photo. |
| `binding` | Gutter shadow along the left edge, as in a bound volume. |
| `punch-holes` | Two 6 mm filing holes on the left, 80 mm apart, centred 12 mm from the edge (ISO 838). |

## Damage

```typst
#show: lookscanned.scan.with(
  preset: "old-paper",
  edges: (folds: 1, dog-ear: true, staple: true, paperclip: true, torn: true),
)
```

![Fold, dog-ear, staple, paperclip and torn edge](../assets/img/damage.png)

| Key | Effect |
|---|---|
| `folds` | Number of horizontal creases, evenly spaced. `2` for a letter folded in three. |
| `dog-ear` | Top-right corner folded over the page. |
| `staple` | Staple across the top-left corner. |
| `paperclip` | Rust marks of a paperclip on the top edge. |
| `torn` | Bottom edge torn off, showing the scanner lid. |

`dog-ear` and `torn` hide the text beneath them: keep wide enough margins.

## Scanner

```typst
#show: lookscanned.scan.with(preset: "office-scan", scanner: (lines: 0.5, bands: 0.4))
```

| Key | Effect |
|---|---|
| `lines` | Fax: thin horizontal lines and white dropouts. |
| `bands` | Photocopier: soft vertical bands and drum streaks. |
