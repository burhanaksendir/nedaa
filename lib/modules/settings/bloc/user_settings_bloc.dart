import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iathan/modules/settings/models/calcualtiom_method.dart';
import 'package:iathan/modules/settings/models/user_location.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  UserSettingsBloc() : super(UserSettingsState()) {
    on<UserLocationEvent>((event, emit) => emit(UserSettingsState(
        location: event.location, calculationMethod: state.calculationMethod)));
    on<CalculationMethodEvent>((event, emit) => emit(UserSettingsState(
        location: state.location, calculationMethod: event.calculationMethod)));
  }
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
