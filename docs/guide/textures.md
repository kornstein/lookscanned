# Raw textures

`lookscanned.texture` returns the generated images without the rest of the package, to build custom backgrounds, fills or illustrations.

```typst
#set page(background: lookscanned.texture("paper", seed: 3, color: rgb("#f0e6d2"), grain: 0.5))
#set page(foreground: lookscanned.texture("dust", seed: 3, amount: 0.4))
```

Without `width` and `height`, the texture takes the page size, which requires a fixed page height. Elsewhere, give an explicit size:

```typst
#lookscanned.texture("stains", width: 4cm, height: 4cm, count: 1, min: 25mm, max: 30mm)
```

![The eight texture kinds](../assets/img/textures.png)

## Tiling

`grain`, `toner` and `ink` tile seamlessly and can be repeated with a Typst `tiling`:

```typst
#let grain = tiling(size: (4cm, 4cm), lookscanned.texture("grain", width: 4cm, height: 4cm, amount: 0.6))
#rect(width: 100%, height: 3cm, fill: grain)
```

## Combining with `scan`

`scan` sets the page `background` and `foreground`; a later `set page(background: ..)` replaces them in turn. To combine your own layers with generated textures, build the background yourself from `texture` calls instead of using `scan`:

```typst
#set page(background: {
  place(lookscanned.texture("paper", seed: 1, color: rgb("#f4efe4"), aging: 0.3))
  place(center + horizon, text(60pt, fill: luma(225))[DRAFT])
})
```

Kinds and parameters are listed in the [Textures reference](../reference/textures.md).
