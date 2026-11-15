# Version comes from Cargo.toml.
version := `sed -n 's/^version = "\(.*\)"/\1/p' Cargo.toml | head -1`
wasm := "target/wasm32-unknown-unknown/release/lookscanned.wasm"
dist := "dist/lookscanned/" + version
typst_packages := env("TYPST_PACKAGES", "../typst-packages")
zensical := "zensical==0.0.70"
presets := "clean-scan office-scan photocopy fax typewriter old-paper phone-scan mimeograph microfilm newsprint"
local_packages := env("TYPST_PACKAGE_PATH", if os() == "macos" { home_directory() / "Library/Application Support/typst/packages" } else { home_directory() / ".local/share/typst/packages" })

default: package

# Install the wasm target.
toolchain:
    rustup target add wasm32-unknown-unknown

# Build the plugin.
build:
    cargo build --release --target wasm32-unknown-unknown
    cp {{wasm}} typst/lookscanned.wasm

# Optimise the plugin.
opt: build
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v wasm-opt > /dev/null; then
      wasm-opt -Os --strip-debug --enable-bulk-memory --enable-nontrapping-float-to-int \
        --enable-sign-ext --enable-mutable-globals typst/lookscanned.wasm -o typst/lookscanned.wasm
    else
      echo "wasm-opt not found, skipping"
    fi
    ls -l typst/lookscanned.wasm

# Lint Rust code.
lint:
    cargo fmt --check
    cargo clippy --all-targets -- -D warnings

# Run all tests.
test: build
    #!/usr/bin/env bash
    set -euo pipefail
    cargo test
    out=$(mktemp -d)
    cases=$(typst eval --root . 'query(<cases>).first().value.join(" ")' --in tests/run.typ | tr -d '"')
    for c in $cases; do
      echo "case $c"
      for i in 1 2; do typst compile --root . --creation-timestamp 0 --input case="$c" tests/run.typ "$out/$c-$i.pdf"; done
      cmp -s "$out/$c-1.pdf" "$out/$c-2.pdf" || { echo "case $c is not deterministic"; exit 1; }
    done
    for f in examples/*.typ; do
      echo "compile $f"
      typst compile --root . "$f" "$out/$(basename "$f" .typ).pdf"
    done
    if command -v pdftotext > /dev/null; then
      text() { typst compile --root . --input case=layout --input preset="$1" tests/run.typ "$out/l.pdf" && pdftotext -raw "$out/l.pdf" - | sed 's/(.*)//' | grep -v '^$'; }
      ref=$(text none)
      for p in {{presets}}; do
        [ "$ref" = "$(text $p)" ] || { echo "layout or text changed with preset $p"; exit 1; }
      done
      echo "layout: ok"
    else
      echo "pdftotext not found, skipping layout check"
    fi

# Render README images.
readme-images: build
    #!/usr/bin/env bash
    set -euo pipefail
    out=target/readme
    mkdir -p "$out"
    # Ghostscript, or MuPDF; poppler draws textured ink as plain ink.
    png() {
      if command -v gs > /dev/null; then
        gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pngalpha -r"$1" -dDownScaleFactor=2 -dMaxBitmap=2000000000 -sOutputFile="$3" "$2"
      elif command -v uv > /dev/null; then
        uv run -q examples/docs/pdf2png.py "$2" "$3" "$(( $1 / 2 ))"
      else
        python3 examples/docs/pdf2png.py "$2" "$3" "$(( $1 / 2 ))"
      fi
    }
    fig() { typst compile --root . --input fig="$1" --input dir="$out" examples/docs/readme.typ "$out/$1.pdf"; }
    for e in {{presets}}; do typst compile --root . examples/$e.typ "$out/$e.pdf"; done
    for f in hero presets details; do fig $f; done
    png 340 "$out/hero.pdf" assets/hero.png
    png 280 "$out/presets.pdf" assets/presets.png
    png 400 "$out/details.pdf" assets/details.png
    echo "readme images: ok"

# Build the Universe package.
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

# Test the packaged files.
check: package
    #!/usr/bin/env bash
    set -euo pipefail
    tmp=$(mktemp -d)
    mkdir -p "$tmp/packages/local/lookscanned"
    cp -r {{dist}} "$tmp/packages/local/lookscanned/"
    printf '#import "@local/lookscanned:{{version}}"\n#show: lookscanned.scan.with(preset: "fax")\n#lorem(50)\n' > "$tmp/check.typ"
    typst compile --package-path "$tmp/packages" "$tmp/check.typ"
    echo "check: ok"

# Install as @local package.
install-local: package
    mkdir -p "{{local_packages}}/local/lookscanned"
    rm -rf "{{local_packages}}/local/lookscanned/{{version}}"
    cp -r {{dist}} "{{local_packages}}/local/lookscanned/"

# Copy into typst/packages.
publish: check
    grep -q '^## \[{{version}}\] - ' CHANGELOG.md || { echo "CHANGELOG.md has no [{{version}}] section"; exit 1; }
    git ls-remote --exit-code --tags origin "v{{version}}" > /dev/null || { echo "tag v{{version}} is not on origin"; exit 1; }
    perl -pi -e 's#/lookscanned/main/#/lookscanned/v{{version}}/#g' {{dist}}/README.md
    test -d "{{typst_packages}}/packages/preview" || { echo "{{typst_packages}} is not a typst/packages clone"; exit 1; }
    mkdir -p "{{typst_packages}}/packages/preview/lookscanned"
    cp -r {{dist}} "{{typst_packages}}/packages/preview/lookscanned/"

docs_figures := "hero preset-clean-scan preset-office-scan preset-photocopy preset-fax preset-typewriter preset-old-paper preset-phone-scan preset-mimeograph preset-microfilm preset-newsprint start-1 start-2 start-3 start-4 ink-bleed ink-fade ink-wear ink-legibility paper-aging textures page-override region decorations damage highlighter strokes"

# Render doc figures.
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

# Preview the docs.
docs-serve: docs-images
    uvx --from {{zensical}} zensical serve

# Build the docs site.
docs-build: docs-images
    uvx --from {{zensical}} zensical build --clean --strict
