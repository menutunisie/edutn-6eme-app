import 'content_status.dart';

/// Miroir de `UnitRead` cote API (app/schemas/content.py).
class AdminUnit {
  const AdminUnit({
    required this.id,
    required this.termId,
    required this.titleFr,
    required this.titleAr,
    required this.status,
    required this.description,
    required this.displayOrder,
  });

  final String id;
  final String termId;
  final String? titleFr;
  final String? titleAr;
  final ContentStatus status;
  final String? description;
  final int displayOrder;

  factory AdminUnit.fromJson(Map<String, dynamic> json) => AdminUnit(
    id: json['id'] as String,
    termId: json['term_id'] as String,
    titleFr: json['title_fr'] as String?,
    titleAr: json['title_ar'] as String?,
    status: contentStatusFromApi(json['status'] as String),
    description: json['description'] as String?,
    displayOrder: json['display_order'] as int,
  );
}
