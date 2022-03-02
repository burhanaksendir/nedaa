import 'package:flutter/material.dart';
import 'package:iathan/widgets/prayer_times_card.dart';

class PrayerTimes extends StatefulWidget {
  const PrayerTimes({Key? key}) : super(key: key);

  @override
  State<PrayerTimes> createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return PrayerTimesCard(
                    child: Column(
                      children: [
                        Text(
                          "Monday\n02 February 2022",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Kuala Lumpur",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const Divider(
                          thickness: 1,
                          height: 108,
                          color: Colors.black,
                        ),
                        Text(
                          "Fajr",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "in",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "1:00:00",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "6:00 am",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  );
                case 1:
                  return PrayerTimesCard(
                    child: Container(
                      color: Colors.green,
                    ),
                  );
                default:
                  throw Exception('Invalid index');
              }
            },
            itemCount: 2,
          ),
        ),
        // TODO: add page indicator
      ],
    );
  }
}
