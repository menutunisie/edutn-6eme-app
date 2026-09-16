import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../shared/models/user_role.dart';
import 'models/admin_user.dart';

class AdminUserRepository {
  const AdminUserRepository(this._dio);

  final Dio _dio;

  Future<List<AdminUser>> listUsers({UserRole? role}) async {
    final response = await _dio.get<List<dynamic>>(
      '/admin/users',
      queryParameters: {if (role != null) 'role': role.apiValue},
    );
    return response.data!
        .map((json) => AdminUser.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<AdminUser> createUser({
    required String email,
    required String fullName,
    required String password,
    required UserRole role,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/admin/users',
      data: {'email': email, 'full_name': fullName, 'password': password, 'role': role.apiValue},
    );
    return AdminUser.fromJson(response.data!);
  }
}

final adminUserRepositoryProvider = Provider<AdminUserRepository>((ref) {
  return AdminUserRepository(ref.watch(dioProvider));
});
