# Paper and scanner

Four themes describe what surrounds the text: `paper` (the sheet), `stains` (marks on the sheet and on the scanner glass), `edges` (lighting) and `scanner` (transfer artefacts). They are drawn as page background and foreground images.

## Paper

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  paper: (color: rgb("#f4efe4"), grain: 0.5, aging: 0.4, fibers: 0.4),
)
```

| Key | Effect |
|---|---|
| `color` | Base colour of the sheet. Also used as the target colour of ink fading. |
| `grain` | Fine noise and low-frequency mottling. |
| `aging` | Yellowing, stronger towards the edges, and foxing (small rust-coloured spots, quadratic in `aging`). |
| `fibers` | Short paper fibres. |

![aging 0, 0.3, 0.6, 1](../assets/img/paper-aging.png)

## Stains, dust and scratches

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  stains: (
    color: rgb("#8b5a2b"),
    amount: 0.4,
    size: (min: 5mm, max: 25mm),
    dust: 0.6,
    scratches: 0.3,
  ),
)
```

| Key | Effect |
|---|---|
| `amount` | Density of stains per page, scaled by page area relative to A4. Each stain is a blotch, a ring or a splatter. |
| `color` | Stain colour: brown for coffee, grey for toner, blue for ink. |
| `size` | Range of diameters. |
| `dust` | Specks and hairs on the glass, drawn above the text. |
| `scratches` | Long faint lines, mostly vertical. |

To place a single stain at a given position, use [`stain`](decorations.md#stain).

## Lighting

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  edges: (shadow: 0.6, vignette: 0.4, uneven: 0.3, binding: true, punch-holes: true),
)
```

| Key | Effect |
|---|---|
| `shadow` | Dark borders where the sheet does not lie flat. One side, chosen from the seed, dominates. |
| `vignette` | Darker corners. |
| `uneven` | Light falling off from one side, as in a phone photograph. |
| `binding` | Gutter shadow along the left edge of a bound volume. |
| `punch-holes` | Two filing holes on the left edge (ISO 838: 6 mm, 80 mm apart, centred 12 mm from the edge). |

## Scanner artefacts

```typst
#show: lookscanned.scan.with(preset: "office-scan", scanner: (lines: 0.5, bands: 0.4))
```

| Key | Effect |
|---|---|
| `lines` | Fax transmission: thin horizontal dark lines and white dropouts. |
| `bands` | Photocopier: soft vertical bands and a few drum streaks. |

## Pages without a fixed height

Page-sized textures need the page height. With `#set page(height: auto)`, only the paper colour and the tiled grain are drawn; mottling, ageing, stains, dust, lighting and scanner artefacts are skipped.
