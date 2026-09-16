import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../models/user_role.dart';

/// Dashboard provisoire par role : valide le flux d'authentification et le
/// guard de navigation. Sera remplace par le vrai dashboard a partir de
/// l'etape 6.
class RoleDashboardPlaceholder extends ConsumerWidget {
  const RoleDashboardPlaceholder({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Connecté en tant que ${user?.fullName ?? '-'} (${user?.role.label ?? '-'})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(user?.email ?? '-'),
            if (user?.role == UserRole.admin) ...[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/admin/users'),
                child: const Text('Gérer les utilisateurs'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
