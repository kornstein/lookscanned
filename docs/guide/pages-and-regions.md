# Pages and regions

`scan` configures the whole document. Two functions narrow the scope:

| Function | Scope | Effects | Needs `scan` |
|---|---|---|---|
| `page` | The pages its body spans | Page effects only | yes |
| `region` | One block | Text effects, paper fill, rotation | no |

## `page`

```typst
#show: lookscanned.scan.with(preset: "office-scan")

= Lecture notes
…

#pagebreak()
#lookscanned.page(stains: (amount: 1), skew: (page-rotation: 2deg), edges: (binding: true))[
  = Appendix
  …
]
```

<div class="grid" markdown>

![Regular page](../assets/img/page-override-1.png)

![Overridden page](../assets/img/page-override-2.png)

</div>

- Applies from the page where the body starts to the page where it ends.
- Inserts no page break: add `#pagebreak()` yourself.
- Same arguments as `scan`. Unset ones are inherited from `scan`; `preset` replaces the document's preset on those pages.
- Overrides **page effects only**: paper, stains, dust, lighting, damage, scanner, page rotation. Ink and word or character jitter keep the `scan` settings.
- Cannot be nested.

```typst
// A clean title page.
#lookscanned.page(stains: none, edges: none)[= Title]
```

## `region`

```typst
The proof below is reproduced from the 1958 edition.

#lookscanned.region(preset: "typewriter", seed: 2)[
  *Proof.* Let $epsilon > 0$ and choose $N$ such that $abs(u_n - ell) <= epsilon$
  for all $n >= N$. Then $abs(u_p - u_q) <= 2 epsilon$ for all $p, q >= N$.
]
```

![A clean document with a typewritten block](../assets/img/region.png)

Returns a full-width block that is filled with the paper colour and grain, inks and jitters its text, equations and strokes, and is rotated by an angle drawn from `skew.page-rotation`.

It draws no stains, dust, lighting, damage or scanner effects. Use it in a document **without** `scan`; inside one, text effects would apply twice.
