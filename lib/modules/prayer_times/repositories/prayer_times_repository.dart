import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/models/calcualtion_method.dart';
import 'package:nedaa/modules/settings/models/user_location.dart';
import 'package:nedaa/utils/helper.dart';
import 'package:nedaa/utils/services/rest_api_service.dart';

class CurrentPrayerTimesState {
  DayPrayerTimes today;
  DayPrayerTimes tomorrow;

  CurrentPrayerTimesState(this.today, this.tomorrow);
}

class PrayerTimesRepository {
  Future<CurrentPrayerTimesState> getCurrentPrayerTimesState(
    UserLocation location,
    CalculationMethod method,
  ) async {
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

    return CurrentPrayerTimesState(todayPrayerTimes, tomorrowPrayerTimes);
  }
}
