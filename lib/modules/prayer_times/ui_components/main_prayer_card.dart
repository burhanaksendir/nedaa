import 'package:flutter/material.dart';
import 'package:iathan/modules/prayer_times/ui_components/common_card_header.dart';
import 'package:iathan/modules/prayer_times/ui_components/prayer_timer.dart';

import '../../../widgets/prayer_times_card.dart';

class MainPrayerCard extends StatefulWidget {
  const MainPrayerCard({Key? key}) : super(key: key);

  @override
  State<MainPrayerCard> createState() => _MainPrayerCardState();
}

class _MainPrayerCardState extends State<MainPrayerCard> {
  @override
  Widget build(BuildContext context) {
    return PrayerTimesCard(
      child: Column(
        children: [
          const CommonCardHeader(),
          PrayerTimer(),
        ],
      ),
    );
  }
}
