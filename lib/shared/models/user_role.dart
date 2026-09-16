/// Role utilisateur, miroir de `UserRole` cote API (app/models/user.py).
enum UserRole { student, teacher, admin }

extension UserRoleApi on UserRole {
  String get apiValue => switch (this) {
    UserRole.student => 'STUDENT',
    UserRole.teacher => 'TEACHER',
    UserRole.admin => 'ADMIN',
  };

  String get label => switch (this) {
    UserRole.student => 'Élève',
    UserRole.teacher => 'Enseignant',
    UserRole.admin => 'Administrateur',
  };
}

UserRole userRoleFromApi(String value) => switch (value) {
  'STUDENT' => UserRole.student,
  'TEACHER' => UserRole.teacher,
  'ADMIN' => UserRole.admin,
  _ => throw ArgumentError('Role API inconnu: $value'),
};
