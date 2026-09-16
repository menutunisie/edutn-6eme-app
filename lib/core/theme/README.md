# Design system — EduTN 6ème

Ce dossier centralise tous les tokens visuels de l'application. **Aucun widget ne
doit contenir de `Color(0x...)` en dur** : toujours passer par
`Theme.of(context).extension<AppColors>()!` (ou son raccourci `context.colors`)
pour les tokens de marque/neutres, et par `SubjectId.color` (dans
`subject_colors.dart`) pour les couleurs de matière.

## Fichiers

| Fichier | Contenu |
|---|---|
| `app_colors.dart` | `AppColors` (`ThemeExtension`) : palette complète, variantes clair/sombre |
| `subject_colors.dart` | `SubjectId` (enum) → couleur d'accent + fond léger par matière |
| `app_theme.dart` | `ThemeData.light` / `ThemeData.dark` : `ColorScheme`, boutons, champs, navigation... |
| `theme_controller.dart` | Toggle clair/sombre persisté (`shared_preferences`) |
| `README.md` | ce fichier |

Voir aussi `lib/core/l10n/locale_controller.dart` (langue par défaut : arabe,
persistée) et les widgets `lib/shared/widgets/app_button.dart`,
`app_card.dart`, `app_badge.dart`, `app_header.dart`,
`adaptive_scaffold.dart`.

## Palette

Les couleurs de **marque** (primary, orange, green, purple, cyan, red,
actionOrange, et leurs variantes hover/light/dark) sont **identiques en clair
et en sombre** — seuls les **neutres** (background/surface/border/text...) et
les **accents de navigation active** (`navActiveIcon`/`navActiveText`/
`navActiveBackground`) changent entre les deux modes, conformément à la
spécification.

`navActiveIcon` sert aussi de couleur de bordure de focus pour les champs de
formulaire (#2563EB en clair, #60A5FA en sombre) : ce sont les mêmes teintes
que la spec attribue au focus des inputs et à l'icône active de la nav.

## Règles d'usage des couleurs

- **Bleu (`primary`)** : boutons principaux, liens, éléments actifs, navigation
  sélectionnée, actions principales.
- **Orange (`orange`)** : CTA secondaires, nouveautés, récompenses, éléments
  dynamiques.
- **Vert (`green`)** : progrès, réussites, réponses correctes, tâches
  terminées, validations.
- **Rouge (`red`)** : **uniquement** erreurs, réponses incorrectes,
  suppressions, alertes critiques, champs invalides. Ne jamais l'utiliser pour
  autre chose.
- **Violet (`purple`)** : créativité, contenu arabe, activités interactives.
- **Cyan (`cyan`)** : informations, contenu scientifique, découverte.
- **Orange action (`actionOrange`)** : distinct de `orange`, réservé aux
  actions ponctuelles fortes (à définir au cas par cas — ex. futur bouton
  "démarrer un exercice").
- Ne jamais cumuler toutes les couleurs sur un même écran sans nécessité :
  une couleur dominante + un accent éventuel + neutres pour le reste.
- Jamais d'information transmise uniquement par la couleur : toujours un
  texte/icône/label en plus (voir `AppBadge`, qui porte toujours un libellé).

## Couleurs par matière (`subject_colors.dart`)

Couleur d'accent (badges, icônes, bordures — **jamais en fond plein écran**)
+ fond léger associé, pour : Mathématiques, Arabe, Français, Éveil
scientifique, Informatique/technologie, Éducation artistique, Éducation
physique. **Décision à valider** : seules ces 7 matières ont une couleur
assignée ici ; les 4 autres matières listées à l'étape 1 (Éducation
islamique, Histoire, Géographie, Éducation civique) n'ont pas encore de
couleur définie.

## Composants

