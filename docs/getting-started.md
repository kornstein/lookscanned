# Getting started

## Install

=== "Typst Universe"

    ```typst
    #import "@preview/lookscanned:0.2.0"
    ```

=== "Local build"

    ```sh
    git clone https://github.com/kornstein/lookscanned
    cd lookscanned
    just install-local
    ```

    ```typst
    #import "@local/lookscanned:0.2.0"
    ```

    Needs Rust and `just`; see [Development](development.md).

Every function is reached through the `lookscanned` module.

## 1. Start from a document

```typst title="document.typ"
#set page(width: 12cm, height: 7cm, margin: (x: 1cm, y: 0.9cm))
#set text(font: "New Computer Modern", size: 10pt)
#set par(justify: true)

= Lorem ipsum

#lorem(30)

$ integral_0^1 x^2 dif x = 1/3 $
```

![The clean document](assets/img/start-1.png)

## 2. Apply a preset

Add the `scan` show rule **after** your `set page` rules:

```typst
#import "@preview/lookscanned:0.2.0"

#set page(width: 12cm, height: 7cm, margin: (x: 1cm, y: 0.9cm))
#show: lookscanned.scan.with(preset: "office-scan")
```

![The same document with office-scan](assets/img/start-2.png)

`scan` is the whole-document effect. The default preset is `"office-scan"`, so `#show: lookscanned.scan` alone gives the same result.

## 3. Set strength and seed

| Argument | Type | Default | Effect |
|---|---|---|---|
| `intensity` | number ≥ 0 | `1` | `0` disables every effect, `1` is the preset as is, above `1` exaggerates. |
| `seed` | integer | `0` | Fixes every random choice. Each value gives another reproducible variant. |

```typst
#show: lookscanned.scan.with(preset: "office-scan", seed: 7, intensity: 1.6)
```

![intensity: 1.6, seed: 7](assets/img/start-3.png)

## 4. Change settings

Settings are grouped in seven themes:

| Theme | Controls |
|---|---|
| `paper` | Sheet colour, grain, yellowing, fibres. |
| `stains` | Stains, dust, scratches. |
| `ink` | How glyphs are painted: bleed, fade, wear, legibility, ghosting. |
| `skew` | Page rotation, jitter of blocks, words or characters. |
| `edges` | Shadows, lighting, binding, punch holes, damage. |
| `scanner` | Fax lines, copier bands. |
| `quality` | Texture resolution, tiling, granularity. |

Pass the themes you want to change next to `preset`. Keys you omit keep the preset's value; `none` turns a theme or a key off:

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  seed: 7,
  intensity: 1.6,
  paper: (color: rgb("#f3ead6"), aging: 0.4),
  ink: (bleed: 0.6),
)
```

A misspelt theme or key, a wrong type or an out-of-range value stops compilation with an error naming it.

## 5. Add a decoration

```typst
#lookscanned.stamp("Lorem ipsum", color: rgb("#5b3a8c"), at: (x: 62%, y: 76%), size: 10pt)
```

![Aged paper, more bleed, a stamp](assets/img/start-4.png)

## Rules to keep in mind

- Put `scan` **after** `set page` and **before** a template rule that must come last. See [Templates](guide/templates.md).
- `scan` sets the page `background` and `foreground`; a later `set page` replaces them.
- `intensity: 0` removes every effect except the paper colour; that version is also the accessible one to distribute.

## Next

- [Presets](guide/presets.md): the ten built-in looks.
- [Themes reference](reference/themes.md): every setting.
- [API](reference/api.md): every function.
