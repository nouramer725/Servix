import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const _key = 'locale';
  Locale _locale = const Locale('en'); // Default to English

  LocaleProvider() {
    _loadLocale();
  }

  // Getter to access the current locale
  Locale get locale => _locale;

  // Method to update and persist the selected locale
  void setLocale(Locale locale) async {
    _locale = locale;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode); // Store the locale code
    notifyListeners(); // Notify listeners of the locale change
  }

  // Load the saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(_key); // Retrieve the saved locale code
    if (languageCode != null) {
      _locale = Locale(languageCode); // Update the locale if found in SharedPreferences
    }
    notifyListeners(); // Notify listeners once the locale is loaded
  }
}
