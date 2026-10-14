# Age the paper

Three themes describe the sheet and the scanner around the text: `paper`, `stains` and `edges`, plus `scanner` for transfer artefacts.

## Change the paper colour and texture

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  paper: (color: rgb("#f4efe4"), grain: 0.5, fibers: 0.4),
)
```

- `color` is the base colour of the sheet.
- `grain` adds fine noise and a low-frequency mottling.
- `fibers` draws short paper fibres.

## Yellow the paper

`aging` yellows the sheet, more towards the edges, and adds small rust-coloured spots (foxing).

![Paper with aging 0, 0.3, 0.6 and 1](../assets/img/paper-aging.png)

```typst
#show: lookscanned.scan.with(preset: "office-scan", paper: (aging: 0.6))
```

## Add stains, dust and scratches

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  stains: (
    color: rgb("#8b5a2b"),       // coffee
    amount: 0.4,                 // density of stains
    size: (min: 5mm, max: 25mm), // diameter range
    dust: 0.6,                   // specks and hairs
    scratches: 0.3,              // long faint lines on the glass
  ),
)
```

Stains are blotches, coffee rings and splatters. Their colour is entirely yours: use grey for a photocopy, brown for coffee, blue for spilled ink.

To place one stain precisely, use [`stain`](stamps-and-notes.md#add-a-stain) instead.

## Add scanner lighting

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  edges: (shadow: 0.6, vignette: 0.4, uneven: 0.3, binding: true, punch-holes: true),
)
```

- `shadow`: dark borders where the sheet did not lie flat on the glass. One side is usually stronger.
- `vignette`: darker corners.
- `uneven`: light coming from one side, as in a phone photo.
- `binding`: a dark gutter along the left edge, as when scanning a bound book.
- `punch-holes`: two filing holes on the left edge, 80 mm apart.

## Add fax lines or photocopier bands

```typst
#show: lookscanned.scan.with(preset: "office-scan", scanner: (lines: 0.5, bands: 0.4))
```

`lines` draws thin horizontal lines and white dropouts across the page. `bands` draws soft vertical bands and a few drum streaks.

!!! note "Page height"

    Page-sized textures (paper, stains, dust, lighting, lines) need a fixed page height. With `#set page(height: auto)`, only the paper grain is applied.
