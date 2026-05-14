import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/auth_token_store.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../providers/auth_providers.dart';

enum AuthStatus { unauthenticated, loading, authenticated, failure }

class AuthState {
  const AuthState({required this.status, this.session, this.errorMessage});

  const AuthState.unauthenticated()
    : status = AuthStatus.unauthenticated,
      session = null,
      errorMessage = null;

  final AuthStatus status;
  final AuthSessionEntity? session;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    AuthSessionEntity? session,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      errorMessage: errorMessage,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState.unauthenticated();

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final session = await ref
          .read(authRepositoryProvider)
          .login(username: username, password: password);
      AuthTokenStore.instance.save(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      state = AuthState(status: AuthStatus.authenticated, session: session);
    } catch (error) {
      state = AuthState(
        status: AuthStatus.failure,
        errorMessage: error.toString(),
      );
    }
  }

  void logout() {
    AuthTokenStore.instance.clear();
    state = const AuthState.unauthenticated();
  }
}
