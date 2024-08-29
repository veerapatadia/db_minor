import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void changetheme(String theme) {
    if (theme == "dark") {
      _themeMode = ThemeMode.dark;
    } else if (theme == "light") {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  String get currentTheme {
    if (_themeMode == ThemeMode.dark) return "dark";
    if (_themeMode == ThemeMode.light) return "light";
    return "system";
  }
}
