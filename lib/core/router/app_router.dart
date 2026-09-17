import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/content/presentation/screens/admin_content_screen.dart';
import '../../features/admin/users/presentation/screens/admin_users_screen.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../shared/models/user_role.dart';
import '../../shared/widgets/adaptive_scaffold.dart';
import '../../shared/widgets/forbidden_screen.dart';
import '../../shared/widgets/role_dashboard_placeholder.dart';

/// Routing avec authentification, garde par role et coquille de navigation
/// adaptative (Etape 4).
///
/// - non authentifie -> redirige vers /login (sauf pendant le bootstrap : /)
/// - authentifie sur /login ou / -> redirige vers le dashboard de son role
/// - route /admin/** reservee au role ADMIN, /teacher/** a TEACHER,
///   /student/** a STUDENT (sinon redirection vers /forbidden)
/// - /login, /forbidden et / restent hors de la ShellRoute (pas de nav/header)
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier<int>(0);
  ref.listen(authControllerProvider, (_, _) => refreshNotifier.value++);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final isSplash = location == '/';
      final isLoginPage = location == '/login';

      if (authState.status == AuthStatus.unknown) {
        return isSplash ? null : '/';
      }

      if (!authState.isAuthenticated) {
        return isLoginPage ? null : '/login';
      }

      if (isSplash || isLoginPage) {
        return _homeRouteForRole(authState.user!.role);
      }

      final requiredRole = _requiredRoleForPath(location);
      if (requiredRole != null && authState.user!.role != requiredRole) {
        return '/forbidden';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/forbidden', builder: (context, state) => const ForbiddenScreen()),
      ShellRoute(
        builder: (context, state, child) {
          return AdaptiveScaffold(currentLocation: state.uri.toString(), child: child);
        },
        routes: [
          GoRoute(path: '/student', builder: (context, state) => const RoleDashboardPlaceholder()),
          GoRoute(path: '/teacher', builder: (context, state) => const RoleDashboardPlaceholder()),
          GoRoute(
            path: '/admin',
            builder: (context, state) => const RoleDashboardPlaceholder(),
            routes: [
              GoRoute(path: 'users', builder: (context, state) => const AdminUsersScreen()),
              GoRoute(path: 'content', builder: (context, state) => const AdminContentScreen()),
            ],
          ),
        ],
      ),
    ],
  );
});

String _homeRouteForRole(UserRole role) => switch (role) {
  UserRole.student => '/student',
  UserRole.teacher => '/teacher',
  UserRole.admin => '/admin',
};

UserRole? _requiredRoleForPath(String path) {
  if (path.startsWith('/admin')) return UserRole.admin;
  if (path.startsWith('/teacher')) return UserRole.teacher;
  if (path.startsWith('/student')) return UserRole.student;
  return null;
}
