import 'package:flutter/material.dart';
import 'package:iathan/modules/settings/screens/prayer_settings.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  AbstractSettingsTile _buildPrayerSettingsTile(String prayer) {
    return SettingsTile(
      title: Text(prayer),
      trailing: const Text(""),
      onPressed: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrayerSettingsScreen(prayer),
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
                _buildPrayerSettingsTile(t.fajr),
                _buildPrayerSettingsTile(t.sunrise),
                _buildPrayerSettingsTile(t.duhur),
                _buildPrayerSettingsTile(t.asr),
                _buildPrayerSettingsTile(t.maghrib),
                _buildPrayerSettingsTile(t.isha),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
