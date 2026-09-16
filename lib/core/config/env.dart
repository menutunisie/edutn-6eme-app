/// Configuration d'environnement de l'application.
///
/// La valeur peut être surchargée au build/run avec :
///   flutter run --dart-define=API_BASE_URL=https://api.edutn6.example.com
class Env {
  Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
}
