# EduTN 6eme — App Flutter

Application unique (Flutter) pour la plateforme educative de la sixieme annee de
l'enseignement de base en Tunisie — mobile (Android/iOS), web et desktop
(Windows/macOS/Linux), meme code source pour tous les form factors.

**Etape actuelle : Etape 3 — authentification et roles.** Ecran de connexion, gestion
des tokens (JWT + refresh token avec rotation), garde de navigation par role, et un
ecran minimal de gestion des utilisateurs (ADMIN). Aucun autre contenu pedagogique
n'est encore implemente : les dashboards eleve/enseignant/admin sont des placeholders.

## Stack

- Flutter (canal stable) — mobile, web, desktop, meme codebase
- State management : Riverpod (`flutter_riverpod`)
- Navigation : `go_router` (redirection + garde de role)
- Client HTTP : `dio`, avec intercepteur JWT + refresh automatique
- Stockage securise des tokens : `flutter_secure_storage`
- Internationalisation : `flutter_localizations` + fichiers ARB (`lib/l10n`),
  RTL automatique pour l'arabe

## Structure (feature-first)

```
lib/
  core/
    auth/        # AuthTokens, TokenStorage (stockage securise, cross-feature)
    config/      # Env.apiBaseUrl (configurable via --dart-define)
    network/     # dioProvider + AuthInterceptor (JWT, refresh automatique)
    router/      # go_router : redirection auth + garde de role
    theme/       # theme Material 3 (clair/sombre)
    l10n/generated/  # genere automatiquement par `flutter gen-l10n` (non versionne)
  features/
    auth/
      data/          # AuthRepository (login/refresh/logout/getCurrentUser)
      presentation/  # AuthController (Riverpod), LoginScreen, SplashScreen
    admin/users/
      data/          # AdminUserRepository (liste + creation d'utilisateurs)
      presentation/  # AdminUsersScreen (liste + formulaire de creation)
  l10n/          # fichiers sources ARB (app_fr.arb, app_ar.arb)
  shared/
    widgets/     # RoleDashboardPlaceholder, ForbiddenScreen
    models/      # UserRole (partage entre features)
    providers/   # vide pour l'instant
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

Le backend doit tourner (voir README du repo `edutn-6eme-backend`) et avoir au moins
un compte ADMIN seede. Par defaut, l'app pointe vers `http://localhost:8000` :

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

## Tester le flux de connexion en local

1. Demarrer le backend (voir son README) — un compte ADMIN est seede automatiquement.
2. Lancer l'app (`flutter run -d chrome` par exemple).
3. Se connecter avec `ADMIN_DEFAULT_EMAIL` / `ADMIN_DEFAULT_PASSWORD` -> redirection
   vers l'espace administrateur.
4. Depuis l'espace administrateur, ouvrir "Gérer les utilisateurs" -> créer un élève
   ou un enseignant via le formulaire.
5. Se déconnecter, puis se reconnecter avec le compte nouvellement créé -> redirection
   vers le dashboard correspondant à son rôle (élève ou enseignant).
6. Tenter d'accéder à `/admin/users` avec ce compte non-admin (ex. en modifiant
   l'URL en mode web) -> écran "Accès refusé".

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
distribuee publiquement) : toute logique sensible reste cote API. Les tokens JWT
sont stockes via `flutter_secure_storage` (Keychain/Keystore natif), jamais en clair.
