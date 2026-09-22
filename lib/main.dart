// TODO(dev-flags): kBypassAuthForDev (lib/core/config/dev_flags.dart) est
// actif — l'ecran de connexion est court-circuite. Le repasser a `false`
// avant tout partage externe ou deploiement.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  runApp(const ProviderScope(child: EduTn6App()));
}
