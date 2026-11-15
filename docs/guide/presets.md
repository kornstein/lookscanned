# Presets

A preset is a complete look: a dictionary of [themes](../reference/themes.md). `scan`, `page` and `region` take a preset name or dictionary. The default is `"office-scan"`.

```typst
#show: lookscanned.scan.with(preset: "photocopy")
```

## Gallery

Same excerpt, `seed: 3`. Exact values: [Presets reference](../reference/presets.md).

<div class="grid" markdown>

<figure markdown>
![clean-scan](../assets/img/preset-clean-scan.png)
<figcaption><code>clean-scan</code>: archived copy, barely noticeable</figcaption>
</figure>

<figure markdown>
![office-scan](../assets/img/preset-office-scan.png)
<figcaption><code>office-scan</code> (default): departmental scan</figcaption>
</figure>

<figure markdown>
![photocopy](../assets/img/preset-photocopy.png)
<figcaption><code>photocopy</code>: copied many times; bleed, drum bands, dust</figcaption>
</figure>

<figure markdown>
![fax](../assets/img/preset-fax.png)
<figcaption><code>fax</code>: transmission lines, per-word jitter</figcaption>
</figure>

<figure markdown>
![typewriter](../assets/img/preset-typewriter.png)
<figcaption><code>typewriter</code>: per-character jitter, worn ribbon</figcaption>
</figure>

<figure markdown>
![old-paper](../assets/img/preset-old-paper.png)
<figcaption><code>old-paper</code>: library book; yellowing, foxing, stains</figcaption>
</figure>

<figure markdown>
![phone-scan](../assets/img/preset-phone-scan.png)
<figcaption><code>phone-scan</code>: photographed page; strong rotation, uneven light</figcaption>
</figure>

<figure markdown>
![mimeograph](../assets/img/preset-mimeograph.png)
<figcaption><code>mimeograph</code>: stencil copy; heavy faded ink, punch holes, folds</figcaption>
</figure>

<figure markdown>
![microfilm](../assets/img/preset-microfilm.png)
<figcaption><code>microfilm</code>: grey film, scratches, dark vignette</figcaption>
</figure>

<figure markdown>
![newsprint](../assets/img/preset-newsprint.png)
<figcaption><code>newsprint</code>: cheap fibrous paper, one fold</figcaption>
</figure>

</div>

!!! tip "Typewriter"

    `typewriter` does not change the font. Pair it with a monospaced face, e.g. `#set text(font: "Courier Prime")`.

## Intensity and seed

```typst
#show: lookscanned.scan.with(preset: "fax", intensity: 0.5)       // half as strong
#show: lookscanned.scan.with(preset: "clean-scan", intensity: 2)  // twice as strong
#show: lookscanned.scan.with(preset: "fax", seed: 12)             // another variant
```

- `intensity` multiplies amounts, angles and lengths. Colours, sizes, switches and `quality` are not scaled. `0` turns every effect off, switches included. Exact rule: [Themes › Intensity](../reference/themes.md#intensity).
- `seed` (integer, default `0`) drives every random choice. Same seed, same PDF.

## Changing a preset

Pass theme dictionaries next to `preset`. Within a theme, omitted keys keep the preset's value:

```typst
#show: lookscanned.scan.with(preset: "fax", ink: (bleed: 0.2))
```

`none` resets to the neutral value (no effect), for a whole theme or a single key:

```typst
#show: lookscanned.scan.with(
  preset: "old-paper",
  stains: none,        // no stains, dust or scratches
  ink: (bleed: none),  // no bleed; the rest of the ink stays
)
```

## Your own presets

`derive` stores a modified preset for reuse. It takes the same overrides as `scan`, merged key by key:

```typst
#let soft-fax = lookscanned.derive("fax", ink: (bleed: 0.2))
#show: lookscanned.scan.with(preset: soft-fax)
```

!!! warning "Use `derive`, not `+`"

    `lookscanned.presets.fax + (ink: (bleed: 0.2))` replaces the whole `ink` theme and drops `fade`, `wear` and `legibility`.

A plain dictionary also works as a preset. It starts from the **neutral** values, not from another preset:

```typst
#let my-scan = (
  paper: (color: rgb("#eef4ff"), grain: 0.3),
  ink: (bleed: 0.5, fade: 0.2),
  skew: (page-rotation: 0.8deg),
  edges: (shadow: 0.4),
)
#show: lookscanned.scan.with(preset: my-scan, seed: 12)
```

To share presets across files, define them in a module and import it:

```typst title="presets.typ"
#import "@preview/lookscanned:0.2.0"
#let library-copy = lookscanned.derive("old-paper", edges: (binding: true, shadow: 0.4))
```

```typst title="book.typ"
#import "@preview/lookscanned:0.2.0"
#import "presets.typ": library-copy
#show: lookscanned.scan.with(preset: library-copy)
```

Preset dictionaries are validated like any argument: unknown themes or keys, wrong types and out-of-range values stop compilation with an explicit error.
