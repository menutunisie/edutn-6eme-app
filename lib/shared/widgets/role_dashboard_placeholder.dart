import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../models/user_role.dart';
import 'app_button.dart';
import 'app_card.dart';

/// Contenu (pas de Scaffold propre : rendu a l'interieur de l'AdaptiveScaffold
/// via la ShellRoute) provisoire par role — valide le flux d'authentification
/// et la navigation adaptative. Sera remplace par le vrai dashboard a partir
/// de l'etape 6.
class RoleDashboardPlaceholder extends ConsumerWidget {
  const RoleDashboardPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final user = ref.watch(authControllerProvider).user;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.dashboard_customize_outlined, size: 40, color: colors.primary),
                const SizedBox(height: 16),
                Text(
                  l10n.connectedAs(user?.fullName ?? '-', roleLabel(l10n, user?.role ?? UserRole.student)),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '-',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (user?.role == UserRole.admin) ...[
                  const SizedBox(height: 20),
                  AppButton(
                    label: l10n.manageUsersButton,
                    icon: Icons.people_outline,
                    onPressed: () => context.go('/admin/users'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
