# Tune the ink

The `ink` theme controls how the letters themselves look: how much the ink spreads into the paper, how evenly it was applied, and how much of it is missing.

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  ink: (bleed: 0.6, fade: 0.3, wear: 0.2, legibility: 0.9),
)
```

The images below use the `clean-scan` preset with a single setting changed. Ink effects are fine-grained: zoom in on the PDF to see them in full.

## Make the ink spread

`bleed` makes each glyph grow unevenly, with blotchy edges, as when ink soaks into absorbent paper. Values around `0.3` look like an ordinary print; above `1` the text becomes heavy and smudged.

![bleed from 0 to 1.2](../assets/img/ink-bleed.png)

## Make the inking uneven

`fade` lightens some words more than others, towards the paper colour. With `quality: (granularity: "char")` the variation is per character, as with a typewriter.

![fade from 0 to 0.8](../assets/img/ink-fade.png)

## Add dropouts

`wear` punches small holes in the ink: a worn ribbon, dry toner, a tired stamp pad.

![wear from 0 to 1](../assets/img/ink-wear.png)

## Make the text harder to read

`legibility` goes from `1` (sharp) to `0` (barely readable). Lowering it softens the edges into a halo, adds dropouts and fades the ink, all at once. It is the quickest way to degrade a document without tuning each setting.

![legibility 1, 0.7 and 0.4](../assets/img/ink-legibility.png)

!!! note

    The halo produced by low `legibility` is finer than a screen pixel at normal zoom. It shows on paper and when you zoom in.

## Faint duplicated letters

`ghosting: true` adds faint offset copies of each word, like a blurry fax. It is off by default because many PDF tools (copy and paste, search, `pdftotext`) then see each word several times. Turn it on only for documents nobody needs to copy text from.

```typst
#show: lookscanned.scan.with(preset: "fax", ink: (ghosting: true))
```

## Things to know

- Text filled with a gradient or a tiling is left untouched.
- Some PDF viewers draw the textured edges as plain ink. See [Limitations](../explanation/limitations.md#pdf-viewers-and-exports).
