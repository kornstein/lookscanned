# Version source of truth: Cargo.toml. typst.toml is generated from typst/typst.toml.in.
version := `sed -n 's/^version = "\(.*\)"/\1/p' Cargo.toml | head -1`
wasm := "target/wasm32-unknown-unknown/release/lookscanned.wasm"
dist := "dist/lookscanned/" + version
typst_packages := env("TYPST_PACKAGES", "../typst-packages")
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
      wasm-opt -Oz --strip-debug typst/lookscanned.wasm -o typst/lookscanned.wasm
    else
      echo "wasm-opt not found, skipping"
    fi
    ls -l typst/lookscanned.wasm

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
      text() { typst compile --root . --input preset="$1" tests/layout.typ "$out/l.pdf" && pdftotext "$out/l.pdf" - | sed 's/(.*)//' | grep -v '^$'; }
      ref=$(text none)
      for p in clean-scan office-scan photocopy fax typewriter old-paper phone-scan; do
        [ "$ref" = "$(text $p)" ] || { echo "layout or text changed with preset $p"; exit 1; }
      done
      echo "layout: ok"
    fi

# Render examples to PNG (for the README).
examples: build
    for p in clean-scan office-scan photocopy fax typewriter old-paper phone-scan; do typst compile --root . --input preset=$p tests/layout.typ examples/$p.png --ppi 80; done
    typst compile --root . examples/features.typ "examples/features-{p}.png" --ppi 80
    typst compile --root . --input preset=office-scan tests/layout.typ examples/thumbnail.png --ppi 150

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
    [ -f examples/thumbnail.png ] && cp examples/thumbnail.png {{dist}}/ || true
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

docs_figures := "hero preset-clean-scan preset-office-scan preset-photocopy preset-fax preset-typewriter preset-old-paper preset-phone-scan tutorial-1 tutorial-2 tutorial-3 tutorial-4 ink-bleed ink-fade ink-wear ink-legibility paper-aging textures page-override region decorations"

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
      gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=png16m -r288 -dDownScaleFactor=2 \
        -sOutputFile="$out" "$tmp/$f.pdf"
    done
    echo "docs images: ok"

# Preview the documentation at http://localhost:8000.
docs-serve: docs-images
    uv run --with-requirements requirements-docs.txt zensical serve

# Build the documentation site into site/ (strict: broken links fail).
docs-build: docs-images
    uv run --with-requirements requirements-docs.txt zensical build --clean --strict
