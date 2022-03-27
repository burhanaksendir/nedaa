import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iathan/modules/settings/bloc/user_settings_bloc.dart';
import 'package:iathan/modules/settings/screens/current_location_picker.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationSettings extends StatefulWidget {
  const LocationSettings({Key? key}) : super(key: key);

  @override
  State<LocationSettings> createState() => _LocationSettingsState();
}

class _LocationSettingsState extends State<LocationSettings> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    var _currentUserState = context.watch<UserSettingsBloc>().state;
    var _keepUpdatingLocation = _currentUserState.keepUpdatingLocation;

    return Scaffold(
      appBar: AppBar(
        title: Text(t!.location),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SettingsList(
          sections: [
            SettingsSection(title: Text(t.locationSettings), tiles: [
              SettingsTile(
                title: Text(t.location),
                leading: const Icon(Icons.near_me),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const CurrentLocationPicker(),
                  ));
                },
              ),
              SettingsTile.switchTile(
                onToggle: (bool value) {
                  context
                      .read<UserSettingsBloc>()
                      .add(KeepUpdatingLocationEvent(value));
                },
                initialValue: _keepUpdatingLocation,
                title: Text(t.keepLocationUpdated),
                leading: const Icon(Icons.loop_rounded),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
