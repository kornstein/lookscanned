---
title: lookscanned
---

# lookscanned

**A Typst package that renders documents as if they had been scanned, photocopied, faxed or typed.**

lookscanned adds paper texture, stains, dust, scanner lighting, page rotation and ink effects to a Typst document. The textures and the randomness come from a WebAssembly plugin written in Rust; the effects are applied by Typst itself. The package guarantees three properties:

- **Text is preserved.** Glyphs are never rasterised. Text stays selectable, searchable and readable by assistive technologies.
- **Layout is preserved.** Line and page breaks are identical with and without the effect (verified by the test suite for every preset).
- **Rendering is deterministic.** The same source and the same `seed` produce the same PDF.

<figure markdown>
![An excerpt on Cauchy sequences rendered with the old-paper preset](assets/img/hero.png)
<figcaption>The <code>old-paper</code> preset on a page of lecture notes.</figcaption>
</figure>

## Minimal example

```typst
#import "@preview/lookscanned:0.1.0"

#show: lookscanned.scan.with(preset: "old-paper", seed: 3)

= Cauchy sequences
A sequence $(u_n)$ is a _Cauchy sequence_ if for every $epsilon > 0$ there
exists $N$ such that $abs(u_p - u_q) <= epsilon$ for all $p, q >= N$.
```

!!! warning "Not on Typst Universe yet"

    Until the package is published, install it locally and import `@local/lookscanned:0.1.0`. See [Development](development.md#local-installation).

## Contents

| Section | Content |
|---|---|
| [Getting started](getting-started.md) | Installation and a step-by-step first document |
| **Guide** | |
| [Presets](guide/presets.md) | The seven built-in looks, `intensity` and `seed` |
| [Ink](guide/ink.md) | Bleed, fade, wear, legibility, ghosting |
| [Paper and scanner](guide/paper.md) | Paper colour and ageing, stains, dust, lighting, fax lines |
| [Mathematics](guide/mathematics.md) | Equations, templates such as mousse-notes, fonts |
| [Pages and regions](guide/pages-and-regions.md) | Per-page overrides and partial effects |
| [Decorations](guide/decorations.md) | Stamps, handwritten notes, stains |
| [Custom presets](guide/custom-presets.md) | Defining, deriving and sharing presets |
| [Performance](guide/performance.md) | Compile time and PDF size |
| [Raw textures](guide/textures.md) | Using the generated images directly |
| **Reference** | |
| [API](reference/api.md) | Every public function and its arguments |
| [Themes](reference/themes.md) | Every setting, its type and neutral value; intensity scaling |
| [Presets](reference/presets.md) | Exact values of the built-in presets |
| [Textures](reference/textures.md) | Texture kinds and their parameters |
| **Internals** | |
| [Architecture](internals/architecture.md) | Plugin protocol, rendering pipeline, determinism |
| [Limitations](internals/limitations.md) | Known constraints, viewer support, responsible use |
| [Development](development.md) | Building, testing, packaging, documentation |

## Requirements

Typst 0.14 or later. No external tool is needed to compile a document: the plugin ships inside the package.
