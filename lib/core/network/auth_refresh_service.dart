import 'package:dio/dio.dart';

import '../config/app_config.dart';

class AuthRefreshService {
  AuthRefreshService._();

  static final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
      receiveTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
      sendTimeout: Duration(seconds: AppConfig.apiTimeoutSeconds),
      headers: const <String, dynamic>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static Future<Map<String, String>> refresh({
    required String refreshToken,
  }) async {
    final response = await _refreshDio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: <String, dynamic>{
        'refreshToken': refreshToken,
        'expiresInMins': AppConfig.authSessionExpiresInMins,
      },
    );

    final data = response.data ?? <String, dynamic>{};
    return <String, String>{
      'accessToken': (data['accessToken'] as String?) ?? '',
      'refreshToken': (data['refreshToken'] as String?) ?? '',
    };
  }
}
