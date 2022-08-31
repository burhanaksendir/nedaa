import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nedaa/modules/settings/models/calculation_method.dart';
import 'package:nedaa/modules/settings/models/notification_settings.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:nedaa/modules/settings/models/user_location.dart';
import 'package:nedaa/modules/settings/repositories/settings_repository.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  UserSettingsBloc(this.settingsRepository)
      : super(
          UserSettingsState(
            location: settingsRepository.getUserLocation(),
            calculationMethod: settingsRepository.getCalculationMethod(),
            keepUpdatingLocation: settingsRepository.getKeepUpdatingLocation(),
            notificationSettings: settingsRepository.getNotificationSettings(),
            timezone: settingsRepository.getTimezone(),
          ),
        ) {
    on<UserLocationEvent>(
      (event, emit) async {
        emit(UserSettingsState(
          location: event.location,
          calculationMethod: state.calculationMethod,
          keepUpdatingLocation: state.keepUpdatingLocation,
          notificationSettings: state.notificationSettings,
          timezone: event.timezone,
        ));
        settingsRepository.setTimezone(event.timezone);
        settingsRepository.setUserLocation(event.location);
      },
    );
    on<CalculationMethodEvent>((event, emit) {
      emit(
        UserSettingsState(
          location: state.location,
          calculationMethod: event.calculationMethod,
          keepUpdatingLocation: state.keepUpdatingLocation,
          notificationSettings: state.notificationSettings,
          timezone: state.timezone,
        ),
      );
      settingsRepository.setCalculationMethod(event.calculationMethod);
    });
    on<KeepUpdatingLocationEvent>((event, emit) {
      emit(
        UserSettingsState(
          location: state.location,
          calculationMethod: state.calculationMethod,
          keepUpdatingLocation: event.keepUpdating,
          notificationSettings: state.notificationSettings,
          timezone: state.timezone,
        ),
      );
      settingsRepository.setKeepUpdatingLocation(event.keepUpdating);
    });
    on<PrayerNotificationEvent>((event, emit) {
      state.notificationSettings[event.prayerType] = event.notificationSettings;
      emit(
        UserSettingsState(
          location: state.location,
          calculationMethod: state.calculationMethod,
          keepUpdatingLocation: state.keepUpdatingLocation,
          notificationSettings: state.notificationSettings,
          timezone: state.timezone,
        ),
      );
      settingsRepository.setNotificationSettings(state.notificationSettings);
    });
    //TODO: remove this
    on<ClearDataEvent>((event, emit) {
      emit(
        UserSettingsState(
          location: state.location,
          calculationMethod: state.calculationMethod,
          keepUpdatingLocation: state.keepUpdatingLocation,
          notificationSettings: state.notificationSettings,
          timezone: state.timezone,
        ),
      );
      settingsRepository.clear();
    });
  }

  final SettingsRepository settingsRepository;
}

class UserSettingsState {
  final UserLocation location;
  final CalculationMethod calculationMethod;
  final bool keepUpdatingLocation;
  final Map<PrayerType, PrayerNotificationSettings> notificationSettings;
  final String timezone;

  UserSettingsState({
    required this.timezone,
    required this.location,
    required this.calculationMethod,
    required this.keepUpdatingLocation,
    this.notificationSettings = const {},
  });
}

class UserSettingsEvent {}

class UserLocationEvent extends UserSettingsEvent {
  final UserLocation location;
  final String timezone;

  UserLocationEvent(this.location, this.timezone);
}

class CalculationMethodEvent extends UserSettingsEvent {
  final CalculationMethod calculationMethod;

  CalculationMethodEvent(this.calculationMethod);
}

class KeepUpdatingLocationEvent extends UserSettingsEvent {
  final bool keepUpdating;

  KeepUpdatingLocationEvent(this.keepUpdating);
}

class PrayerNotificationEvent extends UserSettingsEvent {
  final PrayerNotificationSettings notificationSettings;
  final PrayerType prayerType;

  PrayerNotificationEvent(this.prayerType, this.notificationSettings);
}

class TimezoneEvent extends UserSettingsEvent {
  final String timezone;

  TimezoneEvent(this.timezone);
}

//TODO: remove this snippet after testing
class ClearDataEvent extends UserSettingsEvent {
  ClearDataEvent();
}
