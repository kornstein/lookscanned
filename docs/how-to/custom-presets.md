# Create a custom preset

A preset is a plain dictionary of themes. You can pass one directly as `preset`:

```typst
#let my-scan = (
  paper: (color: rgb("#eef4ff"), grain: 0.3),
  ink: (bleed: 0.5, fade: 0.2),
  skew: (page-rotation: 0.8deg),
  edges: (shadow: 0.4),
)

#show: lookscanned.scan.with(preset: my-scan, seed: 12)
```

Keys you do not list take their neutral value (no effect), not the value of another preset.

## Start from an existing preset

All built-in presets are available in `lookscanned.presets`. The simplest way to derive one is to keep its name and add theme overrides:

```typst
#show: lookscanned.scan.with(preset: "fax", ink: (bleed: 0.2))
```

To store the result as a reusable dictionary, merge theme by theme:

```typst
#let p = lookscanned.presets
#let soft-fax = p.fax + (ink: p.fax.ink + (bleed: 0.2))
```

!!! warning "Dictionary `+` replaces whole themes"

    `p.fax + (ink: (bleed: 0.2))` replaces the entire `ink` theme of `fax` with `(bleed: 0.2)`, dropping its `fade`, `wear` and `legibility`. Merge the theme itself, as above.

## Share it across documents

Put your presets in a file and import it:

```typst title="my-presets.typ"
#import "@preview/lookscanned:0.1.0"

#let soft-fax = lookscanned.presets.fax + (ink: lookscanned.presets.fax.ink + (bleed: 0.2))
```

```typst title="report.typ"
#import "@preview/lookscanned:0.1.0"
#import "my-presets.typ": soft-fax

#show: lookscanned.scan.with(preset: soft-fax)
```

A preset dictionary is checked like any other argument: an unknown theme or key, or a value of the wrong type, stops compilation with an error naming it.
