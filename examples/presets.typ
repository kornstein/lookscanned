#import "../typst/lib.typ" as lookscanned

#show: lookscanned.scan.with(preset: "photocopy", seed: 9, intensity: 0.8, edges: (punch-holes: true))

= Contrat de location

#lorem(80)

#lorem(80)

#lookscanned.stamp("Reçu", at: (x: 60%, y: 70%))


