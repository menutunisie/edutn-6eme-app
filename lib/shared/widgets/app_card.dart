import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/subject_colors.dart';

/// Carte generique du design system : fond neutre, bordure legere, radius
/// genereux, ombre tres discrete. Base de toutes les cartes de contenu
/// (matiere, lecon, ressource...) — voir lib/core/theme/README.md.
class AppCard extends StatelessWidget {
  const AppCard({required this.child, this.onTap, this.padding, super.key});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: colors.textPrimary.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Carte "matiere" : icone coloree dans un cercle (fond leger de la
/// matiere), titre, sous-titre optionnel et badge couleur matiere. La carte
/// elle-meme reste sur fond neutre (jamais rempli de la couleur vive de la
/// matiere) — regle explicite du design system.
class SubjectCard extends StatelessWidget {
  const SubjectCard({
    required this.subjectId,
    required this.title,
    required this.icon,
    this.subtitle,
    this.onTap,
    super.key,
  });

  final SubjectId subjectId;
  final String title;
  final IconData icon;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subjectColor = subjectId.color;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: subjectColor.lightBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: subjectColor.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: colors.textPrimary),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: colors.textTertiary),
                  ),
                ],
              ],
            ),
          ),
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsetsDirectional.only(start: 8),
            decoration: BoxDecoration(color: subjectColor.accent, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
