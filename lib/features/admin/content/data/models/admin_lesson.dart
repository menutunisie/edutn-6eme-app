import 'content_status.dart';

/// Miroir de `LessonRead` cote API (app/schemas/content.py). Contrairement
/// a l'endpoint public, expose tous les statuts (reserve a l'ADMIN).
class AdminLesson {
  const AdminLesson({
    required this.id,
    required this.unitId,
    required this.weekId,
    required this.titleFr,
    required this.titleAr,
    required this.status,
    required this.displayOrder,
  });

  final String id;
  final String unitId;
  final String? weekId;
  final String? titleFr;
  final String? titleAr;
  final ContentStatus status;
  final int displayOrder;

  factory AdminLesson.fromJson(Map<String, dynamic> json) => AdminLesson(
    id: json['id'] as String,
    unitId: json['unit_id'] as String,
    weekId: json['week_id'] as String?,
    titleFr: json['title_fr'] as String?,
    titleAr: json['title_ar'] as String?,
    status: contentStatusFromApi(json['status'] as String),
    displayOrder: json['display_order'] as int,
  );
}
