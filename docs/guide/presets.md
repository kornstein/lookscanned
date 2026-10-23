# Presets

A preset is a dictionary of themes describing a complete look. `scan`, `page` and `region` accept a preset name or a dictionary (see [Custom presets](custom-presets.md)). Without `preset`, `scan` uses `"office-scan"`.

```typst
#show: lookscanned.scan.with(preset: "photocopy")
```

## Gallery

Same excerpt, `seed: 3`.

<div class="grid" markdown>

<figure markdown>
![clean-scan](../assets/img/preset-clean-scan.png)
<figcaption><code>clean-scan</code>: off-white paper, little grain, minimal rotation</figcaption>
</figure>

<figure markdown>
![office-scan](../assets/img/preset-office-scan.png)
<figcaption><code>office-scan</code>: moderate grain, edge shadow, slight drift</figcaption>
</figure>

<figure markdown>
![photocopy](../assets/img/preset-photocopy.png)
<figcaption><code>photocopy</code>: heavy bleed, drum bands, dust, scratches</figcaption>
</figure>

<figure markdown>
![fax](../assets/img/preset-fax.png)
<figcaption><code>fax</code>: transmission lines, per-word jitter, low legibility</figcaption>
</figure>

<figure markdown>
![typewriter](../assets/img/preset-typewriter.png)
<figcaption><code>typewriter</code>: per-character jitter, uneven inking, worn ribbon</figcaption>
</figure>

<figure markdown>
![old-paper](../assets/img/preset-old-paper.png)
<figcaption><code>old-paper</code>: yellowing, foxing, stains, vignette</figcaption>
</figure>

<figure markdown>
![phone-scan](../assets/img/preset-phone-scan.png)
<figcaption><code>phone-scan</code>: strong rotation, uneven lighting</figcaption>
</figure>

</div>

## Selection

| Document | Preset |
|---|---|
| Archived copy, barely noticeable | `clean-scan` |
| Departmental scan of lecture notes | `office-scan` |
| Problem sheet copied many times | `photocopy` |
| Document received by fax | `fax` |
| Typed manuscript or thesis draft | `typewriter` |
| Textbook or journal from a library shelf | `old-paper` |
| Page photographed with a phone | `phone-scan` |

!!! tip "Typewriter"

    The `typewriter` preset changes ink and character placement, not the font. Combine it with a monospaced face, for example `#set text(font: "Courier Prime")`.

## Intensity

`intensity` scales a preset without editing it:

```typst
#show: lookscanned.scan.with(preset: "fax", intensity: 0.5)        // half as degraded
#show: lookscanned.scan.with(preset: "clean-scan", intensity: 2)   // twice as strong
```

Amounts, angles and lengths are multiplied; `legibility` is degraded proportionally; colours, sizes, switches and quality settings are left unchanged. The exact rule is given in [Themes › Intensity](../reference/themes.md#intensity).

## Seed

Every random choice derives from `seed` (an integer, default `0`), the page number and stable properties of the content. Changing the seed changes the arrangement; keeping it reproduces the document exactly.

## See also

- [Presets reference](../reference/presets.md): exact values.
- [Custom presets](custom-presets.md).
