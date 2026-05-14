class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dummyjson.com',
  );

  static const int apiTimeoutSeconds = int.fromEnvironment(
    'API_TIMEOUT_SECONDS',
    defaultValue: 15,
  );

  static const int authSessionExpiresInMins = int.fromEnvironment(
    'AUTH_SESSION_EXPIRES_IN_MINS',
    defaultValue: 60,
  );

  static const bool enableHttpLogging = bool.fromEnvironment(
    'ENABLE_HTTP_LOGGING',
    defaultValue: true,
  );

  AppConfig._();
}
