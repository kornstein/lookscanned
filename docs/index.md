---
title: lookscanned
---

# lookscanned

**Make a Typst document look scanned, photocopied, faxed or typewritten.**

<figure markdown>
![Lecture notes rendered with the old-paper preset](assets/img/hero.png)
<figcaption>The <code>old-paper</code> preset.</figcaption>
</figure>

```typst
#import "@preview/lookscanned:0.2.0"

#show: lookscanned.scan.with(preset: "old-paper", seed: 3)
```

lookscanned adds paper, stains, dust, lighting, page rotation and textured ink. Three guarantees:

- **Text stays text.** Nothing is rasterised: text and equations remain selectable, searchable and accessible.
- **Layout is unchanged.** Line and page breaks match the clean document (tested for every preset).
- **Rendering is deterministic.** Same source and `seed`, same PDF.

Requires Typst 0.14 or later. The Rust plugin ships inside the package; nothing else to install.

## Where to go

| I want to… | Page |
|---|---|
| Get a first result | [Getting started](getting-started.md) |
| Pick or build a look | [Presets](guide/presets.md) |
| Tune the text | [Ink](guide/ink.md) |
| Tune the sheet: paper, stains, lighting, damage | [Paper and page effects](guide/paper.md) |
| Change a few pages, or one block | [Pages and regions](guide/pages-and-regions.md) |
| Add stamps, notes, highlights, stains | [Decorations](guide/decorations.md) |
| Use it with equations or a template | [Mathematics and templates](guide/mathematics.md) |
| Speed up compilation, or use raw images | [Performance and textures](guide/textures.md) |
| Look up an argument | [API](reference/api.md), [Themes](reference/themes.md) |
| Know the limits | [Internals › Limitations](internals.md#limitations) |
