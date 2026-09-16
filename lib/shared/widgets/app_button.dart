import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Variantes de bouton du design system (voir lib/core/theme/README.md).
///
/// [primary]/[outline] passent par les themes globaux (ElevatedButton /
/// OutlinedButton, configures dans app_theme.dart) ; [secondary]/[success]/
/// [danger] sont des variantes custom sans equivalent Material par defaut.
enum AppButtonVariant { primary, secondary, outline, success, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onPressedEffective = isLoading ? null : onPressed;

    final child = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: _loaderColor(colors)),
          )
        : icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(label)],
          );

    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton(onPressed: onPressedEffective, child: child),
      AppButtonVariant.outline => OutlinedButton(onPressed: onPressedEffective, child: child),
      AppButtonVariant.secondary => ElevatedButton(
        onPressed: onPressedEffective,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? colors.surfaceTertiary
                : states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)
                ? colors.primaryLight
                : colors.primarySoft,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.disabled) ? colors.textDisabled : colors.primaryHover,
          ),
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        child: child,
      ),
      AppButtonVariant.success => ElevatedButton(
        onPressed: onPressedEffective,
        style: ButtonStyle(
          // greenDark (et non green) : texte blanc sur #10B981 tombe a 2.5:1,
          // sous le seuil WCAG AA (4.5:1) — greenDark passe a 5.5:1. Le
          // feedback hover/pressed passe par overlayColor plutot que par un
          // changement de teinte, pour ne jamais repasser sous le seuil.
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.disabled) ? colors.surfaceTertiary : colors.greenDark,
          ),
          overlayColor: WidgetStatePropertyAll(Colors.black.withValues(alpha: 0.08)),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled) ? colors.textDisabled : Colors.white,
          ),
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        child: child,
      ),
      AppButtonVariant.danger => ElevatedButton(
        onPressed: onPressedEffective,
        style: ButtonStyle(
          // redHover (et non red) : texte blanc sur #EF4444 tombe a 3.76:1,
          // sous le seuil WCAG AA (4.5:1) — redHover passe a 4.83:1.
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.disabled) ? colors.surfaceTertiary : colors.redHover,
          ),
          overlayColor: WidgetStatePropertyAll(Colors.black.withValues(alpha: 0.08)),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled) ? colors.textDisabled : Colors.white,
          ),
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        child: child,
      ),
    };
  }

  Color _loaderColor(AppColors colors) => switch (variant) {
    AppButtonVariant.secondary => colors.primaryHover,
    AppButtonVariant.outline => colors.textSecondary,
    _ => Colors.white,
  };
}
