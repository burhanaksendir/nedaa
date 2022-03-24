import 'package:flutter/material.dart';
import 'package:iathan/modules/settings/models/prayer_type.dart';
import 'package:iathan/modules/settings/screens/prayer_settings.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t!.notification),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SettingsList(
          sections: [
            SettingsSection(
              title: Text(t.prayersAlerts),
              tiles: [
                _buildPrayerSettingsTile(PrayerType.fajr, t.fajr),
                _buildPrayerSettingsTile(PrayerType.sunrise, t.sunrise),
                _buildPrayerSettingsTile(PrayerType.duhur, t.duhur),
                _buildPrayerSettingsTile(PrayerType.asr, t.asr),
                _buildPrayerSettingsTile(PrayerType.maghrib, t.maghrib),
                _buildPrayerSettingsTile(PrayerType.isha, t.isha),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
