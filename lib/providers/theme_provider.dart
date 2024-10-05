// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode? themeMode;
  bool get isDarkMode {
    return themeMode == ThemeMode.dark ? true : false;
  }

  set setThemeMode(ThemeMode theme) {
    themeMode = theme;
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    saveThemeInstance(isOn);
    notifyListeners();
  }

  saveThemeInstance(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isDark) {
      prefs.setString('THEME_DATA', 'dark');
    } else {
      prefs.setString('THEME_DATA', 'light');
    }
  }

  Future<ThemeMode> readSavedThemeInstance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("THEME_DATA") == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey.shade900,
      colorScheme: const ColorScheme.dark());
  static final lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light());
}
