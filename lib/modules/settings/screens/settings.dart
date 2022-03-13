import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iathan/modules/settings/screens/calculation_methods_dialog.dart';
import 'package:iathan/modules/settings/screens/languages_dialog.dart';
import 'package:iathan/modules/settings/screens/location.dart';
import 'package:iathan/modules/settings/screens/notification.dart';
import 'package:iathan/modules/settings/screens/theme_dialog.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var t = AppLocalizations.of(context);
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text(t!.settings),
          tiles: [
            SettingsTile(
              title: Text(t.language),
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
              title: Text(t.theme),
              trailing: Text(t.defaultString),
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
              title: Text(t.location),
              trailing: const Text('Kuala Lumpur'),
              leading: const Icon(Icons.room),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const LocationSettings(),
                ));
              },
            ),
            SettingsTile(
              title: Text(t.notification),
              leading: const Icon(Icons.notifications),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ));
              },
            ),
            SettingsTile(
              title: Text(t.calculationMethods),
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
          title: Text(t.contactUs),
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
