import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import 'models/admin_axis.dart';
import 'models/admin_lesson.dart';
import 'models/admin_subject.dart';
import 'models/admin_term.dart';
import 'models/admin_unit.dart';

/// Lecture seule de la hierarchie de contenu (ADMIN) : Subject -> Term ->
/// Unit -> (Axis optionnel) -> Lesson. Aucune creation/edition/suppression
/// de Subject/Term/Unit/Lesson a cette etape ; Axis a une ecriture minimale
/// (POST/PATCH) demandee explicitement.
class ContentRepository {
  const ContentRepository(this._dio);

  final Dio _dio;

  Future<List<AdminSubject>> getSubjects() async {
    final response = await _dio.get<List<dynamic>>('/admin/subjects');
    return response.data!
        .map((json) => AdminSubject.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<AdminTerm>> getTerms(String subjectId) async {
    final response = await _dio.get<List<dynamic>>(
      '/admin/terms',
      queryParameters: {'subject_id': subjectId},
    );
    return response.data!.map((json) => AdminTerm.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<AdminUnit>> getUnits(String termId) async {
    final response = await _dio.get<List<dynamic>>(
      '/admin/units',
      queryParameters: {'term_id': termId},
    );
    return response.data!.map((json) => AdminUnit.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<AdminAxis>> getAxes(String unitId) async {
    final response = await _dio.get<List<dynamic>>(
      '/admin/axes',
      queryParameters: {'unit_id': unitId},
    );
    return response.data!.map((json) => AdminAxis.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// [axisId] optionnel : affine sur les Lesson d'un Axis precis. Sans lui,
  /// retourne toutes les Lesson de l'Unit (cas des matieres sans Axis, ex.
  /// Mathematiques).
  Future<List<AdminLesson>> getLessons(String unitId, {String? axisId}) async {
    final response = await _dio.get<List<dynamic>>(
      '/admin/lessons',
      queryParameters: {'unit_id': unitId, 'axis_id': ?axisId},
    );
    return response.data!
        .map((json) => AdminLesson.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

final Provider<ContentRepository> contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository(ref.watch(dioProvider));
});

/// Chargement paresseux : chaque provider n'est evalue que lorsqu'un widget
/// le regarde effectivement (voir _expanded dans admin_content_screen.dart,
/// qui ne construit le widget enfant watchant ces providers qu'apres
/// depliage). Pas d'autoDispose : une fois chargee, une section repliee
/// puis re-depliee ne re-fetch pas.
final termsProvider = FutureProvider.family<List<AdminTerm>, String>((ref, subjectId) {
  return ref.watch(contentRepositoryProvider).getTerms(subjectId);
});

final unitsProvider = FutureProvider.family<List<AdminUnit>, String>((ref, termId) {
  return ref.watch(contentRepositoryProvider).getUnits(termId);
});

final axesProvider = FutureProvider.family<List<AdminAxis>, String>((ref, unitId) {
  return ref.watch(contentRepositoryProvider).getAxes(unitId);
});

/// Cle composite (record) : Riverpod la compare par valeur, donc
/// `(unitId: 'a', axisId: null)` reste un cache stable independamment de
/// l'endroit ou il est construit.
typedef LessonsQuery = ({String unitId, String? axisId});

final lessonsProvider = FutureProvider.family<List<AdminLesson>, LessonsQuery>((ref, query) {
  return ref.watch(contentRepositoryProvider).getLessons(query.unitId, axisId: query.axisId);
});

final subjectsProvider = FutureProvider.autoDispose<List<AdminSubject>>((ref) {
  return ref.watch(contentRepositoryProvider).getSubjects();
});
