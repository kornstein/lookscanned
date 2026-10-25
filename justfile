# Version source of truth: Cargo.toml. typst.toml is generated from typst/typst.toml.in.
version := `sed -n 's/^version = "\(.*\)"/\1/p' Cargo.toml | head -1`
wasm := "target/wasm32-unknown-unknown/release/lookscanned.wasm"
dist := "dist/lookscanned/" + version
typst_packages := env("TYPST_PACKAGES", "../typst-packages")
presets := "clean-scan office-scan photocopy fax typewriter old-paper phone-scan"
local_packages := env("TYPST_PACKAGE_PATH", if os() == "macos" { home_directory() / "Library/Application Support/typst/packages" } else { home_directory() / ".local/share/typst/packages" })

default: package

toolchain:
    rustup target add wasm32-unknown-unknown

# Compile the plugin and copy it next to typst/wasm.typ for dev imports.
build:
    cargo build --release --target wasm32-unknown-unknown
    cp {{wasm}} typst/lookscanned.wasm

# Shrink the plugin (skipped when wasm-opt is not installed).
opt: build
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v wasm-opt > /dev/null; then
      # Features rustc enables by default for wasm32-unknown-unknown.
      wasm-opt -Oz --strip-debug --enable-bulk-memory --enable-nontrapping-float-to-int \
        --enable-sign-ext --enable-mutable-globals typst/lookscanned.wasm -o typst/lookscanned.wasm
    else
      echo "wasm-opt not found, skipping"
    fi
    ls -l typst/lookscanned.wasm

# Formatting and clippy, warnings as errors.
lint:
    cargo fmt --check
    cargo clippy --all-targets -- -D warnings

# Rust unit tests, every test compiles, and effects keep the text and line breaks.
test: build
    #!/usr/bin/env bash
    set -euo pipefail
    cargo test
    out=$(mktemp -d)
    for f in tests/*.typ examples/*.typ; do
      echo "compile $f"
      typst compile --root . "$f" "$out/$(basename "$f" .typ).pdf"
    done
    if command -v pdftotext > /dev/null; then
      text() { typst compile --root . --input preset="$1" tests/layout.typ "$out/l.pdf" && pdftotext -raw "$out/l.pdf" - | sed 's/(.*)//' | grep -v '^$'; }
      ref=$(text none)
      for p in {{presets}}; do
        [ "$ref" = "$(text $p)" ] || { echo "layout or text changed with preset $p"; exit 1; }
      done
      echo "layout: ok"
    else
      echo "pdftotext not found, skipping layout check"
    fi

# Render the README images into assets/ (committed), through PDF like docs-images.
readme-images: build
    #!/usr/bin/env bash
    set -euo pipefail
    out=target/readme
    mkdir -p "$out" assets
    png() { gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=png16m -r"$1" -dDownScaleFactor=2 -dMaxBitmap=2000000000 -sOutputFile="$3" "$2"; }
    gallery() { typst compile --root . --input pages="$2" --input columns="$3" ${4:+--input labels="$4"} examples/docs/gallery.typ "$out/$1.pdf"; }
    typst compile --root . examples/old-textbook.typ "$out/old-textbook.pdf"
    typst compile --root . examples/problem-sheet.typ "$out/problem-sheet.pdf"
    presets=""
    for p in {{presets}}; do
      typst compile --root . --input fig=preset-$p examples/docs/figures.typ "$out/preset-$p.pdf"
      presets="$presets,$out/preset-$p.pdf:1"
    done
    gallery hero "$out/old-textbook.pdf:2,$out/old-textbook.pdf:3,$out/problem-sheet.pdf:1" 3
    gallery presets "${presets#,}" 4 "$(echo {{presets}} | tr ' ' ,)"
    png 200 "$out/hero.pdf" assets/hero.png
    png 120 "$out/presets.pdf" assets/presets.png
    echo "readme images: ok"

# Assemble the Universe package in dist/.
package: opt
    #!/usr/bin/env bash
    set -euo pipefail
    rm -rf {{dist}}
    mkdir -p {{dist}}
    (cd typst && find . -name '*.typ' -o -name '*.wasm' | cpio -pdm --quiet ../{{dist}})
    sed 's/@VERSION@/{{version}}/' typst/typst.toml.in > {{dist}}/typst.toml
    cp typst/README.md {{dist}}/README.md
    cp LICENSE {{dist}}/
    echo "packaged {{dist}}"

# Compile a document against the packaged files.
check: package
    #!/usr/bin/env bash
    set -euo pipefail
    tmp=$(mktemp -d)
    mkdir -p "$tmp/packages/local/lookscanned"
    cp -r {{dist}} "$tmp/packages/local/lookscanned/"
    printf '#import "@local/lookscanned:{{version}}"\n#show: lookscanned.scan.with(preset: "fax")\n#lorem(50)\n' > "$tmp/check.typ"
    typst compile --package-path "$tmp/packages" "$tmp/check.typ"
    echo "check: ok"

# Make @local/lookscanned:<version> available to Typst.
install-local: package
    mkdir -p "{{local_packages}}/local/lookscanned"
    rm -rf "{{local_packages}}/local/lookscanned/{{version}}"
    cp -r {{dist}} "{{local_packages}}/local/lookscanned/"

# Copy the package into a clone of typst/packages (TYPST_PACKAGES).
publish: check
    test -d "{{typst_packages}}/packages/preview" || { echo "{{typst_packages}} is not a typst/packages clone"; exit 1; }
    mkdir -p "{{typst_packages}}/packages/preview/lookscanned"
    cp -r {{dist}} "{{typst_packages}}/packages/preview/lookscanned/"

docs_figures := "hero preset-clean-scan preset-office-scan preset-photocopy preset-fax preset-typewriter preset-old-paper preset-phone-scan start-1 start-2 start-3 start-4 ink-bleed ink-fade ink-wear ink-legibility paper-aging textures page-override region decorations"

# Render the figures of the web documentation into docs/assets/img/ (not committed).
# Through PDF + Ghostscript: Typst's PNG export panics on text filled with
# image tilings (typst 0.15.1), which the textured ink uses. Rendered at twice
# the size then halved: below ~1 px, Ghostscript widens strokes (ink bleed).
docs-images: build
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p docs/assets/img
    tmp=$(mktemp -d)
    for f in {{docs_figures}}; do
      typst compile --root . --input fig=$f examples/docs/figures.typ "$tmp/$f.pdf"
      out="docs/assets/img/$f.png"
      [ "$f" = page-override ] && out="docs/assets/img/$f-%d.png"
      gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=png16m -r288 -dDownScaleFactor=2 -dMaxBitmap=2000000000 \
        -sOutputFile="$out" "$tmp/$f.pdf"
    done
    echo "docs images: ok"

# Preview the documentation at http://localhost:8000.
docs-serve: docs-images
    uv run --with-requirements requirements-docs.txt zensical serve

# Build the documentation site into site/ (strict: broken links fail).
docs-build: docs-images
    uv run --with-requirements requirements-docs.txt zensical build --clean --strict
