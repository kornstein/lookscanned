# Changelog

All notable changes to lookscanned are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project follows
[Semantic Versioning](https://semver.org/spec/v2.0.0.html). Changes that alter the rendering of an existing document
for a given `seed` are flagged **(render)**.

## [0.2.0] - 2026-11-15

### Added

- Presets `mimeograph`, `microfilm` and `newsprint`.
- `derive(preset, ..themes)`: a preset with some keys changed.
- `none` resets a theme or a key to its neutral values.
- Paper damage in `edges`: `folds`, `dog-ear`, `staple`, `paperclip` and `torn`.
- `highlighter` decoration.
- `stain(over: true)`: the stain is painted above the text.
- Texture kinds `damage` and `marker`.
- **(render)** Strokes of `line`, `rect` and `table` are inked.

### Changed

- Faster PDF compilation (approx. 28%).

### Fixed

- **(render)** `stamp` showed white specks on coloured paper.
- **(render)** `intensity: 0` left on/off effects enabled (`binding`, `punch-holes`, `ghosting`).

## [0.1.0] - 2026-10-26

First version v0.1.0.

### Added

- `scan` show rule, with `preset`, `intensity`, `seed` and seven themes: `paper`, `stains`, `ink`, `skew`, `edges`,
  `scanner` and `quality` (28 settings).
- Seven presets: `clean-scan`, `office-scan` (default), `photocopy`, `fax`, `typewriter`, `old-paper` and
  `phone-scan`, exposed as `presets`.
- `page` to override page-level effects for the pages spanned by its body, and `region` to apply text effects to a
  single block.
- Decorations: `stamp`, `scribble` and `stain`.
- `texture` to use the generated images directly. Kinds: `paper`, `grain`, `toner`, `ink`, `stains`, `dust`, `lines`
  and `edges`.
- Textured ink (bleed, fade, wear, legibility, optional ghosting) that keeps text selectable, applied to equations as
  well.
- Page rotation emulated block by block, without reflow; `"page"`, `"line"`, `"word"` and `"char"` granularities.
- Argument validation with explicit error messages.
- Rust plugin compiled to WebAssembly (`wasm-minimal-protocol`, `minicbor`, `miniz_oxide`).
- Test suite including a layout invariance check for every preset, and documentation site.

[0.2.0]: https://github.com/kornstein/lookscanned/releases/tag/v0.2.0
[0.1.0]: https://github.com/kornstein/lookscanned/releases/tag/v0.1.0
