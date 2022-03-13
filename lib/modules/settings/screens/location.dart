import 'package:flutter/material.dart';
import 'package:iathan/modules/settings/screens/current_location_picker.dart';
import 'package:settings_ui/settings_ui.dart';

class LocationSettings extends StatefulWidget {
  const LocationSettings({Key? key}) : super(key: key);

  @override
  State<LocationSettings> createState() => _LocationSettingsState();
}

class _LocationSettingsState extends State<LocationSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SettingsList(
          sections: [
            SettingsSection(title: const Text('Location settings'), tiles: [
              SettingsTile(
                title: const Text('Location'),
                leading: const Icon(Icons.near_me),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const CurrentLocationPicker(),
                  ));
                },
              ),
              SettingsTile.switchTile(
                onToggle: (bool value) {},
                initialValue: false,
                title: const Text('Keep updated'),
                leading: const Icon(Icons.loop_rounded),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
