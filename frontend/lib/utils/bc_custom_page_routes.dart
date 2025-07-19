import 'package:flutter/material.dart';

class BCCustomPageRoutes {
  /// Returns a [PageRouteBuilder] that overrides the default animation behavior in flutter.
  ///
  /// For some of our navigation, we require no navigation and we can override the default
  /// animation in most flutter navigation types as thus.
  /// (https://stackoverflow.com/questions/57773077/how-to-remove-default-navigation-route-animation)
  static PageRouteBuilder withoutAnimation({
    required Widget child,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (BuildContext context, _, __) {
        return child;
      },
    );
  }

  /// Returns a [PageRouteBuilder] that introduces a [FadeTransition] animation.
  ///
  /// For some of our navigation, we require a [FadeTransition] animation and we can
  /// achieve that thus.
  static PageRouteBuilder fadeTransition({
    required Widget child,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (BuildContext context, _, __) {
        return child;
      },
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Returns a [PageRouteBuilder] that introduces a LTR(Left-To-Right) [SlideTransition] animation.
  ///
  /// For some of our navigation, we require a LTR [SlideTransition] animation and we can
  /// achieve that thus.
  static PageRouteBuilder ltrSlideTransition({
    required Widget child,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (BuildContext context, _, __) {
        return child;
      },
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
