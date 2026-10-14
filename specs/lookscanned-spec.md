# lookscanned — Spécification fonctionnelle

> Package Typst + plugin WASM (Rust) pour donner à un document l'aspect d'un scan, d'une photocopie, d'un fax ou d'une page tapée à la machine.

---

## 1. Objectifs

Modifier l'aspect visuel d'un document Typst pour lui donner un rendu « scanné » :

- **Grain et taches** sur la feuille (couleur choisie par l'utilisateur)
- **Lettres qui bavent** et lisibilité plus ou moins dégradée (paramétrable)
- **Aspect scanné** : légères rotations, irrégularités, effet « machine à écrire »

### Contraintes de conception

- Package **publiable sur Typst Universe**
- Package Typst **+ plugin WASM Rust** (pas d'outil externe, pas de CLI)
- Le texte reste **sélectionnable** autant que possible
- Rendu **déterministe** : une même seed produit toujours le même résultat
- Les effets ne doivent pas **modifier la mise en page** (pas de changement de retours à la ligne)

---

## 2. Architecture fonctionnelle

### Partage des rôles

| Rôle | Où |
|---|---|
| Génération de textures (grain, papier, taches, poussière, rayures, ombres, vignettage) | **Rust/WASM** → PNG |
| Génération des paramètres aléatoires (rotation par page, jitter, variation d'encrage) | **Rust/WASM** → données seedées |
| Application des effets : `rotate`, `move`, `scale`, `text(fill, stroke)`, `place`, `page(background/foreground)`, show rules | **Typst** |
| Presets, API utilisateur, validation des arguments | **Typst** |

Le plugin sert de « générateur de matière et de hasard cohérent », Typst applique.

### Techniques pour la bavure et la lisibilité

Sans rasterisation du document, on utilise des approximations combinées :

- **Ghosting** : 2 à 4 copies du texte avec décalages sous-pixel et opacités faibles
- **Stroke fin** de la couleur du texte (`text(stroke: 0.2pt + color)`) pour épaissir les lettres
- **Overlay de texture « mange-encre »** : PNG à alpha généré par le plugin (toner irrégulier, ruban usé)
- **Variation de couleur d'encre** par ligne/mot (noir → gris foncé → gris)

### Points d'attention techniques

1. **Poids du PDF** : résolution et compression réglables, textures tuilées réutilisées entre pages
2. **Performance** : le jitter par caractère peut ralentir la compilation, granularité réglable
3. **Déterminisme** : tout dérive de la seed (pas d'aléa non seedé)
4. **Mise en page** : le jitter utilise des `box` de taille fixe + `move`/`rotate` sans affecter le flux
5. **Taille du `.wasm`** : `opt-level = "z"`, LTO, `wasm-opt`, dépendances minimales
6. **Limite connue** : pas de vraie perspective (Typst ne la supporte pas), pas de vrai flou gaussien

---

## 3. API publique

| Élément | Rôle |
|---|---|
| `lookscanned(..)` | Show rule globale (point d'entrée principal) |
| `lookscanned.page(..)[..]` | Surcharge pour une page |
| `lookscanned.region(..)[..]` | Effet sur un bloc précis |
| `lookscanned.stamp(..)` | Tampon |
| `lookscanned.scribble(..)` | Annotation manuscrite approximative |
| `lookscanned.stain(..)` | Tache positionnée manuellement |
| `lookscanned.texture(..)` | Génère une texture brute (paper, grain, dust, stains…) |
| `lookscanned.presets` | Dictionnaire des presets, consultable et extensible |

---

## 4. Exemples d'utilisation

### 4.1 Usage minimal : un preset

```typst
#import "@preview/lookscanned:0.1.0": lookscanned

#show: lookscanned.with(preset: "office-scan")

= Contrat de location

Entre les soussignés, il a été convenu ce qui suit...
```

### 4.2 Presets disponibles

| Preset | Rendu |
|---|---|
| `"clean-scan"` | Scan propre : très légère rotation, peu de grain, fond blanc cassé |
| `"office-scan"` | Scan de bureau standard : grain modéré, ombres de bord, légère dérive |
| `"photocopy"` | Photocopie : contraste fort, bandes, poussière, bavure marquée |
| `"fax"` | Fax : lignes parasites, texte irrégulier, très dégradé |
| `"typewriter"` | Machine à écrire : jitter par caractère, encrage inégal, ruban usé |
| `"old-paper"` | Papier ancien : jaunissement, taches, bords abîmés |
| `"phone-scan"` | Photo de téléphone : skew léger, ombres inégales (pas de vraie perspective) |

### 4.3 Réglage par intensité

```typst
#show: lookscanned.with(
  preset: "office-scan",
  intensity: 0.7,   // 0 = aucun effet, 1 = preset par défaut, >1 = exagéré
  seed: 42,         // même seed = même rendu
)
```

`intensity` est un multiplicateur global pour itérer vite sans toucher aux réglages fins.

### 4.4 Réglage fin par thème

Chaque thème est un dictionnaire. Tout ce qui est omis hérite du preset.

```typst
#show: lookscanned.with(
  preset: "office-scan",
  seed: 7,

  paper: (
    color: rgb("#f4efe4"),
    grain: 0.4,          // 0 à 1
    aging: 0.2,          // jaunissement / vieillissement
  ),

  stains: (
    color: rgb("#8b5a2b"),   // couleur choisie par l'utilisateur
    amount: 0.3,             // densité de taches
    size: (min: 2mm, max: 15mm),
    dust: 0.5,
  ),

  ink: (
    bleed: 0.4,          // bavure des lettres
    fade: 0.2,           // encrage inégal
    legibility: 0.8,     // 1 = net, 0 = quasi illisible
  ),

  skew: (
    page-rotation: 0.6deg,   // rotation max par page (tirée aléatoirement)
    line-jitter: 0.15deg,    // irrégularité par ligne
    char-jitter: 0pt,        // décalage par caractère (0 = désactivé)
    drift: 0.3,              // dérive d'une page à l'autre
  ),

  edges: (
    shadow: 0.5,         // ombre de bord de scan
    vignette: 0.3,
    binding: false,      // ombre de reliure
    punch-holes: false,  // trous de classeur
  ),
)
```

### 4.5 Variations par page

Chaque page a ses propres défauts (dérivés de la seed). Pour surcharger une page précise :

```typst
#show: lookscanned.with(preset: "photocopy")

Page 1, rendu normal.

#pagebreak()

#lookscanned.page(stains: (amount: 0.8), skew: (page-rotation: 2deg))[
  Cette page est particulièrement abîmée.
]
```

### 4.6 Effet sur une partie du document

```typst
= Rapport officiel

Ce texte reste propre.

#lookscanned.region(preset: "fax")[
  Cette annexe a l'air d'avoir été reçue par fax.
]

Retour au texte propre.
```

`region` applique les effets de texte (jitter, bavure) au contenu, avec un fond/cadre si c'est un bloc.

### 4.7 Éléments décoratifs

```typst
#lookscanned.stamp("REÇU", color: rgb("#c0392b"), angle: -12deg)
#lookscanned.scribble(color: blue)   // annotation manuscrite approximative
#lookscanned.stain(at: (x: 60%, y: 20%), color: rgb("#6b4423"), size: 25mm)
```

### 4.8 Qualité et poids

```typst
#show: lookscanned.with(
  preset: "office-scan",
  quality: (
    resolution: 150,     // dpi des textures générées
    tile: true,          // réutilise des textures tuilées entre pages
    granularity: "line", // "page", "line", "word" ou "char" pour le jitter
  ),
)
```

### 4.9 Accès direct aux textures (usage avancé)

```typst
#set page(background: lookscanned.texture("paper", seed: 3, color: rgb("#f0e6d2")))
#set page(foreground: lookscanned.texture("dust", seed: 3, amount: 0.4))
```

---

## 5. Décisions et points ouverts

### Validés
- Package Typst + plugin WASM, publiable sur Universe, pas d'outil externe
- Syntaxe générale (show rule + dictionnaires thématiques + presets)
- Paramètres en anglais (convention Universe)

### À trancher
1. **Presets personnalisés** : permettre `lookscanned.preset("mon-style", ..)` pour en définir et les réutiliser ?
2. **`scribble` et `stamp`** : utiles pour la v0.1, ou reportés en v0.2 ? (le manuscrit approximatif est difficile à rendre crédible sans police dédiée)
3. **`phone-scan`** : garder avec la limite « skew léger uniquement, pas de vraie perspective », ou retirer ?
4. **Défaut sans preset** : `#show: lookscanned` applique `"office-scan"` implicitement, ou preset explicite obligatoire ?
5. **Nommage de `skew`** : ambigu avec la transformation Typst du même nom. Alternatives : `geometry`, `alignment`
6. **Granularité par défaut** : `"line"` pour tous les presets, `"char"` réservé à `typewriter`

---

## 6. Périmètre par version

| Version | Contenu |
|---|---|
| **v0.1** | Rotation par page, jitter lignes/mots, fond papier, grain, taches (plugin), presets, seed, intensité |
| **v0.2** | Ombres de bord, poussière, rayures, ruban usé, variation d'encrage, `stamp`, `scribble` |
| **v1.0** | Polish, performance, presets additionnels, documentation complète, exemples |

---

## 7. Notes

- **Accessibilité** : le texte reste sélectionnable et cherchable dans la plupart des modes. À mentionner dans la documentation : un document « scanné » est moins lisible, notamment pour les technologies d'assistance.
- **Usage** : le package a des usages légitimes (design, mise en scène, fiction, jeux, tests d'OCR). Mentionner sobrement dans la documentation que l'effet ne doit pas servir à falsifier des documents.
- **Compilation du `.wasm`** : Universe ne compile pas le Rust, le binaire doit être commité dans le package. Prévoir un script de build reproductible et une CI qui le vérifie.
