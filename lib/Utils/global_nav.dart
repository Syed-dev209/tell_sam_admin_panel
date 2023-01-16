import 'package:flutter/material.dart';

class NavigationServices {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  static Future pushScreen(Widget goTo) async {
    await Navigator.push(navigationKey.currentState!.context,
        MaterialPageRoute(builder: (_) => goTo));
  }

  static Future pushReplaceScreen(Widget goTo)async {
        await Navigator.pushReplacement(navigationKey.currentState!.context,
        MaterialPageRoute(builder: (_) => goTo));
  }
}
