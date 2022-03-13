import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iathan/modules/settings/screens/bloc/settings_event.dart';
import 'package:iathan/modules/settings/screens/bloc/settings_state.dart';
import 'package:intl/intl.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(SettingsState(
            appLanguage: Locale(Intl.getCurrentLocale().split("_")[0]),
            appTheme: ThemeMode.system)) {
    on<LanguageEvent>((event, emit) => emit(SettingsState(
        appLanguage: event.appLanguage, appTheme: state.appTheme)));
    on<ThemeEvent>((event, emit) => emit(
        SettingsState(appTheme: event.theme, appLanguage: state.appLanguage)));
  }
}
