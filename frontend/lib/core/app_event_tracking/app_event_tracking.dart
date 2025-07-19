import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:frontend/core/config/index.dart';

class AppEventTrackingAnalyticsService {
  static Future<void> init() async {
    final Amplitude analytics = Amplitude(Configuration(
      apiKey: AmConfig.config.amplitudeApiKey!,
      instanceName: AmConfig.config.amplitudeProject!,
    ));
    // Initialize SDK
    await analytics.isBuilt;
  }

  static Future<void> setUserId(String userId) async {
    final Amplitude analytics = Amplitude(Configuration(
      apiKey: AmConfig.config.amplitudeApiKey!,
      instanceName: AmConfig.config.amplitudeProject!,
    ));
    analytics.setUserId(userId);
  }

  static Future<void> logEvent(String event,
      [Map<String, dynamic>? properties]) async {
    final Amplitude analytics = Amplitude(Configuration(
      apiKey: AmConfig.config.amplitudeApiKey!,
      instanceName: AmConfig.config.amplitudeProject!,
    ));

    analytics.track(
      BaseEvent(
        event,
        eventProperties: properties,
      ),
    );
  }
}
