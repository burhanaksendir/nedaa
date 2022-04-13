import 'package:intl/intl.dart';
import 'package:nedaa/modules/settings/models/calcualtiom_method.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';

class DayPrayerTimes {
  final Map<PrayerType, DateTime> prayerTimes;
  final DateTime date;
  final CalculationMethod calculationMethod;
  // TODO: add hijri date

  DayPrayerTimes(this.prayerTimes, this.date, this.calculationMethod);

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
    var calculationMethod = CalculationMethod(calculationMethodId, "");

    return DayPrayerTimes(prayerTimes, date, calculationMethod);
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
