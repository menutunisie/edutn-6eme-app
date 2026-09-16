# EduTN 6eme — App Flutter

Application unique (Flutter) pour la plateforme educative de la sixieme annee de
l'enseignement de base en Tunisie — mobile (Android/iOS), web et desktop
(Windows/macOS/Linux), meme code source pour tous les form factors.

**Etape actuelle : Etape 2 — fondations techniques.** Aucun ecran fonctionnel,
aucune authentification et aucun contenu ne sont encore implementes : l'app
demarre sur une page provisoire ("squelette technique") qui valide que
Riverpod, go_router, le theme et l'internationalisation FR/AR fonctionnent.

## Stack

- Flutter (canal stable) — mobile, web, desktop, meme codebase
- State management : Riverpod (`flutter_riverpod`)
- Navigation : `go_router`
- Client HTTP : `dio`
- Internationalisation : `flutter_localizations` + fichiers ARB (`lib/l10n`),
  RTL automatique pour l'arabe

## Structure (feature-first)

```
lib/
  core/
    config/    # Env.apiBaseUrl (configurable via --dart-define)
    network/   # client dio partage
    router/    # squelette go_router (une seule route provisoire)
    theme/     # theme Material 3 (clair/sombre)
    l10n/generated/  # genere automatiquement par `flutter gen-l10n` (non versionne)
  features/    # vide — une sous-dossier par fonctionnalite a partir de l'etape 3+
  l10n/        # fichiers sources ARB (app_fr.arb, app_ar.arb)
  shared/
    widgets/   # widgets reutilisables (vide pour l'instant)
    models/    # DTOs miroir des schemas backend (vide pour l'instant)
    providers/ # providers Riverpod partages (vide pour l'instant)
  main.dart
  app.dart
```

## Installation locale

Prerequis : Flutter SDK (canal stable), plateformes desktop/web activees
(`flutter config --enable-windows-desktop --enable-macos-desktop
--enable-linux-desktop` si besoin — deja actif par defaut sur les versions
recentes).

```bash
flutter pub get
```

Les fichiers de localisation (`lib/core/l10n/generated/`) sont regeneres
automatiquement a chaque `flutter pub get` / `flutter run` / `flutter build`
grace a `generate: true` dans `pubspec.yaml`.

## Lancement

Par defaut, l'app pointe vers `http://localhost:8000` (API backend locale).
Pour cibler une autre URL :

```bash
flutter run --dart-define=API_BASE_URL=https://api.edutn6.example.com
```

**Mobile** (emulateur ou appareil connecte) :

```bash
flutter run -d <device_id>      # flutter devices pour lister les cibles
```

**Web** :

```bash
flutter run -d chrome
# ou pour un build de production :
flutter build web
```

**Desktop** :

```bash
flutter run -d windows   # ou macos / linux selon la plateforme de dev
```

## Tests

```bash
flutter analyze
flutter test
```

## Variables d'environnement / configuration

| Variable (`--dart-define`) | Description | Valeur par defaut |
|---|---|---|
| `API_BASE_URL` | URL de base de l'API backend EduTN 6eme | `http://localhost:8000` |

Aucune cle secrete ne doit etre embarquee dans le client Flutter (l'app est
distribuee publiquement) : toute logique sensible reste cote API.
