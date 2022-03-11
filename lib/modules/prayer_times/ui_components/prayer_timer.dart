import 'package:flutter/material.dart';

class PrayerTimer extends StatefulWidget {
  const PrayerTimer({Key? key}) : super(key: key);

  @override
  State<PrayerTimer> createState() => _PrayerTimerState();
}

class _PrayerTimerState extends State<PrayerTimer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
    );
  }
}
