import 'package:flutter/material.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Future<void> pushAndRemoveUntil(String route) async {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      (route) => false,
    );
  }

    static Future<void> push(String routeName) async {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static void pop() {
    navigatorKey.currentState?.pop();
  }

}
