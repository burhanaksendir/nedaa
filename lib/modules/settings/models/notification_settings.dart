const athanRingtones = [
  NotificationRingtone(displayName: 'knock, knock', fileName: 'knock.mp3'),
  NotificationRingtone(displayName: 'Beep', fileName: 'beep.mp3'),
  NotificationRingtone(displayName: 'Athan 1', fileName: 'athan1.mp3'),
  NotificationRingtone(displayName: 'Athan 8', fileName: 'athan8.mp3'),
  NotificationRingtone(displayName: 'Athan 2', fileName: 'athan6.mp3'),
  NotificationRingtone(
      displayName: 'Madina Athan', fileName: 'medina_athan.mp3'),
  NotificationRingtone(displayName: 'Iqama 1', fileName: 'iqama1.mp3'),
  NotificationRingtone(displayName: 'Takbir', fileName: 'takbir.mp3'),
];

const iqamaRingtones = [
  NotificationRingtone(displayName: 'knock, knock', fileName: 'knock.mp3'),
  NotificationRingtone(displayName: 'Beep', fileName: 'beep.mp3'),
  NotificationRingtone(displayName: 'Athan 1', fileName: 'athan1.mp3'),
  NotificationRingtone(displayName: 'Athan 8', fileName: 'athan8.mp3'),
  NotificationRingtone(displayName: 'Athan 2', fileName: 'athan6.mp3'),
  NotificationRingtone(
      displayName: 'Madina Athan', fileName: 'medina_athan.mp3'),
  NotificationRingtone(displayName: 'Iqama 1', fileName: 'iqama1.mp3'),
  NotificationRingtone(displayName: 'Takbir', fileName: 'takbir.mp3'),
];

class NotificationRingtone {
  final String displayName;
  final String fileName;

  const NotificationRingtone(
      {required this.displayName, required this.fileName});
}

class PrayerNotificationSettings {
  PrayerNotificationSettings(
      {required this.athanSettings, required this.iqamaSettings});

  PrayerNotificationSettings.defaultValue()
      : this(
          athanSettings: NotificationSettings(
            sound: true,
            vibration: false,
            ringtone: athanRingtones[0],
          ),
          iqamaSettings: IqamaSettings(
            enabled: true,
            delay: 10,
            notificationSettings: NotificationSettings(
              sound: true,
              vibration: false,
              ringtone: iqamaRingtones[0],
            ),
          ),
        );

  NotificationSettings athanSettings;
  IqamaSettings iqamaSettings;

  factory PrayerNotificationSettings.fromJson(Map<String, dynamic> json) {
    return PrayerNotificationSettings(
      athanSettings: NotificationSettings.fromJson(json['athanSettings']),
      iqamaSettings: IqamaSettings.fromJson(json['iqamaSettings']),
    );
  }
  Map<String, dynamic> toJson() => {
        'athanSettings': athanSettings.toJson(),
        'iqamaSettings': iqamaSettings.toJson(),
      };
}

class IqamaSettings {
  IqamaSettings({
    required this.enabled,
    required this.notificationSettings,
    required this.delay,
  });
  bool enabled;
  NotificationSettings notificationSettings;
  int delay;

  factory IqamaSettings.fromJson(Map<String, dynamic> json) => IqamaSettings(
        enabled: json["enabled"],
        notificationSettings:
            NotificationSettings.fromJson(json["notificationSettings"]),
        delay: json["delay"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "notificationSettings": notificationSettings.toJson(),
        "delay": delay,
      };
}

class NotificationSettings {
  NotificationSettings(
      {required this.sound, required this.vibration, required this.ringtone});

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
