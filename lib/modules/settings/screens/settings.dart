import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iathan/modules/settings/screens/languages_dialog.dart';
import 'package:iathan/modules/settings/screens/location.dart';
import 'package:iathan/modules/settings/screens/notification.dart';
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
              title: Text('Location'),
              trailing: Text('Kuala Lumpur'),
              leading: Icon(Icons.room),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const LocationSettings(),
                ));
              },
            ),
            SettingsTile(
              title: Text('Notification'),
              leading: Icon(Icons.notifications),
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>  NotificationScreen(),
                ));
              },
            ),
            SettingsTile(
              title: Text('Calculation Method'),
              trailing: Text('Default'),
              leading: Icon(Icons.access_time_filled),
              onPressed: (context) {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (_) => LanguagesScreen(),
                // ));
              },
            ),
          ],
        ),
        // SettingsSection(
        //   title: Text('Account'),
        //   tiles: [
        //     SettingsTile(
        //         title: Text('Phone number'), leading: Icon(Icons.phone)),
        //     SettingsTile(title: Text('Email'), leading: Icon(Icons.email)),
        //     SettingsTile(
        //         title: Text('Sign out'), leading: Icon(Icons.exit_to_app)),
        //   ],
        // ),
        // SettingsSection(
        //   title: Text('Security'),
        //   tiles: [
        //     SettingsTile.switchTile(
        //       title: Text('Lock app in background'),
        //       leading: Icon(Icons.phonelink_lock),
        //       initialValue: lockInBackground,
        //       onToggle: (bool value) {
        //         setState(() {
        //           lockInBackground = value;
        //           notificationsEnabled = value;
        //         });
        //       },
        //     ),
        //     SettingsTile.switchTile(
        //       title: Text('Use fingerprint'),
        //       description:
        //           Text('Allow application to access stored fingerprint IDs.'),
        //       leading: Icon(Icons.fingerprint),
        //       onToggle: (bool value) {},
        //       initialValue: false,
        //     ),
        //     SettingsTile.switchTile(
        //       title: Text('Change password'),
        //       leading: Icon(Icons.lock),
        //       initialValue: true,
        //       onToggle: (bool value) {},
        //     ),
        //     SettingsTile.switchTile(
        //       title: Text('Enable Notifications'),
        //       enabled: notificationsEnabled,
        //       leading: Icon(Icons.notifications_active),
        //       initialValue: true,
        //       onToggle: (value) {},
        //     ),
        //   ],
        // ),
        SettingsSection(
          title: Text('Misc'),
          tiles: [
            SettingsTile(
                title: Text('Terms of Service'),
                leading: Icon(Icons.description)),
            SettingsTile(
                title: Text('Open source licenses'),
                leading: Icon(Icons.collections_bookmark)),
          ],
        ),
        SettingsSection(
          title: Text('Contact Us'),
          tiles: [
            // TODO: forward to creating new email
            SettingsTile(
              title: Text('support@iathan.app'),
              leading: Icon(Icons.email),
            ),
            // TODO: forward to open the page in the browser
            SettingsTile(
              title: Text('https://iathan.app'),
              leading: Icon(Icons.public),
            ),
          ],
        ),
        // // CustomSection(
        // //   child: Column(
        // //     children: [
        // //       Padding(
        // //         padding: const EdgeInsets.only(top: 22, bottom: 8),
        // //         child: Image.asset(
        // //           'assets/settings.png',
        // //           height: 50,
        // //           width: 50,
        // //           color: Color(0xFF777777),
        // //         ),
        // //       ),
        // //       Text(
        // //         'Version: 2.4.0 (287)',
        // //         style: TextStyle(color: Color(0xFF777777)),
        // //       ),
        // //     ],
        // //   ),
        // // ),
      ],
    );
  }
}
