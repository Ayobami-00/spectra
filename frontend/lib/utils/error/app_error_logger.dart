import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppErrorLogger {
  static void logError(
    dynamic error,
    StackTrace stackTrace, {
    Map<String, dynamic>? medadata,
  }) {
    // We should only print errors to console in debug mode
    if (kDebugMode) {
      String errorString =
          "-------------------- DEBUG ERROR ---------------- \n Exception: $error \n StackTrace: $stackTrace \n";

      if (medadata != null) {
        errorString += "Extra Info: ${medadata.toString()} \n";
      }
      log(errorString);

      return;
    }

    Sentry.captureException(
      error,
      stackTrace: stackTrace,
    );

    return;
  }
}
