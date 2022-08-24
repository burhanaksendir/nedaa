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
    NotificationSettings settings,
    void Function() onUpdate,
    NotificationRingtone ringtone,
  ) {
    return SettingsTile(
      title: Text(ringtone.displayName),
      trailing: ringtone.displayName == settings.ringtone.displayName
          ? const Icon(Icons.check)
          : null,
      onPressed: (context) async {
        settings.ringtone = ringtone;
        onUpdate();

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

  List<AbstractSettingsSection> _notificationSettingsSections(
      AppLocalizations t,
      NotificationSettings settings,
      void Function() onUpdate) {
    return [
      // hide vibration for iOS users because it's not supported
      if (!Platform.isIOS)
        SettingsSection(
          tiles: [
            SettingsTile.switchTile(
              initialValue: settings.vibration,
              onToggle: (value) {
                settings.vibration = value;
                onUpdate();
              },
              title: Text(t.vibrate),
              leading: const Icon(Icons.vibration),
            ),
          ],
        ),
      SettingsSection(
        tiles: [
          SettingsTile.switchTile(
            initialValue: settings.sound,
            onToggle: (value) {
              settings.sound = value;

              onUpdate();
            },
            title: Text(t.alertOn),
            leading: const Icon(Icons.volume_up),
          ),
        ],
      ),
      if (settings.sound)
        SettingsSection(
            tiles: athanRingtones
                .map(
                  (e) => _ringtoneTile(context, t, settings, onUpdate, e),
                )
                .toList()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    var currentUserState = context.watch<UserSettingsBloc>().state;
    var prayerNotificationSettings =
        currentUserState.notificationSettings[widget.prayerType]!;

    onUpdate() {
      context.read<UserSettingsBloc>().add(
            PrayerNotificationEvent(
                widget.prayerType, prayerNotificationSettings),
          );
    }

    var allSections = _notificationSettingsSections(
      t!,
      prayerNotificationSettings.athanSettings,
      onUpdate,
    );

    var isIqamaEnabled = prayerNotificationSettings.iqamaSettings.enabled;
    var iqamaEnableSection = SettingsSection(
      tiles: [
        SettingsTile.switchTile(
          initialValue: isIqamaEnabled,
          onToggle: (value) {
            prayerNotificationSettings.iqamaSettings.enabled = value;

            onUpdate();
          },
          title: Text(t.iqama),
          leading: const Icon(Icons.star),
        ),
      ],
    );
    allSections.add(iqamaEnableSection);

    if (isIqamaEnabled) {
      allSections.addAll(_notificationSettingsSections(
        t,
        prayerNotificationSettings.iqamaSettings.notificationSettings,
        onUpdate,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.prayerName),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SettingsList(sections: allSections),
      ),
    );
  }
}
