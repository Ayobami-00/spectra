import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> appBaseNavigatorKey =
      GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  void goNamed(String routeName,
      {Object? extra,
      Map<String, String>? pathParameters,
      Map<String, String>? queryParameters}) {
    navigatorKey.currentContext?.goNamed(
      routeName,
      extra: extra,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
    );
  }

  void pushNamed(String routeName, {Object? extra}) {
    navigatorKey.currentContext?.pushNamed(routeName, extra: extra);
  }

  void pop() {
    navigatorKey.currentContext?.pop();
  }
}
