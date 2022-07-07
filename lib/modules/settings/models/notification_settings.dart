const allRingtones = [
  NotificationRingtone(displayName: 'knock, knock', fileName: 'knock.mp3'),
  NotificationRingtone(
    displayName: 'Athan 1',
    fileName: 'athan8.mp3',
  ),
  NotificationRingtone(
    displayName: 'Athan 2',
    fileName: 'athan6.mp3',
  ),
];

class NotificationRingtone {
  final String displayName;
  final String fileName;

  const NotificationRingtone(
      {required this.displayName, required this.fileName});
}

class NotificationSettings {
  NotificationSettings(
      {required this.sound, required this.vibration, required this.ringtone});

  NotificationSettings.defaultValue()
      : this(
          sound: true,
          vibration: false,
          ringtone: const NotificationRingtone(
            displayName: 'knock, knock',
            fileName: 'knock.mp3',
          ),
        );

  bool sound;
  bool vibration;
  NotificationRingtone ringtone;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        sound: json["sound"],
        vibration: json["vibration"],
        ringtone: NotificationRingtone(
          displayName: json["ringtoneName"],
          fileName: json["ringtoneFileName"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "sound": sound,
        "vibration": vibration,
        "ringtoneName": ringtone.displayName,
        "ringtoneFileName": ringtone.fileName,
      };
}
