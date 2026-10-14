# Add stamps, handwritten notes and stains

Decorations are placed where you call them, like any Typst content. Each one accepts `at: (x: .., y: ..)` to place it at a position relative to the text area instead of inline.

![Two stamps, a handwritten note, a scrawl and a stain](../assets/img/decorations.png)

## Add a rubber stamp

```typst
#lookscanned.stamp("Received")
#lookscanned.stamp("Paid", color: rgb("#1f4e9c"), angle: 8deg, at: (x: 70%, y: 80%))
```

The text is set in bold capitals inside a double frame, rotated by `angle`, with patchy ink. Use `size` to change the text size and `seed` for another ink pattern.

## Add a handwritten note

```typst
#lookscanned.scribble(body: "Seen, OK", color: blue)
```

With a `body`, `scribble` writes it in a wobbly italic. Without one, it draws a scrawl of the given `width`, which works as a signature or a crossing-out:

```typst
#lookscanned.scribble(width: 3.5cm, seed: 4)
```

!!! note

    The handwriting is an approximation: the current font in italics, with each letter slightly moved and rotated. For a more convincing result, set a handwriting font around it, for example `#text(font: "Caveat")[#lookscanned.scribble(body: "Seen")]`.

## Add a stain

```typst
#lookscanned.stain(at: (x: 60%, y: 20%), color: rgb("#6b4423"), size: 25mm)
```

`at` is the centre of the stain. Without `at`, the stain is inserted inline.

To scatter random stains over every page, use the [`stains` theme](age-the-paper.md#add-stains-dust-and-scratches) instead.
