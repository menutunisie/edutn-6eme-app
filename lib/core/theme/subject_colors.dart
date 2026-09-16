import 'package:flutter/material.dart';

/// Identifiant de matiere, utilise uniquement pour l'association couleur/
/// icone (badges, cartes, barres de progression). Ne porte aucune donnee
/// pedagogique : le contenu reel (Subject cote API) sera branche a partir
/// des etapes suivantes.
enum SubjectId { math, arabic, french, science, technology, art, physicalEducation }

/// Couleur d'accent d'une matiere + son fond leger associe. A utiliser pour
/// des badges, icones ou bordures — jamais en fond plein ecran (voir
/// lib/core/theme/README.md).
@immutable
class SubjectColor {
  const SubjectColor({required this.accent, required this.lightBackground});

  final Color accent;
  final Color lightBackground;
}

const Map<SubjectId, SubjectColor> subjectColors = {
  SubjectId.math: SubjectColor(accent: Color(0xFF2563EB), lightBackground: Color(0xFFEFF6FF)),
  SubjectId.arabic: SubjectColor(accent: Color(0xFF8B5CF6), lightBackground: Color(0xFFF5F3FF)),
  SubjectId.french: SubjectColor(accent: Color(0xFF06B6D4), lightBackground: Color(0xFFECFEFF)),
  SubjectId.science: SubjectColor(accent: Color(0xFF10B981), lightBackground: Color(0xFFECFDF5)),
  SubjectId.technology: SubjectColor(accent: Color(0xFFF59E0B), lightBackground: Color(0xFFFFFBEB)),
  // "Violet doux" distinct du violet Arabe : teinte plus claire, meme famille.
  SubjectId.art: SubjectColor(accent: Color(0xFFA78BFA), lightBackground: Color(0xFFEDE9FE)),
  SubjectId.physicalEducation: SubjectColor(
    accent: Color(0xFFF97316),
    lightBackground: Color(0xFFFFF7ED),
  ),
};

extension SubjectColorLookup on SubjectId {
  SubjectColor get color => subjectColors[this]!;
}
