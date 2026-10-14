# Scan only part of a document

Use `lookscanned.region` to make one block look scanned while the rest of the document stays clean, for example an appendix "received by fax".

```typst
This paragraph stays clean.

#lookscanned.region(preset: "fax", seed: 2)[
  *Appendix B.* This part looks like it came in by fax.
]

Back to clean text.
```

![A clean document with one fax-looking block](../assets/img/region.png)

## What a region does

- It applies the text effects (ink and jitter) to its content.
- It draws the content on a full-width block filled with the paper colour and grain.
- It rotates the block slightly, according to `skew.page-rotation`.

It does not draw stains, dust, lighting or scanner lines: those are page-level effects.

`region` accepts the same arguments as `scan` and works without `scan`. Inside a document that already uses `scan`, the text effects would apply twice; use [`lookscanned.page`](damage-one-page.md) there instead.
