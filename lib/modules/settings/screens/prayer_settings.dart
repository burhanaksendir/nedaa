import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iathan/modules/settings/models/notification_settings.dart';
import 'package:iathan/modules/settings/models/prayer_type.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/user_settings_bloc.dart';

class PrayerSettingsScreen extends StatefulWidget {
  const PrayerSettingsScreen(this.prayerType, this.prayerName, {Key? key})
      : super(key: key);

  final PrayerType prayerType;
  final String prayerName;

  @override
  State<PrayerSettingsScreen> createState() => _PrayerSettingsScreenState();
}

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen> {
  // or as a local variable
  final _audioCache = AudioCache();

  NotificationSettings _defaultNotificationSettings() {
    return NotificationSettings(
      vibration: false,
      sound: true,
      ringtoneName: 'knock, knock',
    );
  }

  _ringtoneTile(BuildContext context, AppLocalizations t,
      NotificationSettings notificationSettings, String title, int index) {
    return SettingsTile(
      title: Text(title),
      // trailing: _selectedRingtone == index ? const Icon(Icons.check) : null,
      trailing: title == notificationSettings.ringtoneName
          ? const Icon(Icons.check)
          : null,
      onPressed: (context) async {
        notificationSettings.ringtoneName = title;
        context.read<UserSettingsBloc>().add(
              PrayerNotificationEvent(widget.prayerType, notificationSettings),
            );

        // TODO: replace with audio file based on title?
        AudioPlayer player = await _audioCache.play('knock.mp3');

        player.onPlayerCompletion.listen((event) {
          Navigator.pop(context);
        });

        await showModalBottomSheet(
          context: context,
          builder: (context) {
            return TextButton(
              child: Text(t.stop),
              onPressed: () {
                if (player.state == PlayerState.PLAYING) {
                  player.stop();
                  Navigator.pop(context);
                }
              },
            );
          },
        );
        await player.stop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    var _currentUserState = context.watch<UserSettingsBloc>().state;
    var _prayerNotificationSettings =
        _currentUserState.notificationSettings[widget.prayerType] ??
            _defaultNotificationSettings();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.prayerName),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  initialValue: _prayerNotificationSettings.vibration,
                  onToggle: (value) {
                    _prayerNotificationSettings.vibration = value;
                    context.read<UserSettingsBloc>().add(
                          PrayerNotificationEvent(
                              widget.prayerType, _prayerNotificationSettings),
                        );
                  },
                  title: Text(t!.vibrate),
                  leading: const Icon(Icons.vibration),
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  initialValue: _prayerNotificationSettings.sound,
                  onToggle: (value) {
                    _prayerNotificationSettings.sound = value;

                    context.read<UserSettingsBloc>().add(
                          PrayerNotificationEvent(
                              widget.prayerType, _prayerNotificationSettings),
                        );
                  },
                  title: Text(t.alertOn),
                  leading: const Icon(Icons.volume_up),
                ),
              ],
            ),
            if (_prayerNotificationSettings.sound)
              SettingsSection(
                tiles: [
                  _ringtoneTile(context, t, _prayerNotificationSettings,
                      "knock, knock", 0),
                  _ringtoneTile(
                      context, t, _prayerNotificationSettings, "Ringtone 1", 1),
                  _ringtoneTile(
                      context, t, _prayerNotificationSettings, "Ringtone 2", 2),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
