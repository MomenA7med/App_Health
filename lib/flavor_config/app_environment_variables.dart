/// Class that helps easy access to the environment variables.
final class AppEnvironmentVariables {
  AppEnvironmentVariables._();

  /// Application base URL for API calls.
  static const baseUrl = String.fromEnvironment('baseUrl');
}
