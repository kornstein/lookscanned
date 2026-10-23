# Themes

Settings are grouped in seven themes. Each theme is a dictionary passed to `scan`, `page` or `region`; keys you omit keep the preset's value. The defaults below are the neutral values (no effect), which a preset then overrides.

Numbers must be non-negative. Amounts are designed for the range 0 to 1; larger values exaggerate the effect.

## `paper`

| Key | Type | Neutral | Description |
|---|---|---|---|
| `color` | `color` | `white` | Base colour of the sheet. |
| `grain` | number | `0` | Fine noise and low-frequency mottling. |
| `aging` | number | `0` | Yellowing, stronger near the edges, and foxing spots. |
| `fibers` | number | `0` | Short paper fibres. |

## `stains`

| Key | Type | Neutral | Description |
|---|---|---|---|
| `color` | `color` | `rgb("#8b5a2b")` | Colour of the stains. |
| `amount` | number | `0` | Density of stains (blotches, rings, splatters) per page. |
| `size` | `dictionary` | `(min: 2mm, max: 15mm)` | Range of stain diameters. Both are positive lengths. |
| `dust` | number | `0` | Dark specks and hairs. |
| `scratches` | number | `0` | Long faint lines, mostly vertical. |

## `ink`

| Key | Type | Neutral | Description |
|---|---|---|---|
| `bleed` | number | `0` | Ink spreading into the paper: glyphs grow unevenly. |
| `fade` | number | `0` | Uneven inking: some words (or characters) are lighter, towards the paper colour. |
| `legibility` | number in [0, 1] | `1` | `1` is sharp. Lower values soften edges, add dropouts and fade the ink. |
| `wear` | number | `0` | Dropouts inside the glyphs. |
| `ghosting` | `bool` | `false` | Faint offset copies of each word. Text extractors see the copies. |

## `skew`

| Key | Type | Neutral | Description |
|---|---|---|---|
| `page-rotation` | `angle` | `0deg` | Maximum rotation of a page. Each page draws its angle from the seed. |
| `line-jitter` | `angle` | `0deg` | Extra rotation of each block (granularity `"line"`) or each word (`"word"`). |
| `char-jitter` | `length` | `0pt` | Offset of each word (`"word"`) or vertical shift of each character (`"char"`). |
| `drift` | number in [0, 1] | `0` | `0`: pages are independent. `1`: the angle wanders slowly from page to page. |

## `edges`

| Key | Type | Neutral | Description |
|---|---|---|---|
| `shadow` | number | `0` | Dark borders, usually stronger on one side. |
| `vignette` | number | `0` | Darker corners. |
| `uneven` | number | `0` | Light coming from one side. |
| `binding` | `bool` | `false` | Gutter shadow along the left edge. |
| `punch-holes` | `bool` | `false` | Two 6 mm filing holes on the left, 80 mm apart, centred 12 mm from the edge (ISO 838). |

## `scanner`

| Key | Type | Neutral | Description |
|---|---|---|---|
| `lines` | number | `0` | Fax lines: thin horizontal lines and white dropouts. |
| `bands` | number | `0` | Photocopier bands: soft vertical bands and drum streaks. |

## `quality`

| Key | Type | Neutral | Description |
|---|---|---|---|
| `resolution` | number > 0 | `150` | DPI of generated textures. |
| `tile` | `bool` | `true` | Repeat one grain tile on every page instead of a full-page grain per page. |
| `granularity` | `str` | `"line"` | What jitters: `"page"`, `"line"`, `"word"` or `"char"`. |

See [Performance](../guide/performance.md) for the trade-offs.

## Intensity

`intensity` is applied after the preset and your themes are merged:

- every number, length and angle is multiplied by `intensity`;
- `legibility` becomes `1 - (1 - legibility) × intensity`, so it degrades proportionally and never goes below 0;
- these keys are never scaled: `color`, `size`, `drift`, `resolution`, `tile`, `granularity`, `binding`, `punch-holes`, `ghosting`.

With `intensity: 0` every amount, angle and offset is zero. Colours and on/off switches stay: the paper keeps its colour, and `binding` or `punch-holes` are still drawn if enabled.
