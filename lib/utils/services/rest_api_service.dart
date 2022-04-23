import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:nedaa/constants/api_path.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/models/calcualtion_method.dart';
import 'package:nedaa/utils/helper.dart';

List<DayPrayerTimes> _parseApiResponse(Map<String, dynamic> response) {
  if (response['code'] == 200 && response['data'] is List<dynamic>) {
    var allDays = (response['data'] as List<dynamic>)
        .map((day) => DayPrayerTimes.fromJson(day))
        .toList();
    return allDays;
  }

  throw Exception('Failed to parse post');
}

Future<List<DayPrayerTimes>> getPrayerTimes(
    Location location, CalculationMethod calculationMethod) async {
  var response = await http.get(Uri.parse(
      getCalendar + '/?' + generateParams(location, calculationMethod)));
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    return _parseApiResponse(map);
  } else {
    return Future.error('An error occurd while get prayer times');
  }
}

Future<List<DayPrayerTimes>> getPrayerTimesByCity(
    String country, String city, CalculationMethod calculationMethod) async {

    var response = await http.get(Uri.parse(getCalendarByCity +
        '/?' +
        generateCityParams(country, city, calculationMethod)));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      return _parseApiResponse(map);
    } else {
      return Future.error('An error occurd while get prayer times');
    }
  }

