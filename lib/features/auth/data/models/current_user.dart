import '../../../../shared/models/user_role.dart';

/// Miroir de `UserRead` cote API (app/schemas/user.py).
class CurrentUser {
  const CurrentUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.isActive,
  });

  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final bool isActive;

  factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
    id: json['id'] as String,
    email: json['email'] as String,
    fullName: json['full_name'] as String,
    role: userRoleFromApi(json['role'] as String),
    isActive: json['is_active'] as bool,
  );
}
