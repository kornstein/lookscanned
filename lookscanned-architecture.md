# lookscanned — Architecture du projet

Package Typst (publiable sur Typst Universe) mêlant Typst et Rust compilé en WASM, pour donner à un PDF un aspect « scanné ».

Le dépôt de développement est séparé du dossier publié : Universe n'accepte qu'un contenu minimal, et le Rust n'y a sa place que sous forme de `.wasm`.

## 1. Structure du dépôt (développement)

```
lookscanned/
├── Cargo.toml                 # crate cdylib → wasm32-unknown-unknown
├── Cargo.lock                 # commité (build reproductible)
├── justfile                   # build, test, package, publish
├── README.md                  # README GitHub (dev)
├── LICENSE
├── .github/workflows/ci.yml   # build wasm + tests + compile des exemples
│
├── src/                       # Rust
│   ├── lib.rs                 # points d'entrée #[wasm_func]
│   ├── rng.rs                 # PRNG seedé (déterminisme)
│   ├── params.rs              # structs de paramètres + (dé)sérialisation
│   ├── texture/
│   │   ├── mod.rs
│   │   ├── paper.rs           # fond papier, fibres
│   │   ├── grain.rs           # bruit / grain
│   │   ├── stains.rs          # taches (couleur choisie)
│   │   └── dust.rs            # poussière, rayures (v0.2)
│   ├── jitter.rs              # rotations / décalages seedés
│   └── encode.rs              # sortie PNG
│
├── typst/                     # sources Typst
│   ├── lib.typ                # API publique (reexports)
│   ├── presets.typ            # office-scan, fax, typewriter...
│   ├── effects/
│   │   ├── ghosting.typ
│   │   ├── jitter.typ
│   │   └── page.typ           # fond/avant-plan de page
│   ├── wasm.typ               # wrapper : charge le plugin, encode/décode
│   └── validate.typ           # validation des arguments
│
├── tests/                     # tests Typst (compilation de .typ de référence)
├── examples/                  # exemples .typ + rendus PNG (pour le README)
├── docs/                      # manuel (optionnel, tidy ou .typ)
└── dist/                      # généré par `just package`, jamais commité
```

## 2. Sortie de `just package` (`dist/`)

Universe attend `packages/preview/lookscanned/<version>/` dans un fork de `typst/packages`. Contenu minimal :

```
dist/lookscanned/0.1.0/
├── typst.toml          # métadonnées (name, version, entrypoint, exclude…)
├── lib.typ             # copié depuis typst/ (arborescence conservée)
├── presets.typ …
├── lookscanned.wasm    # compilé et optimisé (wasm-opt)
├── README.md           # README orienté utilisateur Typst
├── LICENSE
└── thumbnail.png       # optionnel mais recommandé
```

Le contenu de `typst/` est copié tel quel à la racine du package (pas de sous-dossier `typst/` dans `dist`). Le chargement du plugin dans `wasm.typ` se fait par `plugin("lookscanned.wasm")`, chemin relatif au fichier appelant : à garder en tête lors des déplacements de fichiers.

## 3. Tâches du justfile

| Recette | Rôle |
|---|---|
| `just build` | `cargo build --release --target wasm32-unknown-unknown` |
| `just opt` | `wasm-opt -Oz` + (éventuellement) `wasm-strip` |
| `just test` | `cargo test` + compilation des `tests/*.typ` |
| `just examples` | compile `examples/*.typ` en PNG |
| `just package` | build + opt + assemble `dist/` + génère `typst.toml` |
| `just check` | `typst compile` sur `dist/` pour valider le paquet final |
| `just install-local` | copie `dist/` dans `~/.local/share/typst/packages/local/lookscanned/<version>/` pour tester via `@local/lookscanned:<version>` |
| `just publish` | copie `dist/lookscanned/<ver>/` dans un clone de `typst/packages` (chemin configurable) |

## 4. Points à décider

1. **Source de vérité de la version** : `Cargo.toml`, avec `just package` générant `typst.toml` depuis un `typst.toml.in` (une seule version à maintenir).
2. **Crate wasm** : regarder `wasm-minimal-protocol` (standard des plugins Typst). Données passées en octets, donc format de sérialisation simple pour `params.rs` (CBOR ou JSON minimal).
3. **Taille du `.wasm`** : à surveiller dès le début (Universe est tatillon). Éviter les grosses dépendances d'image ; le crate `png` seul, ou un encodeur maison, suffit pour du bruit.
4. **`tests/` et `examples/`** : hors de `dist/` (via `exclude` de `typst.toml` ou en ne les copiant pas). Les exemples du README publié importent `@preview/lookscanned:<version>`, ceux de dev importent en local.
5. **Import local pendant le dev** : `just install-local` (voir ci-dessus).

## 5. Prochaines étapes

- Définir l'ordre de développement (premier rendu rapide).
- Squelette du `justfile` et du `Cargo.toml`.
