import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/dev_flags.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../navigation/nav_item.dart';
import 'app_header.dart';

/// Coquille de navigation adaptative, utilisee comme builder de la
/// [ShellRoute] qui enveloppe toutes les routes authentifiees.
///
/// < [breakpoint] (mobile/tablette etroite) -> NavigationBar en bas.
/// >= [breakpoint] (web/desktop/tablette large) -> NavigationRail a gauche
///   (a droite automatiquement en RTL, Row etant sensible a la Directionality
///   ambiante).
///
/// Les items dependent du role connecte (voir lib/shared/navigation/nav_item.dart).
class AdaptiveScaffold extends ConsumerWidget {
  const AdaptiveScaffold({required this.currentLocation, required this.child, super.key});

  final String currentLocation;
  final Widget child;

  /// Repere Material 3 pour la bascule compact/etendu (le breakpoint "medium"
  /// standard M3 est 600dp, mais on le repousse a 840dp ici : en dessous, une
  /// sidebar meme reduite laisse trop peu de place au contenu sur tablette
  /// portrait, la bottom nav reste plus confortable jusqu'a ~840dp).
  static const double breakpoint = 840;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final role = effectiveRole(ref.watch(authControllerProvider).user?.role);

    // Le guard de app_router.dart empeche normalement d'atteindre une route
    // de la shell sans utilisateur authentifie ; filet de securite minimal.
    if (role == null) return child;

    final items = navItemsForRole(l10n, role);
    final selectedIndex = _selectedIndex(items, currentLocation);
    final isWide = MediaQuery.sizeOf(context).width >= breakpoint;

    if (isWide) {
      return _WideLayout(items: items, selectedIndex: selectedIndex, body: child);
    }
    return _CompactLayout(items: items, selectedIndex: selectedIndex, body: child);
  }

  int _selectedIndex(List<NavItem> items, String location) {
    var bestIndex = 0;
    var bestMatchLength = -1;
    for (var i = 0; i < items.length; i++) {
      final route = items[i].route;
      final matches = location == route || location.startsWith('$route/');
      if (matches && route.length > bestMatchLength) {
        bestIndex = i;
        bestMatchLength = route.length;
      }
    }
    return bestIndex;
  }
}

class _CompactLayout extends StatelessWidget {
  const _CompactLayout({required this.items, required this.selectedIndex, required this.body});

  final List<NavItem> items;
  final int selectedIndex;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => context.go(items[index].route),
        destinations: [
          for (final item in items)
            NavigationDestination(icon: Icon(item.icon), selectedIcon: Icon(item.selectedIcon), label: item.label),
        ],
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.items, required this.selectedIndex, required this.body});

  final List<NavItem> items;
  final int selectedIndex;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return Scaffold(
      // La Row respecte la Directionality ambiante : la sidebar (premier
      // enfant, cote "start") passe automatiquement a droite en RTL.
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            minExtendedWidth: 240,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_rounded, color: colors.primary),
                  const SizedBox(width: 10),
                  Text(l10n.appTitle, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => context.go(items[index].route),
            destinations: [
              for (final item in items)
                NavigationRailDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: Text(item.label),
                ),
            ],
          ),
          VerticalDivider(width: 1, color: colors.border),
          Expanded(
            child: Column(
              children: [const AppHeader(showBranding: false), Expanded(child: body)],
            ),
          ),
        ],
      ),
    );
  }
}
