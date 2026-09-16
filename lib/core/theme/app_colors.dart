import 'package:flutter/material.dart';

/// Design tokens centralises d'EduTN 6ème (voir lib/core/theme/README.md
/// pour les regles d'usage). Aucune couleur ne doit etre codee en dur dans
/// un widget : toujours passer par `Theme.of(context).extension<AppColors>()!`
/// ou par les roles standards de [ColorScheme] configures dans app_theme.dart.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    // Bleu principal (marque)
    required this.primary,
    required this.primaryHover,
    required this.primaryLight,
    required this.primarySoft,
    required this.primaryDark,
    // Orange energie (CTA secondaires, nouveautes, recompenses)
    required this.orange,
    required this.orangeHover,
    required this.orangeLight,
    required this.orangeDark,
    // Vert progression (reussite, validation)
    required this.green,
    required this.greenHover,
    required this.greenLight,
    required this.greenDark,
    // Violet creativite (contenu arabe, activites interactives)
    required this.purple,
    required this.purpleHover,
    required this.purpleLight,
    required this.purpleDark,
    // Cyan clarte (information, contenu scientifique)
    required this.cyan,
    required this.cyanHover,
    required this.cyanLight,
    required this.cyanDark,
    // Rouge evaluation (erreurs, suppressions, alertes UNIQUEMENT)
    required this.red,
    required this.redHover,
    required this.redLight,
    required this.redDark,
    // Orange action (boutons d'action distincts du orange energie)
    required this.actionOrange,
    required this.actionOrangeHover,
    required this.actionOrangeLight,
    required this.actionOrangeDark,
    // Neutres (different entre clair/sombre)
    required this.background,
    required this.surface,
    required this.surfaceSecondary,
    required this.surfaceTertiary,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    // Accents "actifs" (navigation selectionnee, focus des champs) :
    // memes roles semantiques mais valeurs eclaircies en mode sombre pour
    // rester lisibles sur fond fonce.
    required this.navActiveIcon,
    required this.navActiveText,
    required this.navActiveBackground,
  });

  final Color primary;
  final Color primaryHover;
  final Color primaryLight;
  final Color primarySoft;
  final Color primaryDark;

  final Color orange;
  final Color orangeHover;
  final Color orangeLight;
  final Color orangeDark;

  final Color green;
  final Color greenHover;
  final Color greenLight;
  final Color greenDark;

  final Color purple;
  final Color purpleHover;
  final Color purpleLight;
  final Color purpleDark;

  final Color cyan;
  final Color cyanHover;
  final Color cyanLight;
  final Color cyanDark;

  final Color red;
  final Color redHover;
  final Color redLight;
  final Color redDark;

  final Color actionOrange;
  final Color actionOrangeHover;
  final Color actionOrangeLight;
  final Color actionOrangeDark;

  final Color background;
  final Color surface;
  final Color surfaceSecondary;
  final Color surfaceTertiary;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;

  final Color navActiveIcon;
  final Color navActiveText;
  final Color navActiveBackground;

  static const AppColors light = AppColors(
    primary: Color(0xFF2563EB),
    primaryHover: Color(0xFF1D4ED8),
    primaryLight: Color(0xFFDBEAFE),
    primarySoft: Color(0xFFEFF6FF),
    primaryDark: Color(0xFF1E40AF),
    orange: Color(0xFFF59E0B),
    orangeHover: Color(0xFFD97706),
    orangeLight: Color(0xFFFEF3C7),
    orangeDark: Color(0xFFB45309),
    green: Color(0xFF10B981),
    greenHover: Color(0xFF059669),
    greenLight: Color(0xFFD1FAE5),
    greenDark: Color(0xFF047857),
    purple: Color(0xFF8B5CF6),
    purpleHover: Color(0xFF7C3AED),
    purpleLight: Color(0xFFEDE9FE),
    purpleDark: Color(0xFF6D28D9),
    cyan: Color(0xFF06B6D4),
    cyanHover: Color(0xFF0891B2),
    cyanLight: Color(0xFFCFFAFE),
    cyanDark: Color(0xFF0E7490),
    red: Color(0xFFEF4444),
    redHover: Color(0xFFDC2626),
    redLight: Color(0xFFFEE2E2),
    redDark: Color(0xFFB91C1C),
    actionOrange: Color(0xFFF97316),
    actionOrangeHover: Color(0xFFEA580C),
    actionOrangeLight: Color(0xFFFFEDD5),
    actionOrangeDark: Color(0xFFC2410C),
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    surfaceSecondary: Color(0xFFF1F5F9),
    surfaceTertiary: Color(0xFFE2E8F0),
    border: Color(0xFFE2E8F0),
    borderStrong: Color(0xFFCBD5E1),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textTertiary: Color(0xFF64748B),
    textDisabled: Color(0xFF94A3B8),
    navActiveIcon: Color(0xFF2563EB),
    navActiveText: Color(0xFF1D4ED8),
    navActiveBackground: Color(0xFFEFF6FF),
  );

  static const AppColors dark = AppColors(
    // Les couleurs de marque restent identiques entre clair/sombre : seuls
    // les neutres et les accents "actifs" changent (voir README).
    primary: Color(0xFF2563EB),
    primaryHover: Color(0xFF1D4ED8),
    primaryLight: Color(0xFFDBEAFE),
    primarySoft: Color(0xFFEFF6FF),
    primaryDark: Color(0xFF1E40AF),
    orange: Color(0xFFF59E0B),
    orangeHover: Color(0xFFD97706),
    orangeLight: Color(0xFFFEF3C7),
    orangeDark: Color(0xFFB45309),
    green: Color(0xFF10B981),
    greenHover: Color(0xFF059669),
    greenLight: Color(0xFFD1FAE5),
    greenDark: Color(0xFF047857),
    purple: Color(0xFF8B5CF6),
    purpleHover: Color(0xFF7C3AED),
    purpleLight: Color(0xFFEDE9FE),
    purpleDark: Color(0xFF6D28D9),
    cyan: Color(0xFF06B6D4),
    cyanHover: Color(0xFF0891B2),
    cyanLight: Color(0xFFCFFAFE),
    cyanDark: Color(0xFF0E7490),
    red: Color(0xFFEF4444),
    redHover: Color(0xFFDC2626),
    redLight: Color(0xFFFEE2E2),
    redDark: Color(0xFFB91C1C),
    actionOrange: Color(0xFFF97316),
    actionOrangeHover: Color(0xFFEA580C),
    actionOrangeLight: Color(0xFFFFEDD5),
    actionOrangeDark: Color(0xFFC2410C),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    surfaceSecondary: Color(0xFF334155),
    surfaceTertiary: Color(0xFF475569),
    border: Color(0xFF334155),
    borderStrong: Color(0xFF475569),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFFCBD5E1),
    textTertiary: Color(0xFF94A3B8),
    textDisabled: Color(0xFF64748B),
    navActiveIcon: Color(0xFF60A5FA),
    navActiveText: Color(0xFF93C5FD),
    navActiveBackground: Color(0xFF334155),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryHover,
    Color? primaryLight,
    Color? primarySoft,
    Color? primaryDark,
    Color? orange,
    Color? orangeHover,
    Color? orangeLight,
    Color? orangeDark,
    Color? green,
    Color? greenHover,
    Color? greenLight,
    Color? greenDark,
    Color? purple,
    Color? purpleHover,
    Color? purpleLight,
    Color? purpleDark,
    Color? cyan,
    Color? cyanHover,
    Color? cyanLight,
    Color? cyanDark,
    Color? red,
    Color? redHover,
    Color? redLight,
    Color? redDark,
    Color? actionOrange,
    Color? actionOrangeHover,
    Color? actionOrangeLight,
    Color? actionOrangeDark,
    Color? background,
    Color? surface,
    Color? surfaceSecondary,
    Color? surfaceTertiary,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? navActiveIcon,
    Color? navActiveText,
    Color? navActiveBackground,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryHover: primaryHover ?? this.primaryHover,
      primaryLight: primaryLight ?? this.primaryLight,
      primarySoft: primarySoft ?? this.primarySoft,
      primaryDark: primaryDark ?? this.primaryDark,
      orange: orange ?? this.orange,
      orangeHover: orangeHover ?? this.orangeHover,
      orangeLight: orangeLight ?? this.orangeLight,
      orangeDark: orangeDark ?? this.orangeDark,
      green: green ?? this.green,
      greenHover: greenHover ?? this.greenHover,
      greenLight: greenLight ?? this.greenLight,
      greenDark: greenDark ?? this.greenDark,
      purple: purple ?? this.purple,
      purpleHover: purpleHover ?? this.purpleHover,
      purpleLight: purpleLight ?? this.purpleLight,
      purpleDark: purpleDark ?? this.purpleDark,
      cyan: cyan ?? this.cyan,
      cyanHover: cyanHover ?? this.cyanHover,
      cyanLight: cyanLight ?? this.cyanLight,
      cyanDark: cyanDark ?? this.cyanDark,
      red: red ?? this.red,
      redHover: redHover ?? this.redHover,
      redLight: redLight ?? this.redLight,
      redDark: redDark ?? this.redDark,
      actionOrange: actionOrange ?? this.actionOrange,
      actionOrangeHover: actionOrangeHover ?? this.actionOrangeHover,
      actionOrangeLight: actionOrangeLight ?? this.actionOrangeLight,
      actionOrangeDark: actionOrangeDark ?? this.actionOrangeDark,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceTertiary: surfaceTertiary ?? this.surfaceTertiary,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      navActiveIcon: navActiveIcon ?? this.navActiveIcon,
      navActiveText: navActiveText ?? this.navActiveText,
      navActiveBackground: navActiveBackground ?? this.navActiveBackground,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      primary: l(primary, other.primary),
      primaryHover: l(primaryHover, other.primaryHover),
      primaryLight: l(primaryLight, other.primaryLight),
      primarySoft: l(primarySoft, other.primarySoft),
      primaryDark: l(primaryDark, other.primaryDark),
      orange: l(orange, other.orange),
      orangeHover: l(orangeHover, other.orangeHover),
      orangeLight: l(orangeLight, other.orangeLight),
      orangeDark: l(orangeDark, other.orangeDark),
      green: l(green, other.green),
      greenHover: l(greenHover, other.greenHover),
      greenLight: l(greenLight, other.greenLight),
      greenDark: l(greenDark, other.greenDark),
      purple: l(purple, other.purple),
      purpleHover: l(purpleHover, other.purpleHover),
      purpleLight: l(purpleLight, other.purpleLight),
      purpleDark: l(purpleDark, other.purpleDark),
      cyan: l(cyan, other.cyan),
      cyanHover: l(cyanHover, other.cyanHover),
      cyanLight: l(cyanLight, other.cyanLight),
      cyanDark: l(cyanDark, other.cyanDark),
      red: l(red, other.red),
      redHover: l(redHover, other.redHover),
      redLight: l(redLight, other.redLight),
      redDark: l(redDark, other.redDark),
      actionOrange: l(actionOrange, other.actionOrange),
      actionOrangeHover: l(actionOrangeHover, other.actionOrangeHover),
      actionOrangeLight: l(actionOrangeLight, other.actionOrangeLight),
      actionOrangeDark: l(actionOrangeDark, other.actionOrangeDark),
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceSecondary: l(surfaceSecondary, other.surfaceSecondary),
      surfaceTertiary: l(surfaceTertiary, other.surfaceTertiary),
      border: l(border, other.border),
      borderStrong: l(borderStrong, other.borderStrong),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      textDisabled: l(textDisabled, other.textDisabled),
      navActiveIcon: l(navActiveIcon, other.navActiveIcon),
      navActiveText: l(navActiveText, other.navActiveText),
      navActiveBackground: l(navActiveBackground, other.navActiveBackground),
    );
  }
}

/// Raccourci pour recuperer les tokens depuis un [BuildContext].
extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
