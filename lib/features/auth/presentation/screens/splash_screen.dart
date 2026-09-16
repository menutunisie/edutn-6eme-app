import 'package:flutter/material.dart';

/// Affiche pendant le bootstrap (lecture du stockage securise) avant de
/// savoir si l'utilisateur est deja authentifie.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
