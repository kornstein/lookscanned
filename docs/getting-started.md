# Getting started

## Install

=== "Typst Universe"

    ```typst
    #import "@preview/lookscanned:0.2.0"
    ```

=== "Local build"

    ```sh
    git clone https://github.com/kornstein/lookscanned
    cd lookscanned
    just install-local
    ```

    ```typst
    #import "@local/lookscanned:0.2.0"
    ```

    Needs Rust and `just`; see [Development](development.md).

Every function is called through the `lookscanned` module.

## 1. Start from a document

```typst title="notes.typ"
#set page(width: 12cm, height: 7cm, margin: (x: 1cm, y: 0.9cm))
#set text(font: "New Computer Modern", size: 10pt)
#set par(justify: true)

= Cauchy sequences

A sequence $(u_n)$ of real numbers is a _Cauchy sequence_ if for every
$epsilon > 0$ there exists $N in NN$ such that $abs(u_p - u_q) <= epsilon$
for all $p, q >= N$.

*Theorem 1.4.* A real sequence converges if and only if it is a Cauchy
sequence. In particular, for $abs(q) < 1$,
$ sum_(n=0)^infinity q^n = 1 / (1 - q). $
```

![The source document](assets/img/start-1.png)

## 2. Apply a preset

Add the `scan` show rule **after** your `set page` rules:

```typst
#import "@preview/lookscanned:0.2.0"

#set page(width: 12cm, height: 7cm, margin: (x: 1cm, y: 0.9cm))
#show: lookscanned.scan.with(preset: "office-scan")
```

![With office-scan](assets/img/start-2.png)

## 3. Scale and vary it

- `intensity`: `0` disables everything, `1` is the preset, more exaggerates.
- `seed`: an integer. Each value gives another reproducible variant.

```typst
#show: lookscanned.scan.with(preset: "office-scan", seed: 7, intensity: 1.6)
```

![Intensity 1.6, seed 7](assets/img/start-3.png)

## 4. Change individual settings

Settings are grouped in seven *themes*: `paper`, `stains`, `ink`, `skew`, `edges`, `scanner`, `quality`. Keys you omit keep the preset's value; `none` turns a theme or a key off.

```typst
#show: lookscanned.scan.with(
  preset: "office-scan",
  seed: 7,
  intensity: 1.6,
  paper: (color: rgb("#f3ead6"), aging: 0.4),
  ink: (bleed: 0.6),
)
```

A typo in a theme, key or type stops compilation with an error naming it.

## 5. Add a decoration

```typst
#lookscanned.stamp("Library copy", color: rgb("#5b3a8c"), at: (x: 62%, y: 76%), size: 10pt)
```

![Aged paper, more bleed, a stamp](assets/img/start-4.png)

## Next

- [Presets](guide/presets.md): the ten built-in looks.
- [Themes reference](reference/themes.md): every setting.
