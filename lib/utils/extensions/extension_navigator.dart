import 'package:flutter/material.dart';

extension NavigatorStateExtension on NavigatorState {
  Future<dynamic> pushNamedOrReplacementIfCurrent(
    String routeName, {
    Object? arguments,
  }) async {
    if (isCurrent(routeName)) {
      return pushReplacementNamed(routeName, arguments: arguments);
    } else {
      return pushNamed(routeName, arguments: arguments);
    }
  }

  bool isCurrent(String routeName) {
    bool isCurrent = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}
