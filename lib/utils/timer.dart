import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:nedaa/utils/helper.dart';

class PreviousNextTimerState {
  TimerState previous;
  TimerState next;

  PreviousNextTimerState(this.previous, this.next);
}

class TimerState {
  DateTime timezonedTime;
  PrayerType prayerType;
  Duration timerDuration;
  bool shouldCountUp;

  TimerState(PrayerTime targetPrayer, this.timerDuration, this.shouldCountUp)
      : timezonedTime = targetPrayer.timezonedTime,
        prayerType = targetPrayer.prayerType;
}

PreviousNextTimerState? getTimerState(PrayerTimesState prayerTimesState) {
  if (prayerTimesState.todayPrayerTimes != null &&
      prayerTimesState.tomorrowPrayerTimes != null &&
      prayerTimesState.yesterdayPrayerTimes != null) {
    var previousPrayer = getPreviousPrayer(prayerTimesState.todayPrayerTimes!,
        prayerTimesState.yesterdayPrayerTimes!);

    var now = getCurrentTimeWithTimeZone(previousPrayer.timeZoneName);

    var difference = now.difference(previousPrayer.time);
    var previousTimerState = TimerState(previousPrayer, difference, true);

    var nextPrayer = getNextPrayer(prayerTimesState.todayPrayerTimes!,
        prayerTimesState.tomorrowPrayerTimes!);
    difference = nextPrayer.time.difference(now);
    var nextTimerState = TimerState(nextPrayer, difference, false);

    return PreviousNextTimerState(previousTimerState, nextTimerState);
  }

  return null;
}
