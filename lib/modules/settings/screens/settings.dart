import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iathan/modules/settings/screens/calculation_methods_dialog.dart';
import 'package:iathan/modules/settings/screens/languages_dialog.dart';
import 'package:iathan/modules/settings/screens/location.dart';
import 'package:iathan/modules/settings/screens/notification.dart';
import 'package:iathan/modules/settings/screens/theme_dialog.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool lockInBackground = false;
  bool notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('Settings'),
          tiles: [
            SettingsTile(
              title: Text('Language'),
              trailing: Text('English'),
              leading: Icon(Icons.language),
              onPressed: (context) async {
                //TODO: Use bloc to set language
                final language = await showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => const LanguageDialog(),
                );
              },
            ),
            SettingsTile(
              title: const Text('Theme'),
              trailing: const Text('Default'),
              leading: const Icon(Icons.color_lens),
              onPressed: (context) async {
                final calculationMethod = await showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => const ThemeDialog(),
                );
              },
            ),
            SettingsTile(
              title: const Text('Location'),
              trailing: const Text('Kuala Lumpur'),
              leading: const Icon(Icons.room),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const LocationSettings(),
                ));
              },
            ),
            SettingsTile(
              title: const Text('Notification'),
              leading: const Icon(Icons.notifications),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ));
              },
            ),
            SettingsTile(
              title: const Text('Calculation Method'),
              trailing: const Text('Default'),
              leading: const Icon(Icons.access_time_filled),
              onPressed: (context) async {
                final calculationMethod = await showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => const CalculationMethodsDialog(),
                );
              },
            ),
          ],
        ),
        SettingsSection(
          title: const Text('Contact Us'),
          tiles: [
            // TODO: forward to creating new email
            SettingsTile(
              title: const Text('support@iathan.app'),
              leading: const Icon(Icons.email),
            ),
            // TODO: forward to open the page in the browser
            SettingsTile(
              title: const Text('https://iathan.app'),
              leading: const Icon(Icons.public),
            ),
          ],
        ),
      ],
    );
  }
}
