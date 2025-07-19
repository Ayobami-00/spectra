import 'package:flutter/foundation.dart';

class ApplicationErrorLogger {
  static void log(
    dynamic e,
    StackTrace? s, {
    Map<String, dynamic>? moreInfo,
  }) {
    if (kDebugMode) {
      // only print to console during debug mode
      // ignore: avoid_print
      print(e);
      // ignore: avoid_print
      print(s);

      if (moreInfo != null) {
        // ignore: avoid_print
        print('more info');
        // ignore: avoid_print
        print(moreInfo);
      }
      return;
    }
  }
}
