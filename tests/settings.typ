// Custom preset dictionary, intensity, every granularity, page without height.
#import "/typst/lib.typ" as lookscanned

#let mine = lookscanned.presets.fax + (ink: (bleed: 0.2, ghosting: true))
#assert("office-scan" in lookscanned.presets)

#set page(width: 10cm, height: auto)
#show: lookscanned.scan.with(preset: mine, intensity: 1.5, seed: 9, quality: (granularity: "char", tile: false))

= Titre
#lorem(25)

$ x^2 + y^2 = z^2 $

#for g in ("page", "line", "word", "char") {
  lookscanned.region(preset: "typewriter", quality: (granularity: g))[#g : #lorem(8)]
}
