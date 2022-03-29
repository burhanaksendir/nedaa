import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nedaa/modules/settings/models/calcualtiom_method.dart';
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
          ),
        ) {
    on<UserLocationEvent>(
      (event, emit) {
        emit(UserSettingsState(
          location: event.location,
          calculationMethod: state.calculationMethod,
          keepUpdatingLocation: state.keepUpdatingLocation,
        ));
        settingsRepository.setUserLocation(event.location);
      },
    );
    on<CalculationMethodEvent>((event, emit) {
      emit(
        UserSettingsState(
          location: state.location,
          calculationMethod: event.calculationMethod,
          keepUpdatingLocation: state.keepUpdatingLocation,
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
        ),
      );
      settingsRepository.setNotificationSettings(state.notificationSettings);
    });
  }

  final SettingsRepository settingsRepository;
}

class UserSettingsState {
  final UserLocation? location;
  final CalculationMethod? calculationMethod;
  final bool? keepUpdatingLocation;
  final Map<PrayerType, NotificationSettings> notificationSettings;

  UserSettingsState(
      {this.location,
      this.calculationMethod,
      this.keepUpdatingLocation,
      this.notificationSettings = const {}});
}

class UserSettingsEvent {}

class UserLocationEvent extends UserSettingsEvent {
  final UserLocation location;

  UserLocationEvent(this.location);
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
  final NotificationSettings notificationSettings;
  final PrayerType prayerType;

  PrayerNotificationEvent(this.prayerType, this.notificationSettings);
}
