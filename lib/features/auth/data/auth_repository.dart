// ignore_for_file: prefer_initializing_formals
// Les parametres nommes gardent un nom lisible (dio, refreshDio...) distinct
// des champs prives correspondants.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_tokens.dart';
import '../../../core/auth/token_storage.dart';
import '../../../core/network/dio_client.dart';
import 'models/current_user.dart';

class AuthRepository {
  AuthRepository({required Dio dio, required Dio refreshDio, required TokenStorage tokenStorage})
    : _dio = dio,
      _refreshDio = refreshDio,
      _tokenStorage = tokenStorage;

  /// Dio intercepte : attache automatiquement le JWT (utilise pour /auth/me
  /// et /auth/logout).
  final Dio _dio;

  /// Dio sans intercepteur, dedie a /auth/refresh (voir [AuthInterceptor]).
  final Dio _refreshDio;

  final TokenStorage _tokenStorage;

  Future<bool> hasStoredSession() async {
    return await _tokenStorage.readRefreshToken() != null;
  }

  Future<AuthTokens> login({required String email, required String password}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final tokens = AuthTokens.fromJson(response.data!);
    await _tokenStorage.saveTokens(tokens);
    return tokens;
  }

  Future<AuthTokens> refreshToken() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null) {
      throw StateError('Aucun refresh token disponible');
    }

    final response = await _refreshDio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    final tokens = AuthTokens.fromJson(response.data!);
    await _tokenStorage.saveTokens(tokens);
    return tokens;
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken != null) {
      try {
        await _dio.post<void>('/auth/logout', data: {'refresh_token': refreshToken});
      } catch (_) {
        // Le logout local doit reussir meme si l'appel serveur echoue
        // (reseau indisponible, token deja expire...).
      }
    }
    await _tokenStorage.clear();
  }

  Future<CurrentUser> getCurrentUser() async {
    final response = await _dio.get<Map<String, dynamic>>('/auth/me');
    return CurrentUser.fromJson(response.data!);
  }
}

final Provider<AuthRepository> authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    refreshDio: ref.watch(refreshDioProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});
