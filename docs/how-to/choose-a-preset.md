# Choose a preset

A preset is a complete look: paper, stains, ink, rotation and lighting chosen to work together. Pick the closest one, then adjust it.

```typst
#show: lookscanned.scan.with(preset: "photocopy")
```

If you call `scan` without `preset`, it uses `"office-scan"`.

## Gallery

All images show the same letter with `seed: 3`.

<div class="grid" markdown>

<figure markdown>
![clean-scan preset](../assets/img/preset-clean-scan.png)
<figcaption><code>clean-scan</code>: very slight rotation, little grain, off-white paper</figcaption>
</figure>

<figure markdown>
![office-scan preset](../assets/img/preset-office-scan.png)
<figcaption><code>office-scan</code>: moderate grain, edge shadows, slight drift</figcaption>
</figure>

<figure markdown>
![photocopy preset](../assets/img/preset-photocopy.png)
<figcaption><code>photocopy</code>: high contrast, bands, dust, scratches, heavy bleed</figcaption>
</figure>

<figure markdown>
![fax preset](../assets/img/preset-fax.png)
<figcaption><code>fax</code>: transmission lines, irregular words, very degraded</figcaption>
</figure>

<figure markdown>
![typewriter preset](../assets/img/preset-typewriter.png)
<figcaption><code>typewriter</code>: per-character jitter, uneven inking, worn ribbon</figcaption>
</figure>

<figure markdown>
![old-paper preset](../assets/img/preset-old-paper.png)
<figcaption><code>old-paper</code>: yellowing, foxing, stains, vignette</figcaption>
</figure>

<figure markdown>
![phone-scan preset](../assets/img/preset-phone-scan.png)
<figcaption><code>phone-scan</code>: skew and uneven lighting</figcaption>
</figure>

</div>

## Which preset for which use

| You want… | Use |
|---|---|
| A tidy archive copy, barely noticeable | `clean-scan` |
| A typical document that went through an office scanner | `office-scan` |
| A copy of a copy, high contrast, dirty glass | `photocopy` |
| A document received by fax, hard to read | `fax` |
| A letter typed on a mechanical typewriter | `typewriter` |
| A document that spent decades in an attic | `old-paper` |
| A page photographed with a phone | `phone-scan` |

!!! tip "Typewriter look"

    The `typewriter` preset changes the ink and the character placement, not the font. For a convincing result, also set a monospaced font, for example `#set text(font: "Courier Prime")` if you have it installed.

## Make a preset lighter or stronger

Use `intensity` before touching individual settings:

```typst
#show: lookscanned.scan.with(preset: "fax", intensity: 0.5)  // half as degraded
#show: lookscanned.scan.with(preset: "clean-scan", intensity: 2)  // twice as strong
```

`intensity` scales amounts, angles and lengths. It does not change colours, sizes, the resolution, or on/off switches. See [Themes](../reference/themes.md#intensity) for the exact rule.

## See also

- [Presets reference](../reference/presets.md): the exact values of each preset.
- [Create a custom preset](custom-presets.md).
