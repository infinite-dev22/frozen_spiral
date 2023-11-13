import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(String routeName) {
    bool isRoot = false;

    navigatorKey.currentState?.popUntil((route) {
      if (route.settings.name == "/") {
        isRoot = true;
      }
      return true;
    });

    if (!isRoot) {
      return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName,
        (route) => false,
      );
    }
    return null;
  }

  goBack() {
    return navigatorKey.currentState!.pop();
  }
}
