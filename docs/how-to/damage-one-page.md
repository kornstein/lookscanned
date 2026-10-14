# Damage a single page

Every page already gets its own stains, tilt and dust, drawn from the seed. To make one page look different on purpose, wrap its content in `lookscanned.page`.

```typst
#show: lookscanned.scan.with(preset: "office-scan")

= Report
…

#pagebreak()

#lookscanned.page(stains: (amount: 1), skew: (page-rotation: 2deg), edges: (binding: true))[
  = Damaged appendix
  …
]
```

<div class="grid" markdown>

![A normal page](../assets/img/page-override-1.png)

![The damaged page: more stains, more rotation, a binding shadow](../assets/img/page-override-2.png)

</div>

## How it applies

- The settings apply to every page the body touches, from the page where it starts to the page where it ends.
- `page` does not insert page breaks. Add `#pagebreak()` yourself if the damaged content must start on a new page.
- It accepts the same arguments as `scan`: `preset`, `intensity`, `seed` and themes. Settings you do not pass are inherited from `scan`. If you pass a `preset`, it replaces the preset of `scan` for those pages.
- It changes page-level effects: paper, stains, dust, lighting, scanner artefacts and page rotation.

!!! warning "Text effects are not overridden"

    Ink (`bleed`, `fade`, `wear`, `legibility`) and word or character jitter keep the values set by `scan`. To change the text itself in one place, use [`region`](scan-a-region.md).

Calls to `lookscanned.page` cannot be nested.
