import 'package:flutter/material.dart';
import 'package:smart_case/data/screen_arguments.dart';

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

  Future<dynamic>? navigateWithArgumentsTo(
      String routeName, dynamic arguments) {
    return navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  goBack() {
    return navigatorKey.currentState!.pop();
  }
}
