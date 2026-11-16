---
title: lookscanned
---

# lookscanned

**Make a Typst document look scanned, photocopied, faxed or typewritten.**

<figure markdown>
![Lorem ipsum excerpt with the old-paper preset](assets/img/hero.png)
<figcaption><code>old-paper</code>, <code>seed: 3</code>.</figcaption>
</figure>

```typst
#import "@preview/lookscanned:0.2.0"

#show: lookscanned.scan.with(preset: "old-paper", seed: 3)
```

The package adds paper, stains, dust, lighting, damage, page rotation and textured ink around the document; the content itself is never rasterised.

| Guarantee | What it means |
|---|---|
| **Text stays text** | Nothing is turned into an image. Text and equations remain selectable, searchable and readable by screen readers. |
| **Layout is unchanged** | Line and page breaks match the clean document, with the `"page"` and `"line"` granularities. |
| **Output is deterministic** | The same source and `seed` give the same PDF, byte for byte. |

Typst 0.14 or later. The Rust plugin ships inside the package; nothing else to install.

## Documentation

| Section | Contents |
|---|---|
| [Getting started](getting-started.md) | Installation, first document, presets and themes |
| [Guide](guide/presets.md) | Presets, text and ink, page effects, pages and regions, decorations, templates, performance |
| [Reference](reference/api.md) | Public API, themes, presets, texture kinds |
| [Internals](internals.md) | Architecture, rendering pipeline, determinism, limitations |
| [Development](development.md) | Toolchain, tasks, tests, release process |
