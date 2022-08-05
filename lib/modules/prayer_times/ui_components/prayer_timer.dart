import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:nedaa/utils/arabic_digits.dart';
import 'package:nedaa/utils/timer.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'dart:ui' as ui;

const timerDelay = Duration(seconds: 20);

class PrayerTimer extends StatefulWidget {
  const PrayerTimer({Key? key}) : super(key: key);

  @override
  State<PrayerTimer> createState() => _PrayerTimerState();
}

class _PrayerTimerState extends State<PrayerTimer> {
  bool toggled = false;
  Timer? toggleReturnTimer;

  @override
  void dispose() {
    toggleReturnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    var prayerTimesState = context.watch<PrayerTimesBloc>().state;

    PreviousNextTimerState? allTimerState = getTimerState(prayerTimesState);
    TimerState? timerState;

    if (allTimerState != null) {
      var defaultToShowPrevious =
          allTimerState.previous.timerDuration.inMinutes <= 30;

      // toggle the default view if `toggled` is true.
      var shouldShowPrevious = defaultToShowPrevious ^ toggled;

      if (shouldShowPrevious) {
        timerState = allTimerState.previous;
      } else {
        timerState = allTimerState.next;
      }
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

    return GestureDetector(
        onTap: () {
          toggleReturnTimer?.cancel();

          toggleReturnTimer = Timer(timerDelay, () {
            setState(() {
              toggled = false;
            });
          });

          setState(() {
            toggled = !toggled;
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Text(
                prayersTranslation[timerState?.prayerType ?? PrayerType.fajr]!,
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                (timerState?.shouldCountUp ?? false) ? t.since : t.inTime,
                style: Theme.of(context).textTheme.headline5,
              ),
              (timerState == null)
                  ? Container()
                  // TODO: Replace with our own counter?
                  : SlideCountdown(
                      duration: timerState.timerDuration,
                      textStyle: Theme.of(context).textTheme.headline5 ??
                          const TextStyle(color: Colors.black),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      digitsNumber: t.localeName == 'ar' ? arabicDigits : null,
                      countUp: timerState.shouldCountUp,
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
                formatted.format(timerState?.timezonedTime ?? DateTime.now()),
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ));
  }
}
