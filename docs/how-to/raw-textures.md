# Use the textures directly

`lookscanned.texture` gives you the textures without the rest of the package. It is useful to build your own effects, a page background, or an illustration.

```typst
#set page(background: lookscanned.texture("paper", seed: 3, color: rgb("#f0e6d2"), grain: 0.5))
#set page(foreground: lookscanned.texture("dust", seed: 3, amount: 0.4))
```

Without `width` and `height`, a texture takes the size of the page, which suits `page(background: ..)` and `page(foreground: ..)`. Elsewhere, give a size:

```typst
#lookscanned.texture("stains", width: 4cm, height: 4cm, count: 1, min: 25mm, max: 30mm)
```

![The eight texture kinds](../assets/img/textures.png)

## Repeat a texture as a fill

Small textures can be repeated with a Typst `tiling`. Grain and toner are seamless:

```typst
#let grain = tiling(size: (4cm, 4cm), lookscanned.texture("grain", width: 4cm, height: 4cm, amount: 0.6))
#rect(width: 100%, height: 3cm, fill: grain)
```

The available kinds and their parameters are listed in the [Textures reference](../reference/textures.md).
