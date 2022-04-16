import 'package:intl/intl.dart';
import 'package:nedaa/modules/settings/models/calcualtion_method.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:timezone/standalone.dart' as tz;

class DayPrayerTimes {
  final Map<PrayerType, DateTime> prayerTimes;
  final DateTime date;
  final CalculationMethod calculationMethod;
  final String timeZoneName;
  // TODO: add hijri date

  DayPrayerTimes(
      this.prayerTimes, this.timeZoneName, this.date, this.calculationMethod);

  factory DayPrayerTimes.fromJson(Map<String, dynamic> json) {
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

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'prayerTimes': prayerTimes,
      'date': date,
      'calculationMethod': calculationMethod,
    };
  }
}

class PrayerTime {
  final DateTime time;
  final String timeZoneName;
  final PrayerType prayerType;

  PrayerTime(this.time, this.timeZoneName, this.prayerType);

  DateTime get timezonedTime =>
      tz.TZDateTime.from(time, tz.getLocation(timeZoneName));
}
