import 'package:flutter/material.dart';
import 'package:iathan/modules/prayer_times/ui_components/main_prayer_card.dart';
import 'package:iathan/modules/prayer_times/ui_components/today_prayers_card.dart';
import 'package:page_view_indicators/animated_circle_page_indicator.dart';

class PrayerTimes extends StatefulWidget {
  const PrayerTimes({Key? key}) : super(key: key);

  @override
  State<PrayerTimes> createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const MainPrayerCard();
                case 1:
                  return const TodayPrayersCard();
                default:
                  throw Exception('Invalid index');
              }
            },
            itemCount: 2,
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AnimatedCirclePageIndicator(
            itemCount: 2,
            currentPageNotifier: _currentPageNotifier,
            borderWidth: 1,
            spacing: 6,
            radius: 8,
            activeRadius: 6,
            borderColor: Colors.black,
            fillColor: Colors.white,
            activeColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
