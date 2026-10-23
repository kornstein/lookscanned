# API

```typst
#import "@preview/lookscanned:0.1.0"
```

The import binds the module `lookscanned`. Every function below is called through it, for example `lookscanned.scan`.

| Name | Kind | Purpose |
|---|---|---|
| [`scan`](#scan) | show rule | Apply the effect to the whole document |
| [`page`](#page) | function | Override page-level settings for some pages |
| [`region`](#region) | function | Apply text effects to one block |
| [`stamp`](#stamp) | function | Rubber stamp |
| [`scribble`](#scribble) | function | Approximate handwriting or scrawl |
| [`stain`](#stain) | function | One stain |
| [`texture`](#texture) | function | A raw texture image |
| [`presets`](#presets) | dictionary | Built-in presets |

Names starting with `_` are internal and may change without notice.

## Common arguments

`scan`, `page` and `region` take the same named arguments:

| Argument | Type | Default | Description |
|---|---|---|---|
| `preset` | `str` or `dictionary` | `"office-scan"` | Name of a [built-in preset](presets.md), or a dictionary of themes merged on neutral values. |
| `intensity` | `int` or `float` ≥ 0 | `1` | Multiplier applied to the preset and themes. See [intensity](themes.md#intensity). |
| `seed` | `int` | `0` | Selects the random variant. Same seed, same result. |
| `paper`, `stains`, `ink`, `skew`, `edges`, `scanner`, `quality` | `dictionary` | from the preset | Theme overrides. See [Themes](themes.md). |

For `page`, unset arguments are inherited from `scan` instead of these defaults.

Positional arguments other than the body, unknown themes, unknown keys and values of the wrong type stop compilation with an error that names the problem.

## `scan`

```typst
#show: lookscanned.scan.with(..arguments)
```

Applies the effects to everything that follows. It:

- sets the page `background` (paper, grain, stains) and `foreground` (scanner lines and bands, dust, lighting, punch holes), replacing any you set before;
- rotates and moves paragraphs, headings, lists, enumerations, term lists, figures, block equations and code blocks so that each page looks rotated;
- applies ink effects, and word or character jitter, to every text run;
- applies ink effects to every equation as a whole (see [Mathematics](../guide/mathematics.md#equations)).

Place it after your `set page` rules, and before a template rule that must come last.

## `page`

```typst
#lookscanned.page(..arguments)[body]
```

Overrides the page-level effects for every page that `body` spans: paper, stains, dust, lighting, scanner artefacts and page rotation. Ink and text jitter stay those of `scan`. It inserts no page break. It cannot be nested. Requires `scan`.

## `region`

```typst
#lookscanned.region(..arguments)[body]
```

Returns a full-width block filled with the paper colour and grain, slightly rotated, whose text and equations get the ink and jitter effects. It needs no `scan`. Avoid it inside a `scan` document: text effects would apply twice.

## `stamp`

```typst
#lookscanned.stamp(body, color: rgb("#c0392b"), angle: -12deg, size: 16pt, seed: 0, at: none)
```

| Argument | Type | Default | Description |
|---|---|---|---|
| `body` | `content` or `str` | required | Text of the stamp, set in bold capitals. |
| `color` | `color` | `rgb("#c0392b")` | Ink colour. |
| `angle` | `angle` | `-12deg` | Rotation. |
| `size` | `length` | `16pt` | Text size. |
| `seed` | `int` | `0` | Ink pattern. |
| `at` | `dictionary` or `none` | `none` | `(x: .., y: ..)` position of the top-left corner, relative to the container. `none` inserts it inline. |

## `scribble`

```typst
#lookscanned.scribble(body: none, color: blue, width: 4cm, seed: 0, angle: -3deg, at: none)
```

| Argument | Type | Default | Description |
|---|---|---|---|
| `body` | `str` or `none` | `none` | Text written in a wobbly italic. With `none`, a scrawl is drawn instead. |
| `color` | `color` | `blue` | Ink colour. |
| `width` | `length` | `4cm` | Width of the scrawl (ignored with a `body`). |
| `seed` | `int` | `0` | Shape variant. |
| `angle` | `angle` | `-3deg` | Rotation. |
| `at` | `dictionary` or `none` | `none` | `(x: .., y: ..)` position of the top-left corner. |

## `stain`

```typst
#lookscanned.stain(at: none, color: rgb("#6b4423"), size: 20mm, seed: 0)
```

| Argument | Type | Default | Description |
|---|---|---|---|
| `at` | `dictionary` or `none` | `none` | `(x: .., y: ..)` position of the **centre**. `none` inserts it inline. |
| `color` | `color` | `rgb("#6b4423")` | Stain colour. |
| `size` | `length` | `20mm` | Diameter. |
| `seed` | `int` | `0` | Shape variant: blotch, ring or splatter. |

## `texture`

```typst
#lookscanned.texture(kind, seed: 0, width: auto, height: auto, resolution: 150, ..parameters)
```

| Argument | Type | Default | Description |
|---|---|---|---|
| `kind` | `str` | required | One of the [texture kinds](textures.md). |
| `seed` | `int` | `0` | Variant. |
| `width`, `height` | `length` or `auto` | `auto` | Size of the image. `auto` uses the page size and requires a fixed page height. |
| `resolution` | number | `150` | DPI. Some kinds use a fraction of it. |
| `..parameters` | named | | Kind-specific parameters. Lengths are converted to pixels. |

Returns an `image`.

## `presets`

A dictionary mapping each preset name to its themes. Presets only list the keys that differ from the neutral values. See [Presets](presets.md).

```typst
#lookscanned.presets.keys()
// ("clean-scan", "office-scan", "photocopy", "fax", "typewriter", "old-paper", "phone-scan")
```
