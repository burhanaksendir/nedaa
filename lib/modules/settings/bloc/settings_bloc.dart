import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nedaa/modules/settings/repositories/settings_repository.dart';

String getFont(String language) {
  switch (language) {
    case 'ar':
      return GoogleFonts.tajawal().fontFamily!;
    default:
      return GoogleFonts.notoSans().fontFamily!;
  }
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.settingsRepository)
      : super(
          SettingsState(
            appLanguage: settingsRepository.getLanguage(),
            appTheme: settingsRepository.getTheme(),
            isFirstRun: settingsRepository.isFirstRun(),
            font: settingsRepository.getFont(),
            sendCrashReports: settingsRepository.getSendCrashReports(),
          ),
        ) {
    on<LanguageEvent>(
      (event, emit) {
        settingsRepository.setLanguage(event.appLanguage);
        String font = getFont(event.appLanguage.languageCode);
        settingsRepository.setFont(font);
        emit(SettingsState(
          appLanguage: event.appLanguage,
          font: font,
          appTheme: state.appTheme,
          isFirstRun: state.isFirstRun,
          sendCrashReports: state.sendCrashReports,
        ));
      },
    );
    on<ThemeEvent>(
      (event, emit) {
        emit(SettingsState(
          appLanguage: state.appLanguage,
          appTheme: event.theme,
          font: state.font,
          isFirstRun: state.isFirstRun,
          sendCrashReports: state.sendCrashReports,
        ));
        settingsRepository.setTheme(event.theme);
      },
    );
    on<FirstRunEvent>(
      (event, emit) {
        emit(SettingsState(
          appLanguage: state.appLanguage,
          appTheme: state.appTheme,
          font: state.font,
          isFirstRun: false,
          sendCrashReports: state.sendCrashReports,
        ));
        settingsRepository.setIsFirstRun(false);
      },
    );
    on<SendCrashReportsEvent>(
      (event, emit) {
        emit(SettingsState(
          appLanguage: state.appLanguage,
          appTheme: state.appTheme,
          font: state.font,
          isFirstRun: state.isFirstRun,
          sendCrashReports: event.sendCrashReports,
        ));
        settingsRepository.setSendCrashReports(state.sendCrashReports);
      },
    );
  }

  final SettingsRepository settingsRepository;
}

class SettingsState {
  final Locale appLanguage;
  final ThemeMode appTheme;
  final bool isFirstRun;
  final String font;
  final bool sendCrashReports;

  SettingsState(
      {required this.appLanguage,
      required this.appTheme,
      required this.isFirstRun,
      required this.font,
      required this.sendCrashReports});
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

class SendCrashReportsEvent extends SettingsEvent {
  final bool sendCrashReports;
  SendCrashReportsEvent(this.sendCrashReports);
}
