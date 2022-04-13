import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nedaa/modules/prayer_times/ui_components/main_prayer_card.dart';
import 'package:nedaa/modules/prayer_times/ui_components/today_prayers_card.dart';
import 'package:nedaa/modules/settings/bloc/user_settings_bloc.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:nedaa/utils/services/rest_api_service.dart';
import 'package:page_view_indicators/animated_circle_page_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PrayerTimes extends StatefulWidget {
  const PrayerTimes({Key? key}) : super(key: key);

  @override
  State<PrayerTimes> createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget _buildPrayerTimesView() {
    return Column(children: [
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
          borderColor: const Color(0xFF327D77),
          fillColor: Colors.white,
          activeColor: const Color(0xFF87C7BE),
        ),
      ),
    ]);
  }

  void _onRefresh(UserSettingsState _userSettings) async {
    // monitor network fetch
    //latitude-=3&longitude-=3method=3=iso8601
    var _userLocation = _userSettings.location;
    if (_userLocation != null) {
      var calculationMethodIndex = _userSettings.calculationMethod?.index ?? -1;
      print('Cal method index: $calculationMethodIndex');
      var _calculationMethod =
          calculationMethodIndex != -1 ? '&method=$calculationMethodIndex' : '';
      var getParams =
          'iso8601=true&latitude=${_userLocation.location?.latitude ?? 0}&longitude=${_userLocation.location?.longitude ?? 0}$_calculationMethod';
      var allDays = await getPrayerTimes(getParams)
          .then((value) => value)
          .catchError((error) => _refreshController.refreshFailed());
      var todayTimes = allDays.firstWhere((e) {
        var todaysDate = DateTime.now();
        return e.date.day == todaysDate.day &&
            e.date.month == todaysDate.month &&
            e.date.year == todaysDate.year;
      });
      var fajr = todayTimes.prayerTimes[PrayerType.fajr]?.toLocal();
      var sunrise = todayTimes.prayerTimes[PrayerType.sunrise]?.toLocal();
      var dhuhr = todayTimes.prayerTimes[PrayerType.duhur]?.toLocal();
      var asr = todayTimes.prayerTimes[PrayerType.asr]?.toLocal();
      var maghrib = todayTimes.prayerTimes[PrayerType.maghrib]?.toLocal();
      var isha = todayTimes.prayerTimes[PrayerType.isha]?.toLocal();

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Prayer Times'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Fajr: ${fajr?.hour}:${fajr?.minute}'),
                  Text('Sunrise: ${sunrise?.hour}:${sunrise?.minute}'),
                  Text('Dhuhr: ${dhuhr?.hour}:${dhuhr?.minute}'),
                  Text('Asr: ${asr?.hour}:${asr?.minute}'),
                  Text('Maghrib: ${maghrib?.hour}:${maghrib?.minute}'),
                  Text('Isha: ${isha?.hour}:${isha?.minute}'),
                  Text('Calculation Method: ${_userSettings.calculationMethod?.name}'),
                ],
              ),
            );
          });

      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _userSettings = context.watch<UserSettingsBloc>().state;
    return SmartRefresher(
      onRefresh: () => _onRefresh(_userSettings),
      controller: _refreshController,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverFillViewport(
            delegate: SliverChildBuilderDelegate(
              (_, __) => _buildPrayerTimesView(),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
