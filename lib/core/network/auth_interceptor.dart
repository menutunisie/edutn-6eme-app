// ignore_for_file: prefer_initializing_formals
// Les parametres nommes gardent un nom lisible (refreshDio, requestDio...)
// distinct des champs prives correspondants.

import 'dart:async';

import 'package:dio/dio.dart';

import '../auth/auth_tokens.dart';
import '../auth/token_storage.dart';

/// Intercepteur Dio :
/// - attache automatiquement l'access token courant en header Authorization ;
/// - sur un 401 (hors endpoints publics), tente un refresh puis rejoue la
///   requete d'origine une seule fois ; si le refresh echoue, nettoie le
///   stockage et previent l'appelant via [onAuthFailure].
///
/// Les requetes concurrentes qui echouent pendant qu'un refresh est deja en
/// cours attendent ce refresh au lieu d'en declencher un nouveau (important
/// ici car le refresh token est a usage unique — rotation cote API).
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio refreshDio,
    required Dio requestDio,
    required Future<AuthTokens> Function(Dio refreshDio, String refreshToken) performRefresh,
    required Future<void> Function() onAuthFailure,
  }) : _tokenStorage = tokenStorage,
       _refreshDio = refreshDio,
       _requestDio = requestDio,
       _performRefresh = performRefresh,
       _onAuthFailure = onAuthFailure;

  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final Dio _requestDio;
  final Future<AuthTokens> Function(Dio refreshDio, String refreshToken) _performRefresh;
  final Future<void> Function() _onAuthFailure;

  static const _publicPaths = ['/auth/login', '/auth/refresh'];

  Future<AuthTokens>? _refreshInFlight;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_publicPaths.any((path) => options.path.startsWith(path))) {
      final accessToken = await _tokenStorage.readAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isPublicPath = _publicPaths.any((path) => err.requestOptions.path.startsWith(path));
    final isRetry = err.requestOptions.extra['edutn6RetriedAfterRefresh'] == true;

    if (!isUnauthorized || isPublicPath || isRetry) {
      handler.next(err);
      return;
    }

    try {
      final newAccessToken = await _refreshAccessToken();

      final retryRequest = err.requestOptions;
      retryRequest.headers['Authorization'] = 'Bearer $newAccessToken';
      retryRequest.extra['edutn6RetriedAfterRefresh'] = true;

      final response = await _requestDio.fetch<dynamic>(retryRequest);
      handler.resolve(response);
    } catch (_) {
      await _tokenStorage.clear();
      await _onAuthFailure();
      handler.next(err);
    }
  }

  Future<String> _refreshAccessToken() async {
    // Un seul refresh a la fois : les appels concurrents attendent celui en cours.
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      final tokens = await inFlight;
      return tokens.accessToken;
    }

    final future = _doRefresh();
    _refreshInFlight = future;
    try {
      final tokens = await future;
      return tokens.accessToken;
    } finally {
      _refreshInFlight = null;
    }
  }

  Future<AuthTokens> _doRefresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null) {
      throw StateError('Aucun refresh token disponible');
    }

    final tokens = await _performRefresh(_refreshDio, refreshToken);
    await _tokenStorage.saveTokens(tokens);
    return tokens;
  }
}
