// Smoke test : verifie que le squelette de l'application demarre, execute
// le bootstrap d'authentification (aucune session stockee), affiche l'ecran
// de connexion en arabe par defaut (RTL), et que la bascule vers le
// francais fonctionne (LTR).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:edutn6_app/app.dart';
import 'package:edutn6_app/core/auth/token_storage.dart';
import 'package:edutn6_app/core/l10n/locale_controller.dart';

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
  setUp(() {
    // ThemeController / LocaleController persistent via shared_preferences :
    // SharedPreferences.setMockInitialValues evite le MethodChannel reel.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App starts in Arabic (RTL) by default and shows the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [tokenStorageProvider.overrideWithValue(_InMemoryTokenStorage())],
        child: const EduTn6App(),
      ),
    );
    await tester.pumpAndSettle();

    // Libelles affiches en arabe (voir lib/l10n/app_ar.arb).
    expect(find.text('البريد الإلكتروني'), findsOneWidget);
    expect(find.text('كلمة المرور'), findsOneWidget);

    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
  });

  testWidgets('Switching language to French re-renders the login form in LTR', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [tokenStorageProvider.overrideWithValue(_InMemoryTokenStorage())],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const EduTn6App()));
    await tester.pumpAndSettle();

    container.read(localeControllerProvider.notifier).setLocale(const Locale('fr'));
    await tester.pumpAndSettle();

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);

    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.ltr);
  });
}
