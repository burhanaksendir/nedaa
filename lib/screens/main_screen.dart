import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nedaa/modules/settings/bloc/settings_bloc.dart';
import 'package:nedaa/modules/settings/screens/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../modules/prayer_times/screens/prayer_times.dart';

import 'package:nedaa/utils/location_permission_utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    var settingsBloc = context.watch<SettingsBloc>();

    if (settingsBloc.state.isFirstRun) {
      checkPermissionsUpdateCurrentLocation(context, () => mounted);
      settingsBloc.add(FirstRunEvent());
    }
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(t!.appTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                });
              },
            )
          ],
          centerTitle: true,
        ),
        body: const PrayerTimes(),
      ),
    );
  }
}
