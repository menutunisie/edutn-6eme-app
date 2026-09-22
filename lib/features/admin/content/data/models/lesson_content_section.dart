/// Miroir de `LessonContentSection` cote API (app/schemas/content.py). Une
/// phase pedagogique d'une Lesson (situation de depart, observation,
/// hypothese...). [phaseKey] est un identifiant technique stable, jamais le
/// libelle arabe affiche. [mediaNote] decrit un schema/image du manuel pas
/// encore numerise — jamais une vraie image.
class LessonContentSection {
  const LessonContentSection({
    required this.order,
    required this.phaseKey,
    required this.titleAr,
    required this.titleFr,
    required this.bodyAr,
    required this.bodyFr,
    required this.mediaNote,
    required this.exercicesNonTranscrits,
    required this.resourceUrl,
  });

  final int order;
  final String phaseKey;
  final String titleAr;
  final String? titleFr;
  final String bodyAr;
  final String? bodyFr;
  final String? mediaNote;

  /// Resume des exercices du manuel non transcrits integralement (format
  /// "structure-representatif" des leçons de mathematiques). Absent des
  /// leçons de sciences, transcrites exhaustivement.
  final String? exercicesNonTranscrits;

  /// URL de l'image reelle (calculee cote API a partir de resource_id),
  /// quand un schema a ete importe pour cette phase. mediaNote reste alors
  /// affiche comme legende, ce n'est plus un placeholder.
  final String? resourceUrl;

  factory LessonContentSection.fromJson(Map<String, dynamic> json) => LessonContentSection(
    order: json['order'] as int,
    phaseKey: json['phase_key'] as String,
    titleAr: json['title_ar'] as String,
    titleFr: json['title_fr'] as String?,
    bodyAr: json['body_ar'] as String,
    bodyFr: json['body_fr'] as String?,
    mediaNote: json['media_note'] as String?,
    exercicesNonTranscrits: json['exercices_non_transcrits'] as String?,
    resourceUrl: json['resource_url'] as String?,
  );
}
