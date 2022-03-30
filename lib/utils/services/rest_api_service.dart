import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nedaa/constants/api_path.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';

dynamic _parseApiResponse(Map<String, dynamic> response) {
  if (response['code'] == 200 && response['data'] is List) {
    var all_days = response['data'].map((day) => DayPrayerTimes.fromJson(day));
    // TODO: handle all days data
    return;
  }

  throw Exception('Failed to parse post');
}

Future<http.Response> getPrayerTimes(String getParams) async {
  var response = await http.get(Uri.parse(getCalendar + '/?' + getParams));
  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    _parseApiResponse(map);
    return response;
  } else {
    throw Exception('Failed to get prayer times');
  }
}

Future<http.Response> getPrayerTimesByCity(String getParams) async {
  var response =
      await http.get(Uri.parse(getCalendarByCity + '/?' + getParams));

  if (response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    _parseApiResponse(map);
    return response;
  } else {
    throw Exception('Failed to get prayer times');
  }
}
