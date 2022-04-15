import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
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
    var prayerTimes = context.watch<PrayerTimesBloc>().state.prayerTimes;
    var t = AppLocalizations.of(context);

    var columnChildren = <Widget>[const CommonCardHeader()];
    var formatted = DateFormat("hh:mm a");

    var prayersTranslation = {
      PrayerType.fajr: t!.fajr,
      PrayerType.sunrise: t.sunrise,
      PrayerType.duhur: t.duhur,
      PrayerType.asr: t.asr,
      PrayerType.maghrib: t.maghrib,
      PrayerType.isha: t.isha,
    };

    if (prayerTimes != null) {
      prayersTranslation.forEach((key, value) {
        columnChildren.add(
          _buildPrayerRow(
            value,
            // TODO: use user timezone
            formatted.format(
              prayerTimes.prayerTimes[key]?.toLocal() ?? DateTime.now(),
            ),
          ),
        );
      });
    } else {
      columnChildren.addAll([
        _buildPrayerRow(t.fajr, '5:00 AM'),
        _buildPrayerRow(t.sunrise, "7:00 AM"),
        _buildPrayerRow(t.duhur, '12:00 PM'),
        _buildPrayerRow(t.asr, '3:00 PM'),
        _buildPrayerRow(t.maghrib, '6:00 PM'),
        _buildPrayerRow(t.isha, '9:00 PM'),
      ]);
    }

    return PrayerTimesCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: columnChildren,
      ),
    );
  }
}
