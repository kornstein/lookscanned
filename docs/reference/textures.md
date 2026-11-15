# Textures

Kinds accepted by [`texture`](api.md#texture). All take `seed`, `width`, `height` and `resolution`; the parameters below are per kind. Lengths are converted to pixels; colours are any Typst colour.

| Kind | Output | Resolution used | Tiles seamlessly |
|---|---|---|---|
| `paper` | opaque colour | 1/8 | no |
| `grain` | grey with transparency | full | yes |
| `toner` | colour with transparent holes | full | yes |
| `ink` | colour with transparency | full | yes |
| `stains` | colour with transparency | 1/3 | no |
| `dust` | grey with transparency | full | no |
| `lines` | grey with transparency, one pixel thick | full | no |
| `edges` | black with transparency | 1/10 | no |
| `damage` | colour, opaque where the paper is missing | 1/2 | no |
| `marker` | colour with transparency | full | no |

## `paper`

Base colour with low-frequency mottling, yellowing and foxing.

| Parameter | Default | Description |
|---|---|---|
| `color` | `white` | Base colour. |
| `grain` | `0` | Strength of the mottling. |
| `aging` | `0` | Yellowing and foxing. |

## `grain`

Fine light and dark speckles with small clumps, and optional fibres.

| Parameter | Default | Description |
|---|---|---|
| `amount` | `0.5` | Opacity of the grain. |
| `fibers` | `0` | Density of fibres. |

## `toner`

Holes in a solid colour, with horizontal streaks. Laid over ink, it makes it look patchy (the stamps use it).

| Parameter | Default | Description |
|---|---|---|
| `amount` | `0.3` | Share of holes, up to `1.5`. |
| `color` | `white` | Colour of the holes: usually the paper colour. |

## `ink`

The paint used for letters by the `ink` theme.

| Parameter | Default | Description |
|---|---|---|
| `mode` | `"fill"` | `"fill"`: mottled ink with pinholes, for the inside of glyphs. `"edge"`: patchy coverage, used as stroke paint so glyphs grow unevenly. |
| `color` | `black` | Ink colour. |
| `amount` | `0.3` | Pinholes, up to `1.5`. |
| `soft` | `0` | `"edge"` only, `0` to `1`: blurrier transition, a halo. |
| `alpha` | `1` | Overall opacity. |

## `stains`

Blotches, coffee rings and splatters.

| Parameter | Default | Description |
|---|---|---|
| `color` | `rgb("#8c592b")` | Stain colour. |
| `amount` | `0.3` | Density; also raises the opacity up to `1`. |
| `min`, `max` | `2mm`, `15mm` | Range of diameters. |
| `count` | `0` | When positive, draws exactly that many stains at the centre, ignoring `amount`. |

## `dust`

| Parameter | Default | Description |
|---|---|---|
| `amount` | `0.5` | Specks and hairs. |
| `scratches` | `0` | Long faint lines. |

## `lines`

A one-pixel strip, stretched over the image without smoothing.

| Parameter | Default | Description |
|---|---|---|
| `axis` | `"h"` | `"h"`: horizontal fax lines. `"v"`: vertical photocopier bands. |
| `amount` | `0.5` | Density and strength. |

## `edges`

| Parameter | Default | Description |
|---|---|---|
| `shadow` | `0` | Border shadows. |
| `vignette` | `0` | Darker corners. |
| `uneven` | `0` | One-sided lighting. |
| `binding` | `false` | Gutter shadow on the left. |

## `damage`

Paper damage, drawn above the text.

| Parameter | Default | Description |
|---|---|---|
| `paper` | `white` | Paper colour, used for the back of the folded corner. |
| `folds` | `0` | Number of horizontal creases, evenly spaced. |
| `dog-ear` | `false` | Top-right corner folded over the page. |
| `staple` | `false` | Staple across the top-left corner. |
| `paperclip` | `false` | Rust marks left by a paperclip on the top edge. |
| `torn` | `false` | Bottom edge torn off. |

## `marker`

A single highlighter stroke across the image, with chisel ends, used by `highlighter`. The band fills 80% of the height, leaving room for its wobble.

| Parameter | Default | Description |
|---|---|---|
| `color` | `rgb("#ffe94d")` | Marker colour. |
| `opacity` | `0.55` | Ink density. |
