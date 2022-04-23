import 'package:geocoding/geocoding.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/models/calcualtion_method.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:timezone/standalone.dart' as tz;
import 'dart:async';
import 'dart:io';

String generateParams(Location location, CalculationMethod method) {
  var _calculationMethod = method.index != -1 ? '&method=${method.index}' : '';
  return 'iso8601=true&latitude=${location.latitude}&longitude=${location.longitude}$_calculationMethod';
}

String generateCityParams(
    String conutry, String city, CalculationMethod method) {
  var _calculationMethod = method.index != -1 ? '&methoud=${method.index}' : '';
  return 'iso8601=true&city=$city&country=$conutry$_calculationMethod';
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

tz.TZDateTime getDateWithTimeZone(String timeZoneName, DateTime date) =>
    tz.TZDateTime.from(date, tz.getLocation(timeZoneName));

tz.TZDateTime getCurrentTimeWithTimeZone(String timeZoneName) =>
    tz.TZDateTime.now(tz.getLocation(timeZoneName));

Future<bool> hasInternetConnection() async {
  bool? _isConnectionSuccessful;
  try {
    final response = await InternetAddress.lookup('www.google.com');

    _isConnectionSuccessful = response.isNotEmpty;
  } on SocketException catch (_) {
    _isConnectionSuccessful = false;
  }
  return _isConnectionSuccessful;
}

