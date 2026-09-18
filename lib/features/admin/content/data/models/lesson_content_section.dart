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
  });

  final int order;
  final String phaseKey;
  final String titleAr;
  final String? titleFr;
  final String bodyAr;
  final String? bodyFr;
  final String? mediaNote;

  factory LessonContentSection.fromJson(Map<String, dynamic> json) => LessonContentSection(
    order: json['order'] as int,
    phaseKey: json['phase_key'] as String,
    titleAr: json['title_ar'] as String,
    titleFr: json['title_fr'] as String?,
    bodyAr: json['body_ar'] as String,
    bodyFr: json['body_fr'] as String?,
    mediaNote: json['media_note'] as String?,
  );
}
