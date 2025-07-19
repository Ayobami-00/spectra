/// Contains the sensitive and necessary configuration variables needed to run the applicatiom.
class AppConfig {
  /// The backend endpoint base api url.
  final String? baseApiUrl;

  /// The websocket url.
  final String? wsUrl;

  //* dsn from sentry
  final String? sentryDsn;
  final double? sentryTracesSampleRate;

  /// The assistant api url.
  final String? assistantApiUrl;

  /// The assistant api key.
  final String? assistantApiKey;

  final String? assistantSuperadminApiEmail;
  final String? assistantSuperadminApiPassword;

  final String? livekitUrl;
  final String? amplitudeApiKey;
  final String? amplitudeProject;

  const AppConfig({
    this.baseApiUrl,
    this.assistantApiUrl,
    this.assistantApiKey,
    this.assistantSuperadminApiEmail,
    this.assistantSuperadminApiPassword,
    this.sentryDsn,
    this.sentryTracesSampleRate,
    this.wsUrl,
    this.livekitUrl,
    this.amplitudeApiKey,
    this.amplitudeProject,
  });
}
