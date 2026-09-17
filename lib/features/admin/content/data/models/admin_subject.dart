/// Miroir de `SubjectRead` cote API (app/schemas/content.py).
class AdminSubject {
  const AdminSubject({
    required this.id,
    required this.schoolLevelId,
    required this.code,
    required this.nameFr,
    required this.nameAr,
    required this.color,
    required this.displayOrder,
  });

  final String id;
  final String schoolLevelId;
  final String code;
  final String nameFr;
  final String nameAr;
  final String color;
  final int displayOrder;

  factory AdminSubject.fromJson(Map<String, dynamic> json) => AdminSubject(
    id: json['id'] as String,
    schoolLevelId: json['school_level_id'] as String,
    code: json['code'] as String,
    nameFr: json['name_fr'] as String,
    nameAr: json['name_ar'] as String,
    color: json['color'] as String,
    displayOrder: json['display_order'] as int,
  );
}
