import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository.dart';
import '../../data/models/current_user.dart';

enum AuthStatus {
  /// Bootstrap en cours (lecture du stockage securise au demarrage de l'app).
  unknown,
  authenticating,
  authenticated,
  unauthenticated,
}

/// Erreur d'authentification, sous forme de code plutot que de message en
/// dur : la localisation (FR/AR) se fait dans le widget, via
/// AppLocalizations, jamais dans le controller (qui n'a pas de BuildContext).
enum AuthError { invalidCredentials, disabledAccount, network, sessionExpired }

class AuthState {
  const AuthState({this.status = AuthStatus.unknown, this.user, this.error});

  final AuthStatus status;
  final CurrentUser? user;
  final AuthError? error;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  AuthState copyWith({AuthStatus? status, CurrentUser? user, AuthError? error}) {
    return AuthState(status: status ?? this.status, user: user ?? this.user, error: error);
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._authRepository) : super(const AuthState()) {
    _bootstrap();
  }

  final AuthRepository _authRepository;

  Future<void> _bootstrap() async {
    if (!await _authRepository.hasStoredSession()) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }

    try {
      final user = await _authRepository.getCurrentUser();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    try {
      await _authRepository.login(email: email, password: password);
      final user = await _authRepository.getCurrentUser();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } on DioException catch (error) {
      state = AuthState(status: AuthStatus.unauthenticated, error: _errorFrom(error));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Appele par [AuthInterceptor] quand le refresh token est invalide/expire :
  /// force une deconnexion locale et affiche un message explicite.
  Future<void> forceLogout() async {
    state = const AuthState(
      status: AuthStatus.unauthenticated,
      error: AuthError.sessionExpired,
    );
  }

  AuthError _errorFrom(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401) return AuthError.invalidCredentials;
    if (statusCode == 403) return AuthError.disabledAccount;
    return AuthError.network;
  }
}

final StateNotifierProvider<AuthController, AuthState> authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});
