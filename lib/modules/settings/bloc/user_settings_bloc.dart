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
          ),
        ) {
    on<UserLocationEvent>(
      (event, emit) {
        emit(UserSettingsState(
          location: event.location,
          calculationMethod: state.calculationMethod,
        ));
        settingsRepository.setUserLocation(event.location);
      },
    );
    on<CalculationMethodEvent>((event, emit) {
      emit(
        UserSettingsState(
          location: state.location,
          calculationMethod: event.calculationMethod,
        ),
      );
      settingsRepository.setCalculationMethod(event.calculationMethod);
    });
  }

  final SettingsRepository settingsRepository;
}

class UserSettingsState {
  final UserLocation? location;
  final CalculationMethod? calculationMethod;

  UserSettingsState({this.location, this.calculationMethod});
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
