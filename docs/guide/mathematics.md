# Mathematics

lookscanned is designed to work on mathematical documents: lecture notes, problem sheets, theses, reproductions of old textbooks. This page describes how equations are treated and how to combine the package with a document template.

## Equations

Typst lays out math letters and symbols without going through `text` elements, so a `show text` rule alone would ink digits and upright words but leave variables and operators untouched. `scan` and `region` therefore also apply the ink to each `math.equation` as a whole:

- every glyph of an equation, including variables, operators and large symbols, receives the same `bleed`, `fade` and `wear` as the surrounding text;
- block equations are rotated with the rest of the page, like paragraphs;
- inline equations move with their paragraph.

The equation remains real text: it can be selected and copied, and the layout is unchanged.

!!! note "Rules and fraction bars"

    Fraction bars and radical overlines are drawn as lines, not glyphs. They keep a plain stroke and do not bleed.

## Use with a template

A template is usually applied with its own show rule. Place `scan` **before** the template rule when the template requires to be last, as [mousse-notes](https://typst.app/universe/package/mousse-notes/) does:

```typst
#import "@preview/lookscanned:0.1.0"
#import "@preview/mousse-notes:2.0.1": *

#set document(title: [Elements of Analysis], author: "A. N. Example")
#set page(width: 139.7mm, height: 215.9mm)

#show: lookscanned.scan.with(preset: "old-paper", seed: 12, edges: (binding: true))
#show: style

#title-page(subtitle: upper[Volume I: Sequences and Series])

= Sequences of Real Numbers

#definition[
  The sequence $(u_n)$ _converges_ to $ell in RR$ if
  $ forall epsilon > 0, exists N in NN, forall n >= N, abs(u_n - ell) <= epsilon. $
]
```

The complete example is [`examples/old-textbook.typ`](https://github.com/kornstein/lookscanned/blob/main/examples/old-textbook.typ). Theorem environments, headers, footers and numbering are all preserved; only their appearance changes.

`scan` sets the page `background` and `foreground`. If the template also sets them, the rule applied last wins.

## Recommended settings

| Document | Settings |
|---|---|
| Old textbook | `preset: "old-paper"`, `edges: (binding: true)` |
| Photocopied problem sheet | `preset: "photocopy"`, `edges: (punch-holes: true)` |
| Typed thesis draft | `preset: "typewriter"` with a monospaced text font; math keeps its own font |
| Scanned handwritten-style notes | `preset: "phone-scan"` |

## Granularity and justification

With `quality.granularity` set to `"word"` or `"char"`, words are boxed or shifted individually and can no longer be hyphenated. Justified, hyphenated paragraphs may then break differently from the clean document. `"line"` (the default for most presets) and `"page"` never change the layout. See [Limitations](../internals/limitations.md#layout-and-granularity).
