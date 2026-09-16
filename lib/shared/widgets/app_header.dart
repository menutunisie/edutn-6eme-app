import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/l10n/locale_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

/// Header commun (mobile en tant qu'AppBar, web/desktop au-dessus du
/// contenu) : logo + nom de l'app a gauche (en LTR — passe a droite
/// automatiquement en RTL via Row), actions a droite (langue, theme,
/// deconnexion).
class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  /// [showBranding] : masque le logo/nom quand la sidebar (layout large) les
  /// affiche deja, pour eviter la redondance visuelle.
  const AppHeader({this.showBranding = true, super.key});

  final bool showBranding;

  static const double height = 64;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final locale = ref.watch(localeControllerProvider);
    final themeMode = ref.watch(themeControllerProvider);

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: colors.surface, border: Border(bottom: BorderSide(color: colors.border))),
      child: Row(
        children: [
          if (showBranding) ...[
            Icon(Icons.school_rounded, color: colors.primary),
            const SizedBox(width: 10),
            Text(l10n.appTitle, style: Theme.of(context).textTheme.titleMedium),
          ],
          const Spacer(),
          PopupMenuButton<Locale>(
            tooltip: l10n.languageTooltip,
            icon: Icon(Icons.language, color: colors.textSecondary),
            initialValue: locale,
            onSelected: (value) => ref.read(localeControllerProvider.notifier).setLocale(value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: Locale('ar'), child: Text('العربية')),
              PopupMenuItem(value: Locale('fr'), child: Text('Français')),
            ],
          ),
          IconButton(
            tooltip: l10n.themeTooltip,
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: colors.textSecondary,
            ),
            onPressed: () => ref.read(themeControllerProvider.notifier).toggle(),
          ),
          IconButton(
            tooltip: l10n.logoutTooltip,
            icon: Icon(Icons.logout, color: colors.textSecondary),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}
