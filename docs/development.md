# Development

Building lookscanned from source, testing, packaging and maintaining this documentation.

## Requirements

| Tool | Purpose |
|---|---|
| Rust with the `wasm32-unknown-unknown` target (`just toolchain`) | Plugin |
| [Typst](https://typst.app) ≥ 0.14 | Package and tests |
| [just](https://just.systems) | Task runner |
| `wasm-opt` (binaryen), optional | Plugin size |
| `pdftotext` (poppler), optional | Layout invariance test |
| Ghostscript, [uv](https://docs.astral.sh/uv/) | Documentation and README images |

## Repository layout

```text
src/            Rust plugin
typst/          Typst sources, copied as is into the package
tests/          Typst files compiled by `just test`
examples/       Example documents; examples/docs/ renders figures and README images
assets/         README images and package thumbnail (committed)
docs/           This documentation (Zensical)
```

## Tasks

| Command | Description |
|---|---|
| `just build` | Compile the plugin and copy it to `typst/lookscanned.wasm` |
| `just lint` | `cargo fmt --check` and `cargo clippy -D warnings` |
| `just test` | Rust unit tests, compile `tests/` and `examples/`, layout invariance check |
| `just package` | Assemble `dist/lookscanned/<version>/` (runs `wasm-opt` when available) |
| `just check` | Compile a document against `dist/` through a temporary `@local` path |
| `just install-local` | Install as `@local/lookscanned:<version>` |
| `just publish` | Copy the package into a clone of `typst/packages` |
| `just readme-images` | Render `assets/*.png` |
| `just docs-images` | Render the documentation figures into `docs/assets/img/` (not committed) |
| `just docs-serve` | Preview the documentation at <http://localhost:8000> |
| `just docs-build` | Build the site into `site/`, failing on broken links |

During development, documents import the sources directly and are compiled with `--root .`:

```typst
#import "/typst/lib.typ" as lookscanned
```

## Tests

- **Unit tests** (`cargo test`): determinism of every texture kind, PNG structure, RNG range and tiling.
- **Compilation** (`tests/*.typ`, `examples/*.typ`): every public function, every texture kind, every granularity, pages without fixed height, rotation, and the snippets shown in this documentation (`tests/docs-snippets.typ`).
- **Layout invariance**: `tests/layout.typ` is compiled once without effect and once per preset; the text extracted by `pdftotext` must be identical line by line.

## Local installation

```sh
just install-local
```

```typst
#import "@local/lookscanned:0.1.0"
```

## Release

The version is defined once, in `Cargo.toml`; `typst.toml` is generated from `typst/typst.toml.in`.

```sh
just lint test check
just publish        # TYPST_PACKAGES defaults to ../typst-packages
```

Then open a pull request on [typst/packages](https://github.com/typst/packages). The package README is `typst/README.md`; it must use absolute image URLs, since `assets/` is not part of the package.

## Documentation

The site is built with [Zensical](https://zensical.org), pinned in `requirements-docs.txt`. Figures come from `examples/docs/figures.typ`, one per `--input fig=<name>`; the list is `docs_figures` in the `justfile`. They are exported to PDF and converted with Ghostscript, because Typst's PNG export fails on textured ink (see [Limitations](internals/limitations.md#pdf-viewers)).

`.github/workflows/docs.yml` builds the plugin, the figures and the site on every push and pull request, and deploys to GitHub Pages from `main`. One-time setup: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
