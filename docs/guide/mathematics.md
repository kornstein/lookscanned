# Mathematics and templates

## Equations

`scan` and `region` ink every equation as a whole: variables, operators and large symbols get the same `bleed`, `fade` and `wear` as the text. Block equations rotate with the page; inline equations move with their paragraph. Equations stay selectable and the layout is unchanged.

Fraction bars and radical lines are drawn as lines, not glyphs: they do not bleed.

## Templates

Apply `scan` after your `set page` rules and **before** a template rule that must come last, such as [mousse-notes](https://typst.app/universe/package/mousse-notes/):

```typst
#import "@preview/lookscanned:0.2.0"
#import "@preview/mousse-notes:2.0.1": *

#set page(width: 139.7mm, height: 215.9mm)

#show: lookscanned.scan.with(preset: "old-paper", seed: 12, edges: (binding: true))
#show: style

= Sequences of Real Numbers

#definition[
  The sequence $(u_n)$ _converges_ to $ell in RR$ if
  $ forall epsilon > 0, exists N in NN, forall n >= N, abs(u_n - ell) <= epsilon. $
]
```

Theorem environments, headers, footers and numbering are preserved.

`scan` sets the page `background` and `foreground`. If the template sets them too, the rule applied last wins.

## Suggested settings

| Document | Settings |
|---|---|
| Old textbook | `preset: "old-paper"`, `edges: (binding: true)` |
| Photocopied problem sheet | `preset: "photocopy"`, `edges: (punch-holes: true)` |
| Course handout from the 1970s | `preset: "mimeograph"` |
| Typed thesis draft | `preset: "typewriter"` and a monospaced text font |
| Archived article | `preset: "microfilm"` |

Full examples: [`examples/`](https://github.com/kornstein/lookscanned/tree/main/examples), one document per preset.

## Granularity

`"line"` (most presets) and `"page"` never change the layout. `"word"` (`fax`) and `"char"` (`typewriter`) box words, which prevents hyphenation: justified, hyphenated paragraphs may break differently. See [Limitations](../internals.md#layout-and-granularity).
