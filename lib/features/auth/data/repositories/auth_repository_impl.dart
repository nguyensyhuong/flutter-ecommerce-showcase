import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthSessionEntity> login({
    required String username,
    required String password,
  }) {
    return _remoteDataSource.login(username: username, password: password);
  }

  @override
  Future<AuthUserEntity> getCurrentUser(String accessToken) {
    return _remoteDataSource.getCurrentUser(accessToken);
  }
}