- **Boutons** (`shared/widgets/app_button.dart`) : `AppButton` avec
  `AppButtonVariant.{primary,secondary,outline,success,danger}`. `primary`/
  `outline` s'appuient aussi sur les thèmes globaux (`ElevatedButton`/
  `OutlinedButton`), donc un `ElevatedButton` ou `OutlinedButton` "nu" utilisé
  ailleurs dans l'app hérite automatiquement du bon style.
  **Important (contraste)** : `success`/`danger` utilisent `greenDark`/
  `redHover` en fond, pas `green`/`red` — texte blanc sur `green` (#10B981)
  ou `red` (#EF4444) tombe respectivement à 2.5:1 et 3.8:1, sous le seuil
  WCAG AA (4.5:1) ; `greenDark`/`redHover` passent à 5.5:1/4.8:1. Même
  logique à appliquer si un futur bouton plein orange/actionOrange à texte
  blanc est ajouté (`orange`/`actionOrange` échouent aussi, `orangeDark`/
  `actionOrangeDark` sont à privilégier).
- **Cartes** (`app_card.dart`) : `AppCard` (fond neutre, bordure, radius 20,
  ombre discrète) et `SubjectCard` (icône dans un cercle coloré léger +
  pastille couleur matière — jamais de fond plein coloré).
- **Badges** (`app_badge.dart`) : `AppBadge` avec `AppBadgeVariant.{info,
  success,warning,error,purple}`, toujours avec un texte (+ icône optionnelle).
- **Formulaires** : `InputDecorationTheme` global dans `app_theme.dart` — bordure
  focus épaissie (le "ring" CSS n'a pas d'équivalent natif Flutter), erreurs en
  rouge avec message texte (jamais la couleur seule).
- **Navigation** : `AdaptiveScaffold` (`shared/widgets/adaptive_scaffold.dart`)
  — voir section dédiée ci-dessous.

## Navigation adaptative

`AdaptiveScaffold` bascule à **840px** de largeur (au-delà du breakpoint M3
"medium" standard de 600dp : en dessous de 840px, une sidebar même réduite
laisse trop peu de place au contenu sur tablette portrait) :

- `< 840px` → `NavigationBar` (Material 3, bottom nav) + `AppHeader` en
  `AppBar`.
- `>= 840px` → `NavigationRail` étendu (logo en haut, items en dessous) +
  `AppHeader` (sans logo, pour éviter la redondance avec la sidebar)
  au-dessus du contenu.

Les items sont définis par rôle dans `shared/navigation/nav_item.dart`
(actuellement minimal : un seul item "Tableau de bord" pour chaque rôle, plus
"Utilisateurs" pour l'admin — aucun item fictif n'a été ajouté pour des
écrans qui n'existent pas encore).

## RTL et langue

- Langue par défaut : **arabe** (`ar`), persistée après le premier choix via
  `LocaleController`. Bascule possible vers le français depuis le sélecteur
  de langue du header.
- Le `Directionality` (RTL/LTR) est géré automatiquement par Flutter à partir
  de la locale active — aucun code RTL spécifique n'a été nécessaire : `Row`
  (utilisé par la sidebar, les headers, les cartes...) inverse déjà l'ordre
  visuel de ses enfants selon la `Directionality` ambiante.
- Police : **Cairo** (via `google_fonts`) pour l'ensemble de l'app — bonne
  lisibilité en arabe et en latin, évite un changement de police visible au
  changement de langue.

  > **TODO (avant mise en production)** : Cairo est actuellement téléchargée
  > à la volée au premier lancement (comportement par défaut de
  > `google_fonts`, voir `AppTheme._buildTheme` dans `app_theme.dart`). Cela
  > introduit une dépendance réseau au tout premier rendu de texte. À
  > remplacer par la police bundlée en asset local (télécharger les fichiers
  > `.ttf` Cairo, les référencer dans `pubspec.yaml` sous `flutter: fonts:`,
  > puis utiliser `TextTheme(fontFamily: 'Cairo')` à la place de
  > `GoogleFonts.cairoTextTheme(...)`). Voir aussi le TODO correspondant dans
  > `pubspec.yaml` à côté de la dépendance `google_fonts`.

## Accessibilité — vérification des contrastes

Ratios calculés (formule WCAG relative luminance) pour les combinaisons
clés :

| Combinaison | Ratio | Seuil |
|---|---|---|
| `textPrimary` / `background` (clair & sombre) | 17.1:1 | ✅ AA texte normal (≥4.5) |
| `textSecondary` / `surface` (clair & sombre) | 7.6:1 / 9.9:1 | ✅ AA texte normal |
| `textTertiary` / `surface` (clair & sombre) | 4.8:1 / 5.7:1 | ✅ AA texte normal |
| `textDisabled` / `surface` | 2.6:1 / 3.1:1 | Exempté (WCAG 1.4.3 : composants/texte désactivés hors périmètre) |
| Badges (texte foncé / fond clair, les 5 variantes) | 4.5:1 à 6.0:1 | ✅ AA texte normal |
| Bouton primaire (blanc / `primary`) | 5.2:1 | ✅ AA texte normal |
| Bouton succès (blanc / `greenDark`) | 5.5:1 | ✅ AA texte normal |
| Bouton danger (blanc / `redHover`) | 4.8:1 | ✅ AA texte normal |
| Icône active nav sombre / fond actif sombre | 4.1:1 | ✅ AA non-texte (≥3, seuil applicable aux icônes/composants UI) |

Aucune combinaison texte utilisée dans l'app ne tombe sous le seuil AA
applicable. `textDisabled` est la seule exception, explicitement permise par
WCAG pour le texte de champs/éléments désactivés.

## Mode sombre

Toggle clair/sombre dans le header (`AppHeader`), persisté via
`ThemeController` (`shared_preferences`). Volontairement limité à deux états
(`light`/`dark`, pas de mode "système") pour rester simple et prévisible.
