# Custom presets

A preset is a dictionary mapping theme names to dictionaries of settings. Any dictionary of that shape can be passed as `preset`:

```typst
#let my-scan = (
  paper: (color: rgb("#eef4ff"), grain: 0.3),
  ink: (bleed: 0.5, fade: 0.2),
  skew: (page-rotation: 0.8deg),
  edges: (shadow: 0.4),
)

#show: lookscanned.scan.with(preset: my-scan, seed: 12)
```

A dictionary preset is merged on the [neutral values](../reference/themes.md), not on another preset: keys you omit have no effect.

## Deriving from a built-in preset

Built-in presets are exposed as `lookscanned.presets`. For a one-off change, keep the name and override themes:

```typst
#show: lookscanned.scan.with(preset: "fax", ink: (bleed: 0.2))
```

To store the result, merge theme by theme:

```typst
#let p = lookscanned.presets
#let soft-fax = p.fax + (ink: p.fax.ink + (bleed: 0.2))
```

!!! warning "Dictionary `+` replaces whole themes"

    `p.fax + (ink: (bleed: 0.2))` replaces the entire `ink` theme of `fax` and drops its `fade`, `wear` and `legibility`. Merge the theme itself, as above.

## Sharing presets

```typst title="presets.typ"
#import "@preview/lookscanned:0.1.0"

#let library-copy = lookscanned.presets.at("old-paper") + (
  edges: (binding: true, shadow: 0.4, vignette: 0.5),
)
```

```typst title="book.typ"
#import "@preview/lookscanned:0.1.0"
#import "presets.typ": library-copy

#show: lookscanned.scan.with(preset: library-copy)
```

## Validation

Preset dictionaries are validated like any other argument. Compilation stops with an explicit error on:

- an unknown theme or key;
- a value whose type differs from the neutral value (numbers accept `int` and `float`);
- a negative number, `legibility > 1`, an unknown `granularity`, a non-positive `resolution`, or a `size` that is not `(min: <length>, max: <length>)`.
