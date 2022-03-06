import 'package:flutter/material.dart';
import 'package:iathan/modules/prayer_times/ui_components/common_card_header.dart';

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
          Text(
            "Fajr",
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 16),
          Text(
            "in",
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 16),
          Text(
            "1:00:00",
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 16),
          Text(
            "6:00 am",
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
