# Your first scanned document

In this tutorial you take a plain Typst letter and turn it, step by step, into a document that looks like an old office scan. You apply a preset, make the effect stronger, adjust the paper and the ink yourself, and finish with a rubber stamp.

It takes about ten minutes. You need Typst 0.14 or later and the lookscanned package (see [Quick start](../index.md#quick-start)).

## 1. Start from a plain document

Create a file named `letter.typ`:

```typst
#set page(width: 12cm, height: 8.5cm, margin: (x: 1cm, y: 0.9cm))

= Rental agreement

Between the undersigned, it has been agreed as follows. The landlord rents
to the tenant the premises described below, for a period of three years
starting on the first of March. The rent is payable monthly and in advance.

- Article 1: the premises are let unfurnished.
- Article 2: the deposit equals two months of rent.
```

Compile it with `typst compile letter.typ`. You get a clean, digital-looking page:

![The plain letter](../assets/img/tutorial-1.png)

## 2. Apply a preset

Import the package and add one show rule at the top of the file, after the `set page` line:

```typst
#import "@preview/lookscanned:0.1.0"

#set page(width: 12cm, height: 8.5cm, margin: (x: 1cm, y: 0.9cm))
#show: lookscanned.scan.with(preset: "office-scan")
```

Compile again. The page now has grain, a shadow along one edge and a little dust, and the text is very slightly tilted and smudged:

![The letter with the office-scan preset](../assets/img/tutorial-2.png)

Notice that the text did not move: every line ends on the same word as before. You can still select and copy it in your PDF viewer.

## 3. Make it stronger and pick another variant

Two arguments control the overall result:

- `intensity` multiplies every effect. `1` is the preset as designed, `0` disables everything, and values above `1` exaggerate it.
- `seed` chooses one variant among many. Each seed gives a different, but reproducible, set of stains, tilts and specks.

Change the show rule:

```typst
#show: lookscanned.scan.with(preset: "office-scan", seed: 7, intensity: 1.6)
```

![The letter with a stronger effect and seed 7](../assets/img/tutorial-3.png)

Try a few other seeds. When you find one you like, keep it: the document will look exactly the same every time you compile it.

## 4. Adjust the paper and the ink

Each kind of effect lives in a *theme*, a dictionary you pass to `scan`. You only write the keys you want to change; everything else keeps the preset's value.

Make the paper yellower and the ink bleed more:

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  seed: 7,
  intensity: 1.6,
  paper: (color: rgb("#f3ead6"), aging: 0.4),
  ink: (bleed: 0.6),
)
```

## 5. Add a stamp

Decorations are ordinary functions. Add a stamp at the end of the document, placed relative to the text area:

```typst
#lookscanned.stamp("Received", at: (x: 66%, y: 74%), size: 12pt)
```

![The finished letter: aged paper, bleeding ink and a red stamp](../assets/img/tutorial-4.png)

## What you have learned

- `#show: lookscanned.scan.with(..)` applies the effect to the whole document.
- A `preset` gives a complete look; `intensity` and `seed` vary it.
- Themes such as `paper` and `ink` override individual settings.
- Decorations like `stamp` are placed where you call them.

Next, browse the [presets](../how-to/choose-a-preset.md) or learn how to [tune the ink](../how-to/tune-the-ink.md).
