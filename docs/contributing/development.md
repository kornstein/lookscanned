# Development

This page is for people who want to build lookscanned from source, change it, or publish it.

## Repository layout

```text
src/            Rust plugin: seeded RNG, CBOR parameters, textures → PNG, random table
typst/          Typst sources, copied as is into the published package
tests/          Typst files compiled by `just test`
examples/       Example documents; examples/docs/ renders the figures of this site
docs/           This documentation (Markdown, built with Zensical)
specs/          Functional specification and architecture notes
zensical.toml   Documentation site configuration
```

## Requirements

- Rust with the `wasm32-unknown-unknown` target: `just toolchain`
- [Typst](https://typst.app) 0.14 or later
- [just](https://just.systems)
- Optional: `wasm-opt` (binaryen) to shrink the plugin, `pdftotext` (poppler) for the layout test
- For the documentation: [uv](https://docs.astral.sh/uv/) and Ghostscript (`gs`)

## Build and test

```sh
just build   # compile the plugin and copy it to typst/lookscanned.wasm
just test    # Rust unit tests, compile tests/ and examples/, layout check
```

The layout check compiles `tests/layout.typ` once without effect and once per preset, extracts the text with `pdftotext`, and fails if any line break differs.

While developing, import the sources directly:

```typst
#import "/typst/lib.typ" as lookscanned
```

and compile with `typst compile --root . file.typ`.

## Install the package locally

```sh
just install-local
```

This assembles the package and copies it into Typst's local package directory. Documents can then use:

```typst
#import "@local/lookscanned:0.1.0"
```

## Package and publish

The version comes from `Cargo.toml`. `typst/typst.toml.in` is the template for the package manifest.

```sh
just package   # assemble dist/lookscanned/<version>/
just check     # compile a document against dist/ through @local
just publish   # copy into a clone of typst/packages (TYPST_PACKAGES, default ../typst-packages)
```

Then open a pull request on [typst/packages](https://github.com/typst/packages).

## Documentation

The site is built with [Zensical](https://zensical.org). Its version is pinned in `requirements-docs.txt`.

```sh
just docs-images   # render the figures into docs/assets/img/ (not committed)
just docs-serve    # preview at http://localhost:8000
just docs-build    # build into site/, failing on broken links
```

Figures come from `examples/docs/figures.typ`, one per `--input fig=<name>`. The list of figures is `docs_figures` in the `justfile`. They are exported as PDF and converted with Ghostscript, because Typst's PNG export crashes on the textured ink (see [Limitations](../explanation/limitations.md#pdf-viewers-and-exports)).

### Deployment

`.github/workflows/docs.yml` builds the plugin, the figures and the site on every push and pull request, and deploys to GitHub Pages on pushes to `main`.

One-time setup on GitHub: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
