# API

```typst
#import "@preview/lookscanned:0.2.0"
```

| Name | Purpose |
|---|---|
| [`scan`](#scan) | Show rule: the effect on the whole document |
| [`page`](#page) | Override page effects on some pages |
| [`region`](#region) | Text effects on one block |
| [`derive`](#derive) | A preset with some settings changed |
| [`presets`](#presets) | Built-in presets (dictionary) |
| [`stamp`](#stamp), [`scribble`](#scribble), [`stain`](#stain), [`highlighter`](#highlighter) | Decorations |
| [`texture`](#texture) | A raw texture image |

Names starting with `_` are internal.

## Common arguments

`scan`, `page` and `region` take the same named arguments.

| Argument | Type | Default | Description |
|---|---|---|---|
| `preset` | `str` or `dictionary` | `"office-scan"` | A [preset name](presets.md), or a dictionary of themes merged on the neutral values. |
| `intensity` | number ≥ 0 | `1` | Scales the effects. See [Intensity](themes.md#intensity). |
| `seed` | `int` | `0` | Random variant. Same seed, same output. |
| `paper`, `stains`, `ink`, `skew`, `edges`, `scanner`, `quality` | `dictionary` or `none` | from the preset | [Theme](themes.md) overrides. `none` resets a theme or a key to neutral. |

With `page`, unset arguments come from `scan`. Positional arguments other than the body, unknown themes or keys, and wrong types or ranges stop compilation with an error.

## `scan`

```typst
#show: lookscanned.scan.with(..arguments)
```

Applies to everything after it:

- sets the page `background` and `foreground`, replacing earlier ones;
- rotates paragraphs, headings, lists, enumerations, term lists, figures, block equations and code blocks so each page looks rotated;
- inks every text run, equation, and the strokes of `line`, `rect` and `table`; jitters words or characters.

Place it after `set page`, and before a template rule that must come last.

## `page`

```typst
#lookscanned.page(..arguments)[body]
```

Overrides page effects (paper, stains, lighting, damage, scanner, page rotation) on every page `body` spans. Ink and text jitter keep the `scan` settings. No page break, no nesting. Requires `scan`.

## `region`

```typst
#lookscanned.region(..arguments)[body]
```

A full-width block filled with the paper colour and grain, slightly rotated, whose text, equations and strokes are inked and jittered. Use without `scan`.

## `derive`

```typst
#lookscanned.derive(preset, ..themes)
```

| Argument | Type | Description |
|---|---|---|
| `preset` | `str` or `dictionary` | Base preset. |
| `..themes` | `dictionary` or `none` | Overrides, as in `scan`. Omitted keys keep the preset's value; `none` resets to neutral. |

Returns a preset dictionary.

```typst
#let soft-fax = lookscanned.derive("fax", ink: (bleed: 0.2))
#show: lookscanned.scan.with(preset: soft-fax)
```

## `presets`

Dictionary of the built-in presets. Each lists only the keys that differ from neutral.

```typst
#lookscanned.presets.keys()
// ("clean-scan", "office-scan", "photocopy", "fax", "typewriter", "old-paper",
//  "phone-scan", "mimeograph", "microfilm", "newsprint")
```

## `stamp`

```typst
#lookscanned.stamp(body, color: rgb("#c0392b"), angle: -12deg, size: 16pt, seed: 0, at: none)
```

| Argument | Type | Default | Description |
|---|---|---|---|
| `body` | `content` or `str` | required | Text, set in bold capitals. |
| `color` | `color` | `rgb("#c0392b")` | Ink colour. |
| `angle` | `angle` | `-12deg` | Rotation. |
| `size` | `length` | `16pt` | Text size. |
| `seed` | `int` | `0` | Ink pattern. |
| `at` | `(x, y)` or `none` | `none` | Top-left corner, relative to the container. `none`: inline. |

## `scribble`

```typst
#lookscanned.scribble(body: none, color: blue, width: 4cm, seed: 0, angle: -3deg, at: none)
```

| Argument | Type | Default | Description |
|---|---|---|---|
| `body` | `str` or `none` | `none` | Text in a wobbly italic. `none`: a scrawl. |
| `color` | `color` | `blue` | Ink colour. |
| `width` | `length` | `4cm` | Scrawl width (ignored with `body`). |
| `seed` | `int` | `0` | Shape variant. |
| `angle` | `angle` | `-3deg` | Rotation. |
| `at` | `(x, y)` or `none` | `none` | Top-left corner. |

## `stain`

```typst
#lookscanned.stain(at: none, color: rgb("#6b4423"), size: 20mm, seed: 0, over: false)
```

| Argument | Type | Default | Description |
|---|---|---|---|
| `at` | `(x, y)` or `none` | `none` | **Centre** of the stain. `none`: inline. |
| `color` | `color` | `rgb("#6b4423")` | Colour. |
| `size` | `length` | `20mm` | Diameter. |
| `seed` | `int` | `0` | Blotch, ring or splatter. |
| `over` | `bool` | `false` | Paint above the text. Only inside `scan`. |

## `highlighter`

```typst
#lookscanned.highlighter(body, color: rgb("#ffe94d"), opacity: 0.55, seed: 0)
```

| Argument | Type | Default | Description |
|---|---|---|---|
| `body` | `content` | required | Highlighted content. Stays text; may span lines; no hyphenation. |
| `color` | `color` | `rgb("#ffe94d")` | Marker colour. |
| `opacity` | number in [0, 1] | `0.55` | Ink density. |
| `seed` | `int` | `0` | Shape of the strokes. |

## `texture`

```typst
#lookscanned.texture(kind, seed: 0, width: auto, height: auto, resolution: 150, ..parameters)
```

| Argument | Type | Default | Description |
|---|---|---|---|
| `kind` | `str` | required | A [texture kind](textures.md). |
| `seed` | `int` | `0` | Variant. |
| `width`, `height` | `length` or `auto` | `auto` | Image size. `auto`: page size (needs a fixed page height). |
| `resolution` | number | `150` | DPI. Some kinds use a fraction of it. |
| `..parameters` | named | | Kind-specific. Lengths are converted to pixels. |

Returns an `image`.
