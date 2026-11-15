# Paper and page effects

Four themes act on the sheet rather than the text: `paper`, `stains`, `edges` and `scanner`. They are drawn as page background and foreground images. Every key is listed in the [Themes reference](../reference/themes.md).

!!! note "Fixed page height"

    Page-sized images need the page height. With `#set page(height: auto)`, only the paper colour and the tiled grain are drawn.

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
| `grain` | Fine noise and mottling. |
| `aging` | Yellowing towards the edges, and foxing spots. |
| `fibers` | Short paper fibres. |

![aging 0, 0.3, 0.6, 1](../assets/img/paper-aging.png)

## Stains, dust, scratches

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  stains: (color: rgb("#8b5a2b"), amount: 0.4, size: (min: 5mm, max: 25mm), dust: 0.6, scratches: 0.3),
)
```

| Key | Effect |
|---|---|
| `amount` | Stains per page (blotches, rings, splatters), scaled to page area. |
| `color` | Brown for coffee, grey for toner, blue for ink. |
| `size` | Range of diameters. |
| `dust` | Specks and hairs on the glass, above the text. |
| `scratches` | Long faint lines, mostly vertical. |

For one stain at a given spot, use [`stain`](decorations.md#stain).

## Lighting

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  edges: (shadow: 0.6, vignette: 0.4, uneven: 0.3, binding: true, punch-holes: true),
)
```

| Key | Effect |
|---|---|
| `shadow` | Dark borders, one side dominant. |
| `vignette` | Darker corners. |
| `uneven` | Light falling off from one side, as in a phone photo. |
| `binding` | Gutter shadow on the left, as in a bound volume. |
| `punch-holes` | Two filing holes on the left (ISO 838). |

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
| `folds` | Number of horizontal creases. `2` for a letter folded in three. |
| `dog-ear` | Top-right corner folded over. |
| `staple` | Staple in the top-left corner. |
| `paperclip` | Rust marks of a paperclip on the top edge. |
| `torn` | Bottom edge torn off. |

The dog-ear and the torn edge hide the text beneath them: keep wide enough margins.

## Scanner

```typst
#show: lookscanned.scan.with(preset: "office-scan", scanner: (lines: 0.5, bands: 0.4))
```

| Key | Effect |
|---|---|
| `lines` | Fax: thin horizontal lines and white dropouts. |
| `bands` | Photocopier: soft vertical bands and drum streaks. |
