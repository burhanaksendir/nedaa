import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:nedaa/utils/helper.dart';
import 'package:nedaa/widgets/prayer_times_card.dart';
import 'common_card_header.dart';
import 'package:timezone/standalone.dart' as tz;

class TodayPrayersCard extends StatefulWidget {
  const TodayPrayersCard({Key? key}) : super(key: key);

  @override
  State<TodayPrayersCard> createState() => _TodayPrayersCardState();
}

class _TodayPrayersCardState extends State<TodayPrayersCard> {
  Widget _buildPrayerRow(BuildContext context, String prayerName,
      tz.TZDateTime prayerTime, bool showPrevious,
      [PrayerTime? previousPrayerTime]) {
    var t = AppLocalizations.of(context);
    var formatted = DateFormat("hh:mm a", t!.localeName);
    var formattedTime = formatted.format(prayerTime);
    return GestureDetector(
      onTap: () {
        var now = getCurrentTimeWithTimeZone(prayerTime.location.toString());
        var duration = showPrevious
            ? now.difference(previousPrayerTime!.time)
            : prayerTime.difference(now);
        var keyword = showPrevious ? t.since : t.until;
        MotionToast(
          backgroundType: BACKGROUND_TYPE.lighter,
          primaryColor: Theme.of(context).primaryColorLight,
          icon: Icons.info,
          position: MOTION_TOAST_POSITION.center,
          description: Text(
            '$prayerName : $keyword ${duration.inHours}:${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}',
            style: const TextStyle(color: Colors.black),
          ),
          toastDuration: const Duration(seconds: 5),
          dismissable: true,
        ).show(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            prayerName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            formattedTime,
            style: const TextStyle(
              fontSize: 16,
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

    var prayersTranslation = {
      PrayerType.fajr: t!.fajr,
      PrayerType.sunrise: t.sunrise,
      PrayerType.duhur: t.duhur,
      PrayerType.asr: t.asr,
      PrayerType.maghrib: t.maghrib,
      PrayerType.isha: t.isha,
    };

    if (prayerState.todayPrayerTimes != null &&
        prayerState.tomorrowPrayerTimes != null &&
        prayerState.yesterdayPrayerTimes != null) {
      var todayPrayerTimes = prayerState.todayPrayerTimes!;
      var tomorrowPrayerTimes = prayerState.tomorrowPrayerTimes!;

      var previousPrayer = getPreviousPrayer(
          todayPrayerTimes, prayerState.yesterdayPrayerTimes!);

      tz.Location? location;
      prayersTranslation.forEach((key, value) {
        location ??= tz.getLocation(todayPrayerTimes.timeZoneName);

        var now = getCurrentTimeWithTimeZone(todayPrayerTimes.timeZoneName);

        var prayerTime = tz.TZDateTime.from(
          todayPrayerTimes.prayerTimes[key] ?? DateTime.now(),
          location!,
        );

        var showPrevious = key == previousPrayer.prayerType;

        if (showPrevious) {
          prayerTime = tz.TZDateTime.from(
            tomorrowPrayerTimes.prayerTimes[key] ?? DateTime.now(),
            location!,
          );
        } else {
          if (prayerTime.isBefore(now)) {
            prayerTime = tz.TZDateTime.from(
              tomorrowPrayerTimes.prayerTimes[key] ?? DateTime.now(),
              location!,
            );
          }
        }

        columnChildren.add(
          _buildPrayerRow(
            context,
            value,
            prayerTime,
            showPrevious,
            showPrevious ? previousPrayer : null,
          ),
        );
      });
    } else {
      columnChildren.add(Text(t.noPrayersTimesFound));
    }

    return PrayerTimesCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: columnChildren,
      ),
    );
  }
}
