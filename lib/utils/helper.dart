import 'package:geocoding/geocoding.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/models/calcualtion_method.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:timezone/standalone.dart' as tz;
import 'dart:async';
import 'dart:io';

String generateParams(Location location, CalculationMethod method, int? year,
    {bool annual = true}) {
  // TODO: add timezone
  var selectedYear = year ?? DateTime.now().year;
  var calculationMethod = method.index != -1 ? '&method=${method.index}' : '';
  return 'year=$selectedYear&annual=$annual&iso8601=true&latitude=${location.latitude}&longitude=${location.longitude}$calculationMethod';
}

DayPrayerTimes getTodaysTimings(List<DayPrayerTimes> allDays) {
  var today = getCurrentTimeWithTimeZone(allDays.first.timeZoneName);
  return allDays.firstWhere(
      (day) =>
          day.date.day == today.day &&
          day.date.month == today.month &&
          day.date.year == today.year,
      // TODO: add special exception to refetch data if not found
      orElse: () => throw Exception("No data found"));
}

DayPrayerTimes getNextDayTimings(List<DayPrayerTimes> allDays) {
  var today = getCurrentTimeWithTimeZone(allDays.first.timeZoneName);
  var nextDay = today.add(const Duration(days: 1));
  return allDays.firstWhere((day) =>
      day.date.day == nextDay.day &&
      day.date.month == nextDay.month &&
      day.date.year == nextDay.year);
}

DayPrayerTimes getPreviousDayTimings(List<DayPrayerTimes> allDays) {
  var today = getCurrentTimeWithTimeZone(allDays.first.timeZoneName);
  var previousDay = today.subtract(const Duration(days: 1));
  return allDays.firstWhere((day) =>
      day.date.day == previousDay.day &&
      day.date.month == previousDay.month &&
      day.date.year == previousDay.year);
}

PrayerTime getNextPrayer(
    DayPrayerTimes todayPrayerTimes, DayPrayerTimes tomorrowPrayerTimes) {
  var now = getCurrentTimeWithTimeZone(todayPrayerTimes.timeZoneName);

  var nextPrayer = PrayerType.values
      .map((prayerType) => PrayerTime(
            todayPrayerTimes.prayerTimes[prayerType] ?? now,
            todayPrayerTimes.timeZoneName,
            prayerType,
          ))
      .firstWhere(
    (prayerTime) {
      // if (prayerType == PrayerType.sunrise) return false;

      var tzPrayerTime =
          getDateWithTimeZone(todayPrayerTimes.timeZoneName, prayerTime.time);

      return tzPrayerTime.isAfter(now);
    },
    orElse: () {
      return PrayerTime(
        tomorrowPrayerTimes.prayerTimes[PrayerType.fajr] ?? now,
        tomorrowPrayerTimes.timeZoneName,
        PrayerType.fajr,
      );
    },
  );

  return nextPrayer;
}

PrayerTime getPreviousPrayer(
    DayPrayerTimes todayPrayerTimes, DayPrayerTimes yesterdayPrayerTimes) {
  var now = getCurrentTimeWithTimeZone(todayPrayerTimes.timeZoneName);

  var nextPrayer = PrayerType.values.reversed
      .map((prayerType) => PrayerTime(
            todayPrayerTimes.prayerTimes[prayerType] ?? now,
            todayPrayerTimes.timeZoneName,
            prayerType,
          ))
      .firstWhere(
    (prayerTime) {
      // if (prayerType == PrayerType.sunrise) return false;

      var tzPrayerTime =
          getDateWithTimeZone(todayPrayerTimes.timeZoneName, prayerTime.time);

      return tzPrayerTime.isBefore(now);
    },
    orElse: () {
      return PrayerTime(
        yesterdayPrayerTimes.prayerTimes[PrayerType.isha] ?? now,
        yesterdayPrayerTimes.timeZoneName,
        PrayerType.isha,
      );
    },
  );

  return nextPrayer;
}

tz.TZDateTime getDateWithTimeZone(String timeZoneName, DateTime date) =>
    tz.TZDateTime.from(date, tz.getLocation(timeZoneName));

tz.TZDateTime getCurrentTimeWithTimeZone(String timeZoneName) =>
    tz.TZDateTime.now(tz.getLocation(timeZoneName));

Future<bool> hasInternetConnection() async {
  bool? isConnectionSuccessful;
  try {
    final response = await InternetAddress.lookup('www.google.com');

    isConnectionSuccessful = response.isNotEmpty;
  } on SocketException catch (_) {
    isConnectionSuccessful = false;
  }
  return isConnectionSuccessful;
}
