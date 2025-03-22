import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const _key = 'themeMode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.toString());
    notifyListeners();
  }

  Future<void> _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mode = prefs.getString(_key);
    if (mode != null) {
      _themeMode = mode == ThemeMode.dark.toString() ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }
}
