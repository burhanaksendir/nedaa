import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nedaa/modules/settings/repositories/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.settingsRepository)
      : super(
          SettingsState(
            appLanguage: settingsRepository.getLanguage(),
            appTheme: settingsRepository.getTheme(),
            isFirstRun: settingsRepository.isFirstRun(),
          ),
        ) {
    on<LanguageEvent>(
      (event, emit) => {
        emit(SettingsState(
          appLanguage: event.appLanguage,
          appTheme: state.appTheme,
          isFirstRun: state.isFirstRun,
        )),
        settingsRepository.setLanguage(event.appLanguage)
      },
    );
    on<ThemeEvent>(
      (event, emit) => {
        emit(SettingsState(
          appLanguage: state.appLanguage,
          appTheme: event.theme,
          isFirstRun: state.isFirstRun,
        )),
        settingsRepository.setTheme(event.theme)
      },
    );
    on<FirstRunEvent>(
      (event, emit) => {
        emit(SettingsState(
          appLanguage: state.appLanguage,
          appTheme: state.appTheme,
          isFirstRun: false,
        )),
        settingsRepository.setIsFirstRun(false)
      },
    );
  }

  final SettingsRepository settingsRepository;
}

class SettingsState {
  final Locale appLanguage;
  final ThemeMode appTheme;
  final bool isFirstRun;

  SettingsState(
      {required this.appLanguage,
      required this.appTheme,
      required this.isFirstRun});
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

class FirstRunEvent extends SettingsEvent {
  FirstRunEvent();
}
