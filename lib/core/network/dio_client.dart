import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../auth/auth_tokens.dart';
import '../auth/token_storage.dart';
import '../config/env.dart';
import 'auth_interceptor.dart';

const _connectTimeout = Duration(seconds: 10);
const _receiveTimeout = Duration(seconds: 10);

/// Dio "nu", sans intercepteur : utilise uniquement pour l'appel
/// POST /auth/refresh, afin d'eviter toute recursion avec [AuthInterceptor].
final Provider<Dio> refreshDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
    ),
  );
});

/// Client HTTP principal de l'application : attache automatiquement le JWT
/// et gere le refresh silencieux en cas de 401 (voir [AuthInterceptor]).
final Provider<Dio> dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: ref.watch(tokenStorageProvider),
      refreshDio: ref.watch(refreshDioProvider),
      requestDio: dio,
      performRefresh: (refreshDio, refreshToken) async {
        final response = await refreshDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: {'refresh_token': refreshToken},
        );
        return AuthTokens.fromJson(response.data!);
      },
      onAuthFailure: () => ref.read(authControllerProvider.notifier).forceLogout(),
    ),
  );

  return dio;
});
