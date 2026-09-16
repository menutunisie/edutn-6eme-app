// Smoke test : verifie que le squelette de l'application demarre, execute
// le bootstrap d'authentification (aucune session stockee) et affiche
// l'ecran de connexion.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edutn6_app/app.dart';
import 'package:edutn6_app/core/auth/token_storage.dart';

/// Le vrai FlutterSecureStorage passe par un MethodChannel indisponible en
/// test unitaire : on le remplace par une implementation en memoire pour que
/// le bootstrap d'authentification se resolve immediatement.
class _InMemoryTokenStorage extends TokenStorage {
  _InMemoryTokenStorage() : super(const FlutterSecureStorage());

  String? _accessToken;
  String? _refreshToken;

  @override
  Future<void> saveTokens(tokens) async {
    _accessToken = tokens.accessToken;
    _refreshToken = tokens.refreshToken;
  }

  @override
  Future<String?> readAccessToken() async => _accessToken;

  @override
  Future<String?> readRefreshToken() async => _refreshToken;

  @override
  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
  }
}

void main() {
  testWidgets('App starts and redirects to the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [tokenStorageProvider.overrideWithValue(_InMemoryTokenStorage())],
        child: const EduTn6App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('EduTN 6ème'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
  });
}
