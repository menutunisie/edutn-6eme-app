import 'package:flutter/material.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../models/user_role.dart';

/// Item de navigation (sidebar web/desktop ou bottom nav mobile), commun aux
/// deux layouts de [AdaptiveScaffold].
class NavItem {
  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
}

/// Items de navigation par role. Volontairement minimal pour l'instant (un
/// seul dashboard placeholder + gestion des utilisateurs pour l'admin) :
/// aucune destination fictive n'est ajoutee tant que l'ecran reel n'existe
/// pas (voir etapes suivantes pour les matieres/cours/favoris...).
List<NavItem> navItemsForRole(AppLocalizations l10n, UserRole role) {
  final dashboardRoute = switch (role) {
    UserRole.student => '/student',
    UserRole.teacher => '/teacher',
    UserRole.admin => '/admin',
  };

  return [
    NavItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: l10n.navDashboard,
      route: dashboardRoute,
    ),
    if (role == UserRole.admin)
      NavItem(
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        label: l10n.navUsers,
        route: '/admin/users',
      ),
  ];
}
