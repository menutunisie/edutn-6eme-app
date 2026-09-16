// Smoke test : verifie que le squelette de l'application demarre et
// affiche la page provisoire (Etape 2 - aucun ecran fonctionnel encore).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edutn6_app/app.dart';

void main() {
  testWidgets('App starts and renders the placeholder home page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: EduTn6App()));
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
