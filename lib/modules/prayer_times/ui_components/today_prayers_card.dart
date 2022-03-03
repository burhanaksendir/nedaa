import 'package:flutter/material.dart';

import '../../../widgets/prayer_times_card.dart';
import 'common_card_header.dart';

class TodayPrayersCard extends StatefulWidget {
  const TodayPrayersCard({Key? key}) : super(key: key);

  @override
  State<TodayPrayersCard> createState() => _TodayPrayersCardState();
}

class _TodayPrayersCardState extends State<TodayPrayersCard> {
  Widget _buildPrayerRow(String prayerName, String prayerTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          prayerName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          prayerTime,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PrayerTimesCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CommonCardHeader(),
          // const SizedBox(height: 6),

          //TODO: Add Prayer Times
          _buildPrayerRow('Fajr', '5:00 AM'),
          _buildPrayerRow("Sunrise", "7:00 AM"),
          _buildPrayerRow('Dhuhr', '12:00 PM'),
          _buildPrayerRow('Asr', '3:00 PM'),
          _buildPrayerRow('Maghrib', '6:00 PM'),
          _buildPrayerRow('Isha', '9:00 PM'),
        ],
      ),
    );
  }
}
