import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iathan/modules/settings/models/calcualtiom_method.dart';
import 'package:iathan/modules/settings/models/user_location.dart';
import 'package:iathan/modules/settings/repositories/settings_repository.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  UserSettingsBloc(this.settingsRepository)
      : super(
          UserSettingsState(
            location: settingsRepository.getUserLocation(),
            calculationMethod: settingsRepository.getCalculationMethod(),
            keepUpdatingLocation: settingsRepository.getKeepUpdatingLocation(),
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
  }

  final SettingsRepository settingsRepository;
}

class UserSettingsState {
  final UserLocation? location;
  final CalculationMethod? calculationMethod;
  final bool? keepUpdatingLocation;

  UserSettingsState(
      {this.location, this.calculationMethod, this.keepUpdatingLocation});
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
