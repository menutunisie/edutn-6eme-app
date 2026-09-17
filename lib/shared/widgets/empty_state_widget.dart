import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Etat "liste vide" generique (aucun element a afficher, mais pas une
/// erreur). Toujours un message texte + icone, jamais une zone vide muette.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({required this.message, this.icon = Icons.inbox_outlined, super.key});

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: colors.textTertiary),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
