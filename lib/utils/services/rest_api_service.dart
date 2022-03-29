import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nedaa/constants/api_path.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';

dynamic _parseApiResponse(response) {
  // return DayPrayerTimes(
  // );
  return 1;
}

Future<http.Response> getPrayerTimes(String getParams) async {
  var response = await http.get(Uri.parse(getCalendar + '/?' + getParams));

  if (response.statusCode == 200) {
    _parseApiResponse(response);
    return response;
  } else {
    throw Exception('Failed to get prayer times');
  }
}

Future<http.Response> getPrayerTimesByCity(String getParams) async {
  var response =
      await http.get(Uri.parse(getCalendarByCity + '/?' + getParams));

  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to get prayer times');
  }
}
