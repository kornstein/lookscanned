# /// script
# requires-python = ">=3.9"
# dependencies = ["pymupdf"]
# ///

import sys
import pymupdf

if len(sys.argv) != 4:
    sys.exit("usage: pdf2png.py in.pdf out.png dpi")
src, out, dpi = sys.argv[1], sys.argv[2], int(sys.argv[3])
pymupdf.open(src)[0].get_pixmap(dpi=dpi, alpha=True).save(out)
