import '../entities/auth_session_entity.dart';
import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<AuthSessionEntity> login({
    required String username,
    required String password,
  });

  Future<AuthUserEntity> getCurrentUser(String accessToken);
}
