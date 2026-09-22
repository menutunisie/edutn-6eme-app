import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../controllers/auth_controller.dart';

/// Affiche pendant le bootstrap : lecture du stockage securise en temps
/// normal, ou -- en mode kBypassAuthForDev -- le temps du vrai login
/// automatique de dev (voir AuthController._bootstrapDevBypass). Si ce
/// login automatique echoue, affiche l'erreur explicitement (jamais un
/// echec silencieux ni un ecran vide bloque).
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);

    if (authState.error == AuthError.devBypassLoginFailed) {
      return Scaffold(
        body: ErrorStateWidget(
          message: l10n.devBypassLoginFailedMessage,
          onRetry: () => ref.read(authControllerProvider.notifier).retryDevBypassLogin(),
        ),
      );
    }

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
