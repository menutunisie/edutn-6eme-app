// Flags de developpement temporaires — aucun ne doit survivre jusqu'a une
// demo externe ou une mise en production. Voir le TODO en tete de
// lib/main.dart, qui rappelle de les repasser a false avant tout partage.

/// ⚠️ TEMPORAIRE — remettre à false avant toute démo/prod.
///
/// Contourne l'ecran de connexion (login_screen) pour les tests visuels
/// pendant le remplissage de contenu et le travail de design : au
/// demarrage, AuthController effectue un VRAI login contre le backend avec
/// [kDevBypassEmail]/[kDevBypassPassword] (voir
/// AuthController._bootstrapDevBypass) puis l'app demarre directement sur
/// "Gestion de contenu" une fois ce login reussi — access/refresh token
/// reels, stockes via le meme TokenStorage que le flux manuel. Aucune
/// simulation d'etat : si le backend est indisponible ou les identifiants
/// incorrects, l'echec est affiche explicitement (voir SplashScreen), pas
/// masque.
///
/// Le vrai flux de connexion (login_screen, AuthController.login) reste
/// intact et fonctionne normalement des que ce flag repasse a false.
const bool kBypassAuthForDev = true; // ⚠️ TEMPORAIRE — remettre à false avant toute démo/prod

/// ⚠️ TEMPORAIRE — identifiants admin par defaut utilises uniquement par le
/// bootstrap dev ci-dessus (doivent correspondre a ADMIN_DEFAULT_EMAIL /
/// ADMIN_DEFAULT_PASSWORD du backend). A retirer avec kBypassAuthForDev.
const String kDevBypassEmail = 'admin@edutn6.tn';
const String kDevBypassPassword = 'AdminDemo123!';
