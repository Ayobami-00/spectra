import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/index.dart';
import 'package:frontend/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AppConfig with environment variables from the build environment
  final config = AppConfig(
    baseApiUrl: const String.fromEnvironment('BASE_API_URL'),
    assistantApiUrl: const String.fromEnvironment('ASSISTANT_API_URL'),
    assistantApiKey: const String.fromEnvironment('ASSISTANT_API_KEY'),
    assistantSuperadminApiEmail:
        const String.fromEnvironment('ASSISTANT_SUPERADMIN_API_EMAIL'),
    assistantSuperadminApiPassword:
        const String.fromEnvironment('ASSISTANT_SUPERADMIN_API_PASSWORD'),
    sentryDsn: const String.fromEnvironment('SENTRY_DSN'),
    sentryTracesSampleRate: double.tryParse(const String.fromEnvironment(
        'SENTRY_TRACE_SAMPLE_RATE',
        defaultValue: '0.0')),
    wsUrl: const String.fromEnvironment('WS_URL'),
    livekitUrl: const String.fromEnvironment('LIVEKIT_URL'),
    amplitudeApiKey: const String.fromEnvironment('AMPLITUDE_API_KEY'),
    amplitudeProject: const String.fromEnvironment('AMPLITUDE_PROJECT'),
  );

  log(config.toString());

  Provider.debugCheckInvalidValueType = null;
  // Set app config and initialize locator
  AmConfig.set(config);
  setUpAppLocator();

  runZonedGuarded(
    () async {
      if (kIsWeb) {
        try {} catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }

      if (kReleaseMode) {
        await SentryFlutter.init(
          (options) {
            options.dsn = config.sentryDsn;
            options.environment = String.fromEnvironment('ENVIRONMENT');
            options.release = String.fromEnvironment('SENTRY_RELEASE_NAME');
            options.beforeSend = (event, {hint}) {
              if (hint == null || hint is! String) {
                return event;
              }
              return event.copyWith(message: SentryMessage(hint));
            } as BeforeSendCallback?;
          },
        );

        AppEventTrackingAnalyticsService.init();
      }

      runApp(
        const App(),
      );
    },
    (Object error, StackTrace stackTrace) {
      AppErrorLogger.logError(error, stackTrace);
    },
  );
}
