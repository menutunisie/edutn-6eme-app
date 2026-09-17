/// Miroir de `TermRead` cote API (app/schemas/content.py).
class AdminTerm {
  const AdminTerm({
    required this.id,
    required this.subjectId,
    required this.code,
    required this.nameFr,
    required this.nameAr,
    required this.displayOrder,
  });

  final String id;
  final String subjectId;
  final String code;
  final String nameFr;
  final String nameAr;
  final int displayOrder;

  factory AdminTerm.fromJson(Map<String, dynamic> json) => AdminTerm(
    id: json['id'] as String,
    subjectId: json['subject_id'] as String,
    code: json['code'] as String,
    nameFr: json['name_fr'] as String,
    nameAr: json['name_ar'] as String,
    displayOrder: json['display_order'] as int,
  );
}
