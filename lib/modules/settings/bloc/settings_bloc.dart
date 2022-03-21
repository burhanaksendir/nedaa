import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iathan/modules/settings/repositories/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.settingsRepository)
      : super(
          SettingsState(
              appLanguage: settingsRepository.getLanguage(),
              appTheme: settingsRepository.getTheme()),
        ) {
    on<LanguageEvent>(
      (event, emit) => {
        emit(SettingsState(
            appLanguage: event.appLanguage, appTheme: state.appTheme)),
        settingsRepository.setLanguage(event.appLanguage)
      },
    );
    on<ThemeEvent>(
      (event, emit) => {
        emit(SettingsState(
            appLanguage: state.appLanguage, appTheme: event.theme)),
        settingsRepository.setTheme(event.theme)
      },
    );
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
