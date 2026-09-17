import 'package:flutter/material.dart';

import '../../../../../core/theme/subject_colors.dart';

/// Associe le `code` matiere renvoye par l'API au [SubjectId] du design
/// system (Etape 4) et a une icone. Les 7 matieres seedees (Etape 5)
/// couvrent exactement les 7 [SubjectId] existants ; `null`/l'icone de
/// repli protegent contre un code futur non encore mappe cote design system.
SubjectId? subjectIdFromApiCode(String code) => switch (code) {
  'MATH' => SubjectId.math,
  'ARABIC' => SubjectId.arabic,
  'FRENCH' => SubjectId.french,
  'SCIENCE' => SubjectId.science,
  'TECHNOLOGY' => SubjectId.technology,
  'ART' => SubjectId.art,
  'PHYSICAL_EDUCATION' => SubjectId.physicalEducation,
  _ => null,
};

IconData subjectIconFromApiCode(String code) => switch (code) {
  'MATH' => Icons.calculate_outlined,
  'ARABIC' => Icons.menu_book_outlined,
  'FRENCH' => Icons.translate_outlined,
  'SCIENCE' => Icons.science_outlined,
  'TECHNOLOGY' => Icons.computer_outlined,
  'ART' => Icons.palette_outlined,
  'PHYSICAL_EDUCATION' => Icons.sports_soccer_outlined,
  _ => Icons.menu_book_outlined,
};
