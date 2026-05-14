import 'package:dio/dio.dart';

const String baseUrl = 'https://dummyjson.com';

class DioClient {
  DioClient._();

  static final Dio instance =
      Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            headers: <String, dynamic>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )
        ..interceptors.addAll([
          InterceptorsWrapper(
            onRequest: (options, handler) {
              options.headers['X-Requested-With'] = 'XMLHttpRequest';
              return handler.next(options);
            },
            onError: (error, handler) {
              return handler.next(error);
            },
          ),
          LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseHeader: false,
            responseBody: true,
            error: true,
          ),
        ]);
}
