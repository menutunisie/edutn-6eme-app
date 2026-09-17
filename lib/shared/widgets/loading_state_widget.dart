import 'package:flutter/material.dart';

/// Etat de chargement generique (liste, ecran, section...).
class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()),
    );
  }
}
