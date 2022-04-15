import 'package:geocoding/geocoding.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/models/calcualtion_method.dart';

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
  var today = DateTime.now();
  return allDays.firstWhere(
      (day) =>
          day.date.day == today.day &&
          day.date.month == today.month &&
          day.date.year == today.year,
      // TODO: add special exception to refetch data if not found
      orElse: () => throw Exception("No data found"));
}
