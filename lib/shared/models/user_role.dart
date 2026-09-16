import '../../core/l10n/generated/app_localizations.dart';

/// Role utilisateur, miroir de `UserRole` cote API (app/models/user.py).
enum UserRole { student, teacher, admin }

extension UserRoleApi on UserRole {
  String get apiValue => switch (this) {
    UserRole.student => 'STUDENT',
    UserRole.teacher => 'TEACHER',
    UserRole.admin => 'ADMIN',
  };
}

/// Libelle localise du role (FR/AR) — necessite un [AppLocalizations] car un
/// simple getter statique ne peut pas dependre de la langue active.
String roleLabel(AppLocalizations l10n, UserRole role) => switch (role) {
  UserRole.student => l10n.roleStudent,
  UserRole.teacher => l10n.roleTeacher,
  UserRole.admin => l10n.roleAdmin,
};

UserRole userRoleFromApi(String value) => switch (value) {
  'STUDENT' => UserRole.student,
  'TEACHER' => UserRole.teacher,
  'ADMIN' => UserRole.admin,
  _ => throw ArgumentError('Role API inconnu: $value'),
};
