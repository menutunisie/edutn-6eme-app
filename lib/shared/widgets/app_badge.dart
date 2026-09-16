import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Variantes de badge du design system. Chaque badge porte toujours un
/// libelle textuel (jamais une simple pastille de couleur) pour rester
/// accessible aux personnes daltoniennes.
enum AppBadgeVariant { info, success, warning, error, purple }

class AppBadge extends StatelessWidget {
  const AppBadge({required this.label, this.variant = AppBadgeVariant.info, this.icon, super.key});

  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (variant) {
      AppBadgeVariant.info => (colors.primaryLight, colors.primaryHover),
      AppBadgeVariant.success => (colors.greenLight, colors.greenDark),
      AppBadgeVariant.warning => (colors.orangeLight, colors.orangeDark),
      AppBadgeVariant.error => (colors.redLight, colors.redDark),
      AppBadgeVariant.purple => (colors.purpleLight, colors.purpleDark),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(color: foreground, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
