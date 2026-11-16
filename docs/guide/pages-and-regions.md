# Pages and regions

`scan` configures the whole document. Two functions narrow the scope:

| Function | Scope | Effects | Needs `scan` |
|---|---|---|---|
| `page` | The pages its body spans | Page effects only | yes |
| `region` | One block | Text effects, paper fill, rotation | no |

## `page`

```typst
#show: lookscanned.scan.with(preset: "office-scan")

= Lorem ipsum

#lorem(30)

#pagebreak()
#lookscanned.page(stains: (amount: 1), skew: (page-rotation: 2deg), edges: (binding: true))[
  = Dolor sit amet
  #lorem(30)
]
```

<div class="grid" markdown>

![Regular page](../assets/img/page-override-1.png)

![Overridden page](../assets/img/page-override-2.png)

</div>

- Applies from the page where the body starts to the page where it ends.
- Inserts no page break: add `#pagebreak()` yourself.
- Takes the same arguments as `scan`. Unset arguments are inherited from `scan`; `preset` replaces the document's preset on those pages.
- Overrides **page effects only**: paper, stains, dust, lighting, damage, scanner, page rotation and block jitter. Ink and word or character jitter keep the `scan` settings.
- Cannot be nested.

```typst
// A title page without stains or edge effects.
#lookscanned.page(stains: none, edges: none)[= Lorem ipsum]
```

## `region`

```typst
#lorem(12)

#lookscanned.region(preset: "typewriter", seed: 2)[
  = Lorem ipsum
  #lorem(40)
]

#lorem(12)
```

![A clean document with a typewritten block](../assets/img/region.png)

`region` returns a full-width block filled with the paper colour and grain. Its text, equations and strokes are inked and jittered, and the block is rotated by an angle drawn from `skew.page-rotation`.

- It draws no stains, dust, lighting, damage or scanner effects: page effects belong to `scan` and `page`.
- Use it in a document **without** `scan`. Inside `scan`, text effects would apply twice.

## Which one

- Whole document: `scan`.
- A few pages, or a title page: `scan` + `page`.
- One excerpt in a clean document: `region`.
