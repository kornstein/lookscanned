// Lays out pages of compiled PDFs in a grid, for the images in assets/:
//
//   typst compile --root . --input pages=a.pdf:1,b.pdf:2 examples/docs/gallery.typ out.pdf
//
// Paths are relative to the project root. `labels` (same order) and `columns`
// are optional.
#let pages = sys.inputs.at("pages").split(",").map(p => {
  let (file, n) = p.split(":")
  image("/" + file, page: int(n), height: 12cm)
})
#let labels = sys.inputs.at("labels", default: none)
#let labels = if labels == none { pages.map(_ => none) } else { labels.split(",") }
#let columns = int(sys.inputs.at("columns", default: str(pages.len())))

#set page(width: auto, height: auto, margin: 8mm, fill: rgb("#e9e7e2"))
#set text(font: "DejaVu Sans Mono", size: 18pt, fill: luma(60))

#grid(
  columns: columns,
  gutter: 6mm,
  ..pages.zip(labels).map(((p, l)) => stack(spacing: 3mm, box(stroke: 0.3pt + luma(170), p), l)),
)
