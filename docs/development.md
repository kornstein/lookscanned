# Development

## Requirements

| Tool | Purpose |
|---|---|
| Rust with the `wasm32-unknown-unknown` target (`just toolchain`) | Plugin |
| [Typst](https://typst.app) ≥ 0.14 | Package and tests |
| [just](https://just.systems) | Task runner |
| `wasm-opt` (binaryen), optional | Plugin size |
| `pdftotext` (poppler), optional | Layout invariance test |
| Ghostscript, [uv](https://docs.astral.sh/uv/) | Documentation and README images (the README falls back on MuPDF through uv) |

## Repository layout

```text
src/            Rust plugin
typst/          Typst sources, copied as is into the package
tests/          Test cases (cases.typ) and their runner (run.typ)
examples/       Example documents; examples/docs/ renders figures and README images
assets/         README images and package thumbnail (committed)
docs/           This documentation (Zensical)
```

## Tasks

| Command | Description |
|---|---|
| `just build` | Compile the plugin and copy it to `typst/lookscanned.wasm` |
| `just lint` | `cargo fmt --check` and `cargo clippy -D warnings` |
| `just test` | Rust unit tests, compile `tests/` and `examples/`, determinism and layout invariance checks |
| `just package` | Assemble `dist/lookscanned/<version>/` (runs `wasm-opt` when available) |
| `just check` | Compile a document against `dist/` through a temporary `@local` path |
| `just install-local` | Install as `@local/lookscanned:<version>` |
| `just publish` | Copy the package into a clone of `typst/packages` |
| `just readme-images` | Render `assets/*.png` |
| `just docs-images` | Render the documentation figures into `docs/assets/img/` (not committed) |
| `just docs-serve` | Preview the documentation at <http://localhost:8000> |
| `just docs-build` | Build the site into `site/`, failing on broken links |

`just build` is required before any Typst compilation: `typst/lookscanned.wasm` is generated, never committed.

During development, documents import the sources directly and are compiled with `--root .`:

```typst
#import "/typst/lib.typ" as lookscanned
```

## Tests

- **Unit tests** (`cargo test`): determinism of every texture kind, PNG structure, RNG range and tiling.
- **Compilation** (`tests/cases.typ`, `examples/*.typ`): every public function, texture kind and granularity, `none` resets, damage, regressions, and the documentation snippets (`docs-*` cases).
- **Determinism**: each case is compiled twice; both PDFs must be byte for byte identical.
- **Layout invariance**: the `layout` case is compiled once without effect and once per preset; the text extracted by `pdftotext` must be identical line by line.

Compile one case or one example:

```sh
typst compile --root . --input case=damage tests/run.typ out.pdf
typst compile --root . examples/fax.typ out.pdf
```

Add a case by adding an entry to the `cases` dictionary; `run.typ` and `just test` discover it.

## Documentation

Built with [Zensical](https://zensical.org), pinned in the `justfile`. Figures come from `examples/docs/figures.typ`, one per `--input fig=<name>`, listed in `docs_figures` in the `justfile`: add both when documenting a new feature. They go through PDF and Ghostscript, because Typst's PNG export fails on textured ink.

- Guide changes go to the page of their theme or function, and to the matching reference page.
- Code extracts from the guide and reference pages are copied into the matching `docs-*` test case.
- A new setting, preset, texture kind or public function must update its guide page, its reference pages, and the counts (`seven themes`, `33 settings`, `ten presets`) in the documentation and READMEs.

## Release

The version is defined once, in `Cargo.toml`; `typst.toml` is generated from `typst/typst.toml.in`.

Every commit with a user-visible change adds its entry to `CHANGELOG.md` under `[Unreleased]`, creating that section at the top if it does not exist yet ([Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`). Changes that make an existing document render differently for the same `seed` are flagged **(render)**.

1. Bump the version in `Cargo.toml` and in the `@preview/lookscanned:<version>` imports of the documentation and READMEs.
2. In `CHANGELOG.md`, rename `[Unreleased]` to `[<version>] - <YYYY-MM-DD>` and add its link at the bottom.
3. Commit, tag `v<version>` and push the tag.

```sh
just lint test check
just publish        # TYPST_PACKAGES defaults to ../typst-packages
```

`just publish` stops if `CHANGELOG.md` has no section for the version or if the tag is not on `origin`.

Then open a pull request on [typst/packages](https://github.com/typst/packages). The package README is `typst/README.md`; it must use absolute image URLs, since `assets/` is not part of the package.

`.github/workflows/docs.yml` builds the plugin, the figures and the site on every push and pull request, and deploys to GitHub Pages from `main`.
