import 'content_status.dart';

/// Miroir de `AxisRead` cote API (app/schemas/content.py). Niveau
/// intermediaire optionnel entre Unit et Lesson (ex. Eveil scientifique) :
/// toutes les matieres n'en ont pas (ex. Mathematiques).
class AdminAxis {
  const AdminAxis({
    required this.id,
    required this.unitId,
    required this.titleFr,
    required this.titleAr,
    required this.description,
    required this.status,
    required this.displayOrder,
  });

  final String id;
  final String unitId;
  final String? titleFr;
  final String titleAr;
  final String? description;
  final ContentStatus status;
  final int displayOrder;

  factory AdminAxis.fromJson(Map<String, dynamic> json) => AdminAxis(
    id: json['id'] as String,
    unitId: json['unit_id'] as String,
    titleFr: json['title_fr'] as String?,
    titleAr: json['title_ar'] as String,
    description: json['description'] as String?,
    status: contentStatusFromApi(json['status'] as String),
    displayOrder: json['display_order'] as int,
  );
}
