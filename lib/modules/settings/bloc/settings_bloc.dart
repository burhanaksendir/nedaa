import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iathan/modules/settings/repositories/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static ThemeMode _getThemeFromString(String? theme) {
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

  static Locale _getLocaleFromString(String? locale) {
    switch (locale) {
      case 'ar':
        return const Locale('ar');
      case 'en':
        return const Locale('en');
      default:
        return const Locale('en');
    }
  }

  SettingsBloc(this.settingsRepository)
      : super(
          SettingsState(
              appLanguage: _getLocaleFromString(
                  settingsRepository.getString("language")),
              appTheme:
                  _getThemeFromString(settingsRepository.getString("theme"))),
        ) {
    on<LanguageEvent>(
      (event, emit) => {
        emit(SettingsState(
            appLanguage: event.appLanguage, appTheme: state.appTheme)),
        settingsRepository.setString("language", event.appLanguage.languageCode)
      },
    );
    on<ThemeEvent>((event, emit) => {
          emit(SettingsState(
              appLanguage: state.appLanguage, appTheme: event.theme)),
          settingsRepository.setString('theme', event.theme.toString())
        });
  }

  final SettingsRepository settingsRepository;
}

class SettingsState {
  final Locale? appLanguage;
  final ThemeMode? appTheme;

  SettingsState({this.appLanguage, this.appTheme});
}

class SettingsEvent {}

class LanguageEvent extends SettingsEvent {
  final Locale appLanguage;

  LanguageEvent(this.appLanguage);
}

class ThemeEvent extends SettingsEvent {
  final ThemeMode theme;

  ThemeEvent(this.theme);
}
