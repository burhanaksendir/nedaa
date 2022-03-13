import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';

class PrayerSettingsScreen extends StatefulWidget {
  PrayerSettingsScreen(this.prayer, {Key? key}) : super(key: key);

  String prayer;

  @override
  State<PrayerSettingsScreen> createState() => _PrayerSettingsScreenState();
}

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen> {
  // or as a local variable
  final _audioCache = AudioCache();

  bool _vibrateEnable = false;
  bool _soundEnable = false;

  int _selectedRingtone = 0;

  _ringtoneTile(String title, int index) {
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
              child: const Text("Stop"),
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
                  title: const Text('Vibrate'),
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
                  title: const Text('Sound'),
                  leading: const Icon(Icons.volume_up),
                ),
              ],
            ),
            if (_soundEnable)
              SettingsSection(
                title: const Text('Ringtones'),
                tiles: [
                  _ringtoneTile("knock, knock", 0),
                  _ringtoneTile("Ringtone 1", 1),
                  _ringtoneTile("Ringtone 2", 2),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
