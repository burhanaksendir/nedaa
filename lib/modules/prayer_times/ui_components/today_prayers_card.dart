import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:nedaa/utils/arabic_digits.dart';
import 'package:nedaa/utils/helper.dart';
import 'package:nedaa/widgets/prayer_times_card.dart';
import 'common_card_header.dart';
import 'package:timezone/standalone.dart' as tz;

const timerDelay = Duration(seconds: 5);

class DurationMessage {
  String message;
  PrayerType prayerType;

  DurationMessage(this.message, this.prayerType);
}

class TodayPrayersCard extends StatefulWidget {
  const TodayPrayersCard({Key? key}) : super(key: key);

  @override
  State<TodayPrayersCard> createState() => _TodayPrayersCardState();
}

class _TodayPrayersCardState extends State<TodayPrayersCard> {
  DurationMessage? durationMessage;
  Timer? toggleReturnTimer;

  @override
  void dispose() {
    toggleReturnTimer?.cancel();
    super.dispose();
  }

  String getPrayerTranslation(
      BuildContext context, PrayerType prayerType, tz.TZDateTime prayerTime) {
    var t = AppLocalizations.of(context);

    var prayersTranslation = {
      PrayerType.fajr: t!.fajr,
      PrayerType.sunrise: t.sunrise,
      PrayerType.duhur: duhurOrJumuah(prayerTime.weekday, t),
      PrayerType.asr: t.asr,
      PrayerType.maghrib: t.maghrib,
      PrayerType.isha: t.isha,
    };

    return prayersTranslation[prayerType]!;
  }

  Widget _buildPrayerRow(BuildContext context, PrayerType prayerType,
      tz.TZDateTime prayerTime, bool showPrevious,
      [PrayerTime? previousPrayerTime]) {
    var t = AppLocalizations.of(context);
    var formatted = DateFormat("hh:mm a", t!.localeName);

    String displayMessage;
    if (durationMessage != null && durationMessage!.prayerType == prayerType) {
      displayMessage = durationMessage!.message;
    } else {
      displayMessage = formatted.format(prayerTime);
    }

    var fontSize = MediaQuery.of(context).size.width > 600 ? 16.0 : 14.0;

    return GestureDetector(
      onTap: () {
        toggleReturnTimer?.cancel();

        toggleReturnTimer = Timer(timerDelay, () {
          setState(() {
            durationMessage = null;
          });
        });

        var now = getCurrentTimeWithTimeZone(prayerTime.location.toString());
        var duration = showPrevious
            ? now.difference(previousPrayerTime!.time)
            : prayerTime.difference(now);
        var keyword = showPrevious ? t.since : t.inTime;
        setState(() {
          durationMessage = DurationMessage(
            "$keyword ${_formatDuration(duration, t.localeName)}",
            prayerType,
          );
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            getPrayerTranslation(context, prayerType, prayerTime),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            displayMessage,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var prayerState = context.watch<PrayerTimesBloc>().state;
    var t = AppLocalizations.of(context);

    var columnChildren = <Widget>[const CommonCardHeader()];

    if (prayerState.todayPrayerTimes != null &&
        prayerState.tomorrowPrayerTimes != null &&
        prayerState.yesterdayPrayerTimes != null) {
      var todayPrayerTimes = prayerState.todayPrayerTimes!;
      var tomorrowPrayerTimes = prayerState.tomorrowPrayerTimes!;

      var previousPrayer = getPreviousPrayer(
          todayPrayerTimes, prayerState.yesterdayPrayerTimes!);

      tz.Location? location;
      for (var prayerType in PrayerType.values) {
        location ??= tz.getLocation(todayPrayerTimes.timeZoneName);

        var now = getCurrentTimeWithTimeZone(todayPrayerTimes.timeZoneName);

        var prayerTime = tz.TZDateTime.from(
          todayPrayerTimes.prayerTimes[prayerType] ?? DateTime.now(),
          location,
        );

        var showPrevious = prayerType == previousPrayer.prayerType;

        if (showPrevious) {
          prayerTime = previousPrayer.timezonedTime;
        } else {
          if (prayerTime.isBefore(now)) {
            prayerTime = tz.TZDateTime.from(
              tomorrowPrayerTimes.prayerTimes[prayerType] ?? DateTime.now(),
              location,
            );
          }
        }

        columnChildren.add(
          _buildPrayerRow(
            context,
            prayerType,
            prayerTime,
            showPrevious,
            showPrevious ? previousPrayer : null,
          ),
        );
      }
    } else {
      columnChildren.add(Text(t!.noPrayersTimesFound));
    }

    return PrayerTimesCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: columnChildren,
      ),
    );
  }
}

String _formatDuration(Duration duration, String localeName) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  var baseDuration =
      "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  if (localeName.startsWith("ar")) {
    return translateToArabicDigits(baseDuration);
  } else {
    return baseDuration;
  }
}
