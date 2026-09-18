import 'content_status.dart';
import 'lesson_content_section.dart';

/// Miroir de `LessonDetailRead` cote API (app/schemas/content.py) :
/// GET /admin/lessons/{id}. La liste (GET /admin/lessons, voir
/// AdminLesson) reste volontairement allegee sans content_sections.
class AdminLessonDetail {
  const AdminLessonDetail({
    required this.id,
    required this.unitId,
    required this.axisId,
    required this.titleFr,
    required this.titleAr,
    required this.status,
    required this.descriptionShort,
    required this.contentSections,
  });

  final String id;
  final String unitId;
  final String? axisId;
  final String? titleFr;
  final String? titleAr;
  final ContentStatus status;
  final String? descriptionShort;
  final List<LessonContentSection>? contentSections;

  factory AdminLessonDetail.fromJson(Map<String, dynamic> json) {
    final rawSections = json['content_sections'] as List<dynamic>?;
    return AdminLessonDetail(
      id: json['id'] as String,
      unitId: json['unit_id'] as String,
      axisId: json['axis_id'] as String?,
      titleFr: json['title_fr'] as String?,
      titleAr: json['title_ar'] as String?,
      status: contentStatusFromApi(json['status'] as String),
      descriptionShort: json['description_short'] as String?,
      contentSections: rawSections
          ?.map((json) => LessonContentSection.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }
}
