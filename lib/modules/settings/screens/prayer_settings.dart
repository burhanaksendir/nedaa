import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nedaa/modules/settings/models/notification_settings.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
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

  SettingsTile _ringtoneTile(
    BuildContext context,
    AppLocalizations t,
    NotificationSettings notificationSettings,
    NotificationRingtone ringtone,
  ) {
    return SettingsTile(
      title: Text(ringtone.displayName),
      trailing:
          ringtone.displayName == notificationSettings.ringtone.displayName
              ? const Icon(Icons.check)
              : null,
      onPressed: (context) async {
        notificationSettings.ringtone = ringtone;
        context.read<UserSettingsBloc>().add(
              PrayerNotificationEvent(widget.prayerType, notificationSettings),
            );

        AudioPlayer player = await _audioCache.play(ringtone.fileName);

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

    var currentUserState = context.watch<UserSettingsBloc>().state;
    var prayerNotificationSettings =
        currentUserState.notificationSettings[widget.prayerType]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.prayerName),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SettingsList(
          sections: [
            // hide vibration for iOS users because it's not supported
            if (!Platform.isIOS)
              SettingsSection(
                tiles: [
                  SettingsTile.switchTile(
                    initialValue: prayerNotificationSettings.vibration,
                    onToggle: (value) {
                      prayerNotificationSettings.vibration = value;
                      context.read<UserSettingsBloc>().add(
                            PrayerNotificationEvent(
                                widget.prayerType, prayerNotificationSettings),
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
                  initialValue: prayerNotificationSettings.sound,
                  onToggle: (value) {
                    prayerNotificationSettings.sound = value;

                    context.read<UserSettingsBloc>().add(
                          PrayerNotificationEvent(
                              widget.prayerType, prayerNotificationSettings),
                        );
                  },
                  title: Text(t!.alertOn),
                  leading: const Icon(Icons.volume_up),
                ),
              ],
            ),
            if (prayerNotificationSettings.sound)
              SettingsSection(
                  tiles: allRingtones
                      .map(
                        (e) => _ringtoneTile(
                            context, t, prayerNotificationSettings, e),
                      )
                      .toList()),
          ],
        ),
      ),
    );
  }
}
