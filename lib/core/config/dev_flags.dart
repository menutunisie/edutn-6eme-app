import '../../shared/models/user_role.dart';

/// Flags de developpement temporaires — aucun ne doit survivre jusqu'a une
/// demo externe ou une mise en production. Voir le TODO en tete de
/// lib/main.dart, qui rappelle de les repasser a false avant tout partage.

/// ⚠️ TEMPORAIRE — remettre à false avant toute démo/prod.
///
/// Contourne l'ecran de connexion (login_screen) pour les tests visuels
/// pendant le remplissage de contenu et le travail de design : l'app
/// demarre directement sur "Gestion de contenu" avec un role ADMIN simule.
///
/// Le contournement est purement cote navigation/etat local Flutter (voir
/// app_router.dart et effectiveRole ci-dessous) : AuthController,
/// AuthRepository et les appels API d'authentification restent intacts et
/// inutilises tant que ce flag est actif — le vrai flux de connexion
/// fonctionne toujours normalement si on navigue vers /login.
const bool kBypassAuthForDev = true; // ⚠️ TEMPORAIRE — remettre à false avant toute démo/prod

/// Role a utiliser pour adapter l'affichage (navigation par role, sections
/// visibles...). Les ecrans qui en ont besoin doivent passer par cette
/// fonction plutot que lire `authState.user?.role` directement, pour rester
/// coherents avec le bypass (role ADMIN simule) sans dupliquer la condition
/// `kBypassAuthForDev` partout.
UserRole? effectiveRole(UserRole? realRole) => kBypassAuthForDev ? UserRole.admin : realRole;
