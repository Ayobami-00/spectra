import 'package:frontend/core/config/app_config.dart';

/// Holds the [AppConfig] config information.
///
/// Allows the config to be accessed via a static variable anywhere in the app.
class AmConfig {
  static late final AppConfig config;

  // ignore: use_setters_to_change_properties
  static void set(AppConfig appConfig) {
    config = appConfig;
  }
}
