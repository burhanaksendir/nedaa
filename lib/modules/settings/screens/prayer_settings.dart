import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrayerSettingsScreen extends StatefulWidget {
  const PrayerSettingsScreen(this.prayer, {Key? key}) : super(key: key);

  final String prayer;

  @override
  State<PrayerSettingsScreen> createState() => _PrayerSettingsScreenState();
}

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen> {
  // or as a local variable
  final _audioCache = AudioCache();

  bool _vibrateEnable = false;
  bool _soundEnable = false;

  int _selectedRingtone = 0;

  _ringtoneTile(AppLocalizations t, String title, int index) {
    return SettingsTile(
      title: Text(title),
      trailing: _selectedRingtone == index ? const Icon(Icons.check) : null,
      onPressed: (context) async {
        setState(() {
          _selectedRingtone = index;
        });

        // TODO: replace with audio file based on title?
        AudioPlayer player = await _audioCache.play('knock.mp3');

        player.onPlayerCompletion.listen((event) {
          Navigator.pop(context);
        });

        showModalBottomSheet(
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.prayer),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  initialValue: _vibrateEnable,
                  onToggle: (value) {
                    setState(() {
                      _vibrateEnable = value;
                    });
                  },
                  title: Text(t!.vibrate),
                  leading: const Icon(Icons.vibration),
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  initialValue: _soundEnable,
                  onToggle: (value) {
                    setState(() {
                      _soundEnable = value;
                    });
                  },
                  title: Text(t.alertOn),
                  leading: const Icon(Icons.volume_up),
                ),
              ],
            ),
            if (_soundEnable)
              SettingsSection(
                title: const Text(''),
                tiles: [
                  _ringtoneTile(t, "knock, knock", 0),
                  _ringtoneTile(t, "Ringtone 1", 1),
                  _ringtoneTile(t, "Ringtone 2", 2),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
