import 'package:intl/intl.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';

class DayPrayerTimes {
  final Map<PrayerType, DateTime> prayerTimes;
  final DateTime date;
  // TODO: add hijri date

  DayPrayerTimes(this.prayerTimes, this.date);

  factory DayPrayerTimes.fromJson(Map<String, dynamic> json) {
    var prayerTimes = <PrayerType, DateTime>{};

    Map<String, dynamic> prayerTimesJson = json['timings'];
    apiNames.forEach((prayerType, prayerName) {
      prayerTimes[prayerType] =
          DateTime.parse(prayerTimesJson[prayerName].split(' ')[0]);
    });
    return DayPrayerTimes(
      prayerTimes,
      DateFormat('dd-MM-yyyy').parse(json['date']['gregorian']['date']),
    );
  }
}
