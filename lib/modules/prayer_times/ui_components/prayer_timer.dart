import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:nedaa/utils/helper.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'dart:ui' as ui;

class PrayerTimer extends StatefulWidget {
  const PrayerTimer({Key? key}) : super(key: key);

  @override
  State<PrayerTimer> createState() => _PrayerTimerState();
}

class _PrayerTimerState extends State<PrayerTimer> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    var prayerTimesState = context.watch<PrayerTimesBloc>().state;
    PrayerTime? nextPrayer;

    if (prayerTimesState.todayPrayerTimes != null &&
        prayerTimesState.tomorrowPrayerTimes != null) {
      nextPrayer = getNextPrayer(
        prayerTimesState.todayPrayerTimes!,
        prayerTimesState.tomorrowPrayerTimes!,
      );
    }

    var prayersTranslation = {
      PrayerType.fajr: t!.fajr,
      PrayerType.sunrise: t.sunrise,
      PrayerType.duhur: t.duhur,
      PrayerType.asr: t.asr,
      PrayerType.maghrib: t.maghrib,
      PrayerType.isha: t.isha,
    };

    var formatted = DateFormat("hh:mm a", t.localeName);

    return Column(
      children: <Widget>[
        const SizedBox(height: 16),
        Text(
          prayersTranslation[nextPrayer?.prayerType ?? PrayerType.fajr]!,
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          t.inTime,
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 16),
        (nextPrayer == null)
            ? Container()
            // TODO: Replace with our own counter?
            : SlideCountdown(
                duration: nextPrayer.timezonedTime.difference(
                    getCurrentTimeWithTimeZone(nextPrayer.timeZoneName)),
                textStyle: Theme.of(context).textTheme.headline5 ??
                    const TextStyle(color: Colors.black),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                onDone: () {
                  setState(() {});
                },
                textDirection:
                    Directionality.of(context) == ui.TextDirection.ltr
                        ? ui.TextDirection.ltr
                        : ui.TextDirection.rtl,
              ),
        const SizedBox(height: 8),
        Text(
          formatted.format(nextPrayer?.timezonedTime ?? DateTime.now()),
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }
}
