import 'package:nedaa/modules/settings/models/prayer_type.dart';

class DayPrayerTimes {
  final Map<PrayerType, DateTime> prayerTimes;
  final DateTime date;
  // TODO: add hijri date


  DayPrayerTimes(this.prayerTimes, this.date);
}
