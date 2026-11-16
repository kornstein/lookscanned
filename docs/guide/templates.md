# Templates

Templates are show rules that set page geometry, styles and environments. Two rules keep them working with `scan`:

1. Apply `scan` **after** your `set page` rules.
2. Apply `scan` **before** a template rule that must come last.

```typst
#import "@preview/lookscanned:0.2.0"
#import "@preview/mousse-notes:2.0.1": *

#set page(width: 139.7mm, height: 215.9mm)

#show: lookscanned.scan.with(preset: "old-paper", seed: 12, edges: (binding: true))
#show: style

= Lorem ipsum

#definition[
  #lorem(30)
]
```

Theorem environments, headers, footers and numbering are preserved: `scan` changes paint and position, not the document tree.

## Page background and foreground

`scan` sets `page.background` and `page.foreground`. If the template sets them too, the rule applied last wins:

```typst
#show: lookscanned.scan // lookscanned layers
#show: style            // template layers: lookscanned's are replaced
```

To mix your own layers with lookscanned's, build the background yourself; see [Raw textures](textures.md#raw-textures).

## Settings by document

| Document | Settings |
|---|---|
| Old textbook | `preset: "old-paper"`, `edges: (binding: true)` |
| Photocopied problem sheet | `preset: "photocopy"`, `edges: (punch-holes: true)` |
| Course handout from the 1970s | `preset: "mimeograph"` |
| Typed thesis draft | `preset: "typewriter"` and a monospaced text font |
| Archived article | `preset: "microfilm"` |

Full documents, one per preset: [`examples/`](https://github.com/kornstein/lookscanned/tree/main/examples).

## Granularity and layout

`"word"` boxes every word, which prevents hyphenation: a justified paragraph may break differently. `"char"` shifts characters vertically, which can slightly change kerning. Use `"line"` or `"page"` when the layout must match exactly. See [Text › Movement](text.md#movement).
