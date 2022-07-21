import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nedaa/modules/notifications/notifications.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:nedaa/modules/settings/screens/prayer_settings.dart';
import 'package:nedaa/utils/location_permission_utils.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool? permission;

  AbstractSettingsTile _buildPrayerSettingsTile(
      PrayerType prayerType, String prayerName) {
    return SettingsTile(
      title: Text(prayerName),
      trailing: const Text(""),
      onPressed: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrayerSettingsScreen(prayerType, prayerName),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    requestIOSNotificationPermissionsAndGetCurrent().then((value) => {
          setState(() {
            permission = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    // loading
    if (permission == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    var t = AppLocalizations.of(context);

    SettingsSection settingsSection;
    if (Platform.isIOS && !permission!) {
      settingsSection = SettingsSection(title: Text(t!.prayersAlerts), tiles: [
        SettingsTile.switchTile(
          initialValue: permission,
          onToggle: (value) {
            // open settingsS
            openAppSettings().then((_) {
              Navigator.pop(context);
            });
          },
          title: Text(t.allowNotifications),
          leading: const Icon(
            Icons.notifications_off,
          ),
        )
      ]);
    } else {
      settingsSection = SettingsSection(
        title: Text(t!.prayersAlerts),
        tiles: [
          _buildPrayerSettingsTile(PrayerType.fajr, t.fajr),
          _buildPrayerSettingsTile(PrayerType.duhur, t.duhur),
          _buildPrayerSettingsTile(PrayerType.asr, t.asr),
          _buildPrayerSettingsTile(PrayerType.maghrib, t.maghrib),
          _buildPrayerSettingsTile(PrayerType.isha, t.isha),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.notification),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SettingsList(
          sections: [settingsSection],
        ),
      ),
    );
  }
}
