---
title: lookscanned
---

# lookscanned

**Make a Typst document look scanned, photocopied, faxed or typed on a typewriter.**

lookscanned adds paper grain, stains, dust, bleeding ink and slightly rotated pages to any Typst document. A small WebAssembly plugin generates the textures and the randomness, and Typst applies the effects. As a result:

- the text stays real text: selectable, searchable, copyable;
- the layout does not move: line and page breaks are the same as without the effect;
- the same `seed` always gives the same result.

<figure markdown>
![A rental agreement rendered with the office-scan preset, with a red "Received" stamp](assets/img/hero.png)
<figcaption>The <code>office-scan</code> preset with a stamp.</figcaption>
</figure>

## Quick start

```typst
#import "@preview/lookscanned:0.1.0"

#show: lookscanned.scan.with(preset: "office-scan")

= Rental agreement
Between the undersigned, it has been agreed as follows…
```

!!! warning "Not on Typst Universe yet"

    Until the package is published, install it locally and import `@local/lookscanned:0.1.0` instead. See [Development](contributing/development.md#install-the-package-locally).

## Where to go next

<div class="grid cards" markdown>

-   __Tutorial__

    ---

    Start here. Turn a plain document into a convincing scan in a few steps.

    [Your first scanned document](tutorial/first-scanned-document.md)

-   __How-to guides__

    ---

    Recipes for specific goals: pick a preset, tune the ink, age the paper, damage one page, add a stamp.

    [Choose a preset](how-to/choose-a-preset.md)

-   __Reference__

    ---

    Every function, theme, key and default value.

    [API](reference/api.md) · [Themes](reference/themes.md) · [Presets](reference/presets.md) · [Textures](reference/textures.md)

-   __Explanation__

    ---

    How it works, what it cannot do, and how to use it responsibly.

    [How it works](explanation/how-it-works.md)

</div>
