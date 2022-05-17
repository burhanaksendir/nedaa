import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/models/calcualtion_method.dart';
import 'package:nedaa/modules/settings/models/user_location.dart';
import 'package:nedaa/utils/helper.dart';
import 'package:nedaa/utils/services/rest_api_service.dart';
import 'package:timezone/timezone.dart';

class CurrentPrayerTimesState {
  DayPrayerTimes today;
  DayPrayerTimes tomorrow;

  CurrentPrayerTimesState(this.today, this.tomorrow);
}

class CachedPrayerTimesState {
  CurrentPrayerTimesState state;
  TZDateTime cacheDate;
  UserLocation location;
  CalculationMethod method;

  CachedPrayerTimesState(
    this.state,
    this.cacheDate,
    this.location,
    this.method,
  );
}

class PrayerTimesRepository {
  CachedPrayerTimesState? cache;

  /// use `newRepo` to create a new repo
  PrayerTimesRepository._();

  static Future<PrayerTimesRepository> newRepo(
    UserLocation location,
    CalculationMethod method,
  ) async {
    var repo = PrayerTimesRepository._();

    if ((location.location != null) ||
        (location.country != null && location.city != null)) {
      await repo.getCurrentPrayerTimesState(location, method);
    }
    return repo;
  }

  Future<CurrentPrayerTimesState> getCurrentPrayerTimesState(
    UserLocation location,
    CalculationMethod method,
  ) async {
    if (cache != null) {
      var cache = this.cache!;
      var todayDate =
          getCurrentTimeWithTimeZone(cache.state.today.timeZoneName);
      if (todayDate.year == cache.cacheDate.year &&
          todayDate.month == cache.cacheDate.month &&
          todayDate.day == cache.cacheDate.day &&
          method.index == cache.method.index &&
          location == cache.location) {
        return cache.state;
      }
    }

    List<DayPrayerTimes> monthData;
    if (location.location != null) {
      monthData = await getPrayerTimes(location.location!, method);
    } else if (location.country != null && location.city != null) {
      monthData =
          await getPrayerTimesByCity(location.country!, location.city!, method);
    } else {
      throw Exception('No location provided');
    }
    var todayPrayerTimes = getTodaysTimings(monthData);
    // TODO: fix tomorrow prayer times overflow
    var tomorrowPrayerTimes = getNextDayTimings(monthData);

    var state = CurrentPrayerTimesState(todayPrayerTimes, tomorrowPrayerTimes);

    cache = CachedPrayerTimesState(state,
        getCurrentTimeWithTimeZone(state.today.timeZoneName), location, method);

    return state;
  }
}
