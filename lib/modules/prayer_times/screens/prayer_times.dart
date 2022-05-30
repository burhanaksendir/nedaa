import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/prayer_times/ui_components/main_prayer_card.dart';
import 'package:nedaa/modules/prayer_times/ui_components/today_prayers_card.dart';
import 'package:nedaa/modules/settings/bloc/user_settings_bloc.dart';
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
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
    ]);
  }

  void _onRefresh(
      UserSettingsState userSettings, PrayerTimesBloc prayerTimesBloc) async {
    prayerTimesBloc.add(FetchPrayerTimesEvent(
      userSettings.location,
      userSettings.calculationMethod,
    ));

    // TODO: this will complete quickly, but we can use Bloc state changes
    //       to listen to the completion of the fetching process
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    var userSettings = context.watch<UserSettingsBloc>().state;
    var prayerTimesBloc = context.watch<PrayerTimesBloc>();
    return SmartRefresher(
      onRefresh: () => _onRefresh(userSettings, prayerTimesBloc),
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
