## Summary

<!-- What this changes and why. Link the issue: Fixes #123 -->

## Type

- [ ] Bug fix
- [ ] New features
- [ ] Rust plugin
- [ ] Documentation
- [ ] Build, CI or packaging

## Render

<!-- Before/after screenshots for any visual change, with the preset and seed used. -->

## Checklist

- [ ] `just lint` passes (rustfmt, clippy without warnings)
- [ ] `just test` passes, including the layout invariance check (`pdftotext` installed)
- [ ] `just check` compiles against the packaged files
- [ ] Renders stay deterministic for a given `seed`, and existing seeds still give the same output (or the change is intended and explained above)
- [ ] New settings are validated in `typst/validate.typ`, have a neutral value in `typst/presets.typ` and are listed in `docs/reference/themes.md` (add the key to `_fixed` in `typst/validate.typ` if `intensity` must not scale it)
- [ ] New public functions or snippets are covered in `tests/` (`tests/docs-snippets.typ` for documentation examples)
- [ ] Documentation and `typst/README.md` are updated; new figures are added to `docs_figures` in the `justfile`
