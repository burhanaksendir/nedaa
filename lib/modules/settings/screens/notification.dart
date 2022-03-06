import 'package:flutter/material.dart';
import 'package:iathan/modules/settings/screens/prayer_settings.dart';
import 'package:settings_ui/settings_ui.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  AbstractSettingsTile _buildPrayerSettingsTile(String prayer) {
    return SettingsTile(
      title: Text(prayer),
      trailing: const Text("No alarm"),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Prayer notifications'),
              tiles: [
                _buildPrayerSettingsTile("Fajr"),
                _buildPrayerSettingsTile("Sunrise"),
                _buildPrayerSettingsTile("Dhuhr"),
                _buildPrayerSettingsTile("Asr"),
                _buildPrayerSettingsTile("Maghrib"),
                _buildPrayerSettingsTile("Isha"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
