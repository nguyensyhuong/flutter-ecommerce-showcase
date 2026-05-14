class AuthTokenStore {
  AuthTokenStore._();

  static final AuthTokenStore instance = AuthTokenStore._();

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  bool get hasTokens =>
      (_accessToken?.isNotEmpty ?? false) &&
      (_refreshToken?.isNotEmpty ?? false);

  void save({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  void clear() {
    _accessToken = null;
    _refreshToken = null;
  }
}
