import 'package:intl/intl.dart';
import 'package:nedaa/modules/settings/models/calculation_method.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:nedaa/utils/helper.dart';
import 'package:timezone/standalone.dart' as tz;

Map<String, String> _prayerTimesMapToJson(
    Map<PrayerType, DateTime> prayerTimes) {
  final Map<String, String> json = {};
  prayerTimes.forEach((key, value) {
    json[apiNames[key]!] = value.toIso8601String();
  });
  return json;
}

Map<PrayerType, DateTime> _prayerTimesMapFromJson(Map<String, dynamic> json) {
  final Map<PrayerType, DateTime> prayerTimes = {};
  apiNames.forEach((prayerType, prayerName) {
    prayerTimes[prayerType] = DateTime.parse(json[prayerName]!);
  });
  return prayerTimes;
}

class DayPrayerTimes {
  final Map<PrayerType, DateTime> prayerTimes;
  final DateTime date;
  final CalculationMethod calculationMethod;
  final String timeZoneName;
  // TODO: add hijri date

  DayPrayerTimes(
      this.prayerTimes, this.timeZoneName, this.date, this.calculationMethod);

  factory DayPrayerTimes.fromAPIJson(Map<String, dynamic> json) {
    var prayerTimes = <PrayerType, DateTime>{};

    Map<String, dynamic> prayerTimesJson = json['timings'];
    apiNames.forEach((prayerType, prayerName) {
      prayerTimes[prayerType] =
          DateTime.parse(prayerTimesJson[prayerName].split(' ')[0]);
    });
    var date =
        DateFormat('dd-MM-yyyy').parse(json['date']['gregorian']['date']);
    var calculationMethodId = json['meta']['method']['id'];
    var calculationMethod = CalculationMethod(calculationMethodId);

    var timezone = json['meta']['timezone'];

    return DayPrayerTimes(prayerTimes, timezone, date, calculationMethod);
  }

  factory DayPrayerTimes.fromJson(Map<String, dynamic> json) {
    var prayerTimes = _prayerTimesMapFromJson(json['prayerTimes']);
    var date = DateTime.parse(json['date']);
    var calculationMethodId = json['calculationMethod'];
    var calculationMethod = CalculationMethod(calculationMethodId);
    var timezone = json['timezone'];
    return DayPrayerTimes(prayerTimes, timezone, date, calculationMethod);
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'prayerTimes': _prayerTimesMapToJson(prayerTimes),
      'date': date.toIso8601String(),
      'calculationMethod': calculationMethod.index,
      'timezone': timeZoneName,
    };
  }
}

class PrayerTime {
  final DateTime time;
  final String timeZoneName;
  final PrayerType prayerType;

  PrayerTime(this.time, this.timeZoneName, this.prayerType);

  tz.TZDateTime get timezonedTime => getDateWithTimeZone(timeZoneName, time);
}
