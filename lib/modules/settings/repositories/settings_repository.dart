import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository(SharedPreferences sharedPerf) : _sharedPref = sharedPerf;

  final SharedPreferences _sharedPref;

  String? _getString(String key) {
    return _sharedPref.getString(key);
  }

  Future<void> _setString(String key, String value) async {
    await _sharedPref.setString(key, value);
  }

  ThemeMode getTheme() {
    var theme = _getString('theme');
    switch (theme) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  setTheme(ThemeMode theme) async {
    await _setString('theme', theme.toString());
  }

  Locale getLanguage() {
    var language = _getString('language');
    switch (language) {
      case 'en':
        return const Locale('en');
      case 'ar':
        return const Locale('ar');
      default:
        return const Locale('en');
    }
  }

  setLanguage(Locale language) async {
    await _setString('language', language.languageCode);
  }
}
