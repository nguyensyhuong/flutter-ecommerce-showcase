import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'auth_refresh_service.dart';
import 'auth_token_store.dart';

class DioClient {
  DioClient._();

  static final Dio instance = _buildClient();

  static Dio _buildClient() {
    final dio = Dio(
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

    dio.interceptors.addAll([
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-Requested-With'] = 'XMLHttpRequest';

          if (!_isAuthEndpoint(options.path)) {
            final accessToken = AuthTokenStore.instance.accessToken;
            if (accessToken != null && accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            }
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          final shouldRefresh =
              error.response?.statusCode == 401 &&
              !_isAuthEndpoint(error.requestOptions.path) &&
              error.requestOptions.extra['skipAuthRefresh'] != true;

          if (shouldRefresh && AuthTokenStore.instance.refreshToken != null) {
            try {
              final refreshedTokens = await AuthRefreshService.refresh(
                refreshToken: AuthTokenStore.instance.refreshToken!,
              );

              final newAccessToken = refreshedTokens['accessToken'] ?? '';
              final newRefreshToken = refreshedTokens['refreshToken'] ?? '';

              if (newAccessToken.isNotEmpty && newRefreshToken.isNotEmpty) {
                AuthTokenStore.instance.save(
                  accessToken: newAccessToken,
                  refreshToken: newRefreshToken,
                );

                final retryResponse = await dio.request<dynamic>(
                  error.requestOptions.path,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: <String, dynamic>{
                      ...error.requestOptions.headers,
                      'Authorization': 'Bearer $newAccessToken',
                    },
                    responseType: error.requestOptions.responseType,
                    contentType: error.requestOptions.contentType,
                    followRedirects: error.requestOptions.followRedirects,
                    receiveDataWhenStatusError:
                        error.requestOptions.receiveDataWhenStatusError,
                    validateStatus: error.requestOptions.validateStatus,
                    sendTimeout: error.requestOptions.sendTimeout,
                    receiveTimeout: error.requestOptions.receiveTimeout,
                    extra: <String, dynamic>{
                      ...error.requestOptions.extra,
                      'skipAuthRefresh': true,
                      'retryCount':
                          (error.requestOptions.extra['retryCount'] as int? ??
                              0) +
                          1,
                    },
                  ),
                  cancelToken: error.requestOptions.cancelToken,
                  onReceiveProgress: error.requestOptions.onReceiveProgress,
                  onSendProgress: error.requestOptions.onSendProgress,
                );

                return handler.resolve(retryResponse);
              }
            } catch (_) {
              AuthTokenStore.instance.clear();
            }
          }

          final shouldRetryRequest = _shouldRetry(error);
          final retryCount =
              error.requestOptions.extra['retryCount'] as int? ?? 0;

          if (shouldRetryRequest && retryCount < 1) {
            await Future<void>.delayed(const Duration(milliseconds: 350));

            final retryResponse = await dio.request<dynamic>(
              error.requestOptions.path,
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
              options: Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
                responseType: error.requestOptions.responseType,
                contentType: error.requestOptions.contentType,
                followRedirects: error.requestOptions.followRedirects,
                receiveDataWhenStatusError:
                    error.requestOptions.receiveDataWhenStatusError,
                validateStatus: error.requestOptions.validateStatus,
                sendTimeout: error.requestOptions.sendTimeout,
                receiveTimeout: error.requestOptions.receiveTimeout,
                extra: <String, dynamic>{
                  ...error.requestOptions.extra,
                  'retryCount': retryCount + 1,
                },
              ),
              cancelToken: error.requestOptions.cancelToken,
              onReceiveProgress: error.requestOptions.onReceiveProgress,
              onSendProgress: error.requestOptions.onSendProgress,
            );

            return handler.resolve(retryResponse);
          }

          return handler.next(error);
        },
      ),
      if (AppConfig.enableHttpLogging)
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
    ]);

    return dio;
  }

  static bool _isAuthEndpoint(String path) {
    return path.startsWith('/auth/login') || path.startsWith('/auth/refresh');
  }

  static bool _shouldRetry(DioException error) {
    final statusCode = error.response?.statusCode;
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (statusCode != null && statusCode >= 500);
  }
}
