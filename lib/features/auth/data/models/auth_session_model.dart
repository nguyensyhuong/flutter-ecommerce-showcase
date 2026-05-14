import '../../domain/entities/auth_session_entity.dart';
import 'auth_user_model.dart';

class AuthSessionModel extends AuthSessionEntity {
  const AuthSessionModel({
    required super.user,
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      user: AuthUserModel.fromJson(json),
      accessToken: (json['accessToken'] as String?) ?? '',
      refreshToken: (json['refreshToken'] as String?) ?? '',
    );
  }
}
