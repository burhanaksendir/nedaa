import 'package:flutter/material.dart';

class SettingsEvent {}

class LanguageEvent extends SettingsEvent {
  final Locale appLanguage;

  LanguageEvent(this.appLanguage);
}

class ThemeEvent extends SettingsEvent {
  final ThemeMode theme;

  ThemeEvent(this.theme);
}
