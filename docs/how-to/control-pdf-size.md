# Control PDF size and compile time

Textures are images embedded in the PDF and generated while Typst compiles. Three settings in the `quality` theme trade looks against size and speed.

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  quality: (resolution: 100, tile: true, granularity: "line"),
)
```

## Lower the resolution

`resolution` is the DPI of the generated textures (default `150`). Textures scale with its square: `100` produces images about half as large as `150`. Smooth textures (paper colour, stains, lighting) are already generated at a fraction of it.

The ink textures on the letters use four times this value, because their details are smaller than a letter's stroke.

## Share textures between pages

With `tile: true` (the default), one small grain tile is repeated over every page and stored once in the PDF. With `tile: false`, each page gets its own full-page grain. That is slightly more varied, and much heavier.

## Choose the jitter granularity

`granularity` decides what moves:

| Value | Moves | Cost |
|---|---|---|
| `"page"` | whole page rotation only | lowest |
| `"line"` | + each block (paragraph, heading, list…) | low |
| `"word"` | + each word | higher; words cannot be hyphenated |
| `"char"` | + each character, vertically | highest |

Only `"word"` and `"char"` add work per word or per character. `"page"` and `"line"` never change line breaks.

## Typical numbers

For one A5 page, expect a few seconds of compilation and a PDF between 100 and 300 KB with the built-in presets. Most of the time is spent generating textures: Typst runs plugins in an interpreter, so every pixel costs time. Identical textures are generated only once per compilation.
