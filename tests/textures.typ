// Every texture kind, with and without the page as reference size.
#import "/typst/lib.typ" as lookscanned

#set page(width: 12cm, height: 8cm, margin: 0pt)
#set page(background: lookscanned.texture("paper", seed: 3, color: rgb("#f0e6d2"), grain: 0.5, aging: 0.6))
#set page(foreground: lookscanned.texture("dust", seed: 3, amount: 0.4, scratches: 0.5))

#grid(
  columns: 4,
  ..("grain", "toner", "stains", "edges").map(k => lookscanned.texture(
    k, width: 3cm, height: 3cm, amount: 1, shadow: 1, color: red, min: 5mm, max: 12mm,
  )),
  lookscanned.texture("lines", width: 3cm, height: 3cm, amount: 1, axis: "h"),
  lookscanned.texture("lines", width: 3cm, height: 3cm, amount: 1, axis: "v"),
)
