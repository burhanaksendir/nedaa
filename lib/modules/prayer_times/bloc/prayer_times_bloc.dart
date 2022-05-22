import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/prayer_times/repositories/prayer_times_repository.dart';
import 'package:nedaa/modules/settings/models/calcualtion_method.dart';
import 'package:nedaa/modules/settings/models/user_location.dart';

class PrayerTimesBloc extends Bloc<PrayerTimesEvent, PrayerTimesState> {
  PrayerTimesBloc(this.prayerTimesRepository)
      : super(
          PrayerTimesState(),
        ) {
    on<FetchPrayerTimesEvent>((event, emit) async {
      try {
        var currentPrayerTimesState =
            await prayerTimesRepository.getCurrentPrayerTimesState(
          event.location,
          event.method,
        );
        emit(PrayerTimesState(
          todayPrayerTimes: currentPrayerTimesState.today,
          tomorrowPrayerTimes: currentPrayerTimesState.tomorrow,
          yesterdayPrayerTimes: currentPrayerTimesState.yesterday,
        ));
      } catch (e) {
        // TODO: use failed state to display error
        emit(FailedPrayerTimesState(
            "Failed to fetch prayer times: ${e.toString()}"));
      }
    });
  }

  final PrayerTimesRepository prayerTimesRepository;
}

class PrayerTimesState {
  DayPrayerTimes? todayPrayerTimes;
  DayPrayerTimes? tomorrowPrayerTimes;
  DayPrayerTimes? yesterdayPrayerTimes;

  PrayerTimesState(
      {this.todayPrayerTimes,
      this.tomorrowPrayerTimes,
      this.yesterdayPrayerTimes});
}

class FailedPrayerTimesState extends PrayerTimesState {
  String error;

  FailedPrayerTimesState(this.error) : super();
}

class PrayerTimesEvent {}

class FetchPrayerTimesEvent extends PrayerTimesEvent {
  UserLocation location;
  CalculationMethod method;

  FetchPrayerTimesEvent(this.location, this.method);
}
