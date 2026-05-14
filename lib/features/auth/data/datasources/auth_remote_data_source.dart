import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_session_model.dart';
import '../models/auth_user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  Future<AuthSessionModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: <String, dynamic>{
        'username': username,
        'password': password,
        'expiresInMins': AppConfig.authSessionExpiresInMins,
      },
    );

    return AuthSessionModel.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<AuthUserModel> getCurrentUser(String accessToken) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/me',
      options: Options(
        headers: <String, dynamic>{'Authorization': 'Bearer $accessToken'},
      ),
    );

    return AuthUserModel.fromJson(response.data ?? <String, dynamic>{});
  }
}
