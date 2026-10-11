/// Back4App / Parse Server connection settings.
class ParseConfig {
  ParseConfig._();

  static const String applicationId = String.fromEnvironment(
    'PARSE_APP_ID',
    defaultValue: 'DYcuDNOm8aWRjpRUtPk3UQCmCguPYrwLzOzsW4Bo',
  );

  static const String clientKey = String.fromEnvironment(
    'PARSE_CLIENT_KEY',
    defaultValue: '4D6sGLUzFF8bxxUVaLuhhCqxGuu3YLms1NgWJD3o',
  );

  static const String serverUrl = String.fromEnvironment(
    'PARSE_SERVER_URL',
    defaultValue: 'https://parseapi.back4app.com',
  );

  static bool get hasCredentials =>
      applicationId.isNotEmpty && clientKey.isNotEmpty;
}
