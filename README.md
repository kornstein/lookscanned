# lookscanned (development)

A Typst package and Rust/WASM plugin that make documents look scanned. User documentation: [`docs/`](docs/), published at <https://kornstein.github.io/lookscanned/> (package README: [`typst/README.md`](typst/README.md)). Design notes: [`specs/`](specs/).

```
src/      Rust plugin: seeded RNG, CBOR params, textures → PNG, random table
typst/    Typst sources, copied as is into the package
tests/    .typ files compiled by `just test`
examples/ example documents (PNG renders for the README)
```

## Requirements

Rust with `wasm32-unknown-unknown` (`just toolchain`), Typst ≥ 0.14, `just`. `wasm-opt` (binaryen) and `pdftotext` (poppler) are optional.

## Tasks

| Command | |
|---|---|
| `just build` | Build the plugin and copy it to `typst/lookscanned.wasm` |
| `just test` | `cargo test`, compile `tests/` and `examples/`, check that no preset changes text or line breaks |
| `just examples` | Render examples to PNG |
| `just package` | Assemble `dist/lookscanned/<version>/` |
| `just check` | Compile a document against `dist/` through `@local` |
| `just install-local` | Install as `@local/lookscanned:<version>` |
| `just publish` | Copy into a `typst/packages` clone (`TYPST_PACKAGES`, default `../typst-packages`) |
| `just docs-serve` | Render the figures and preview the documentation (Zensical) |
| `just docs-build` | Build the documentation site into `site/`, failing on broken links |

The version comes from `Cargo.toml`. `typst.toml` is generated from `typst/typst.toml.in`.

During development, documents import `typst/lib.typ` directly:

```typst
#import "/typst/lib.typ" as lookscanned
```

Typst runs plugins in an interpreter, so the cost per pixel matters. Smooth textures are rendered at a fraction of the resolution, and grain is tiled.
