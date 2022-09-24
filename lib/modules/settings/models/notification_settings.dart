const athanRingtones = [
  NotificationRingtone(displayId: 'knock', fileName: 'knock.mp3'),
  NotificationRingtone(displayId: 'beep', fileName: 'beep.mp3'),
  NotificationRingtone(displayId: 'athan1', fileName: 'athan1.mp3'),
  NotificationRingtone(displayId: 'athan8', fileName: 'athan8.mp3'),
  NotificationRingtone(displayId: 'athan2', fileName: 'athan6.mp3'),
  NotificationRingtone(displayId: 'medina_athan', fileName: 'medina_athan.mp3'),
  NotificationRingtone(displayId: 'takbir', fileName: 'takbir.mp3'),
];

const iqamaRingtones = [
  NotificationRingtone(displayId: 'knock', fileName: 'knock.mp3'),
  NotificationRingtone(displayId: 'beep', fileName: 'beep.mp3'),
  NotificationRingtone(displayId: 'iqama1', fileName: 'iqama1.mp3'),
  NotificationRingtone(displayId: 'takbir', fileName: 'takbir.mp3'),
];

class NotificationRingtone {
  final String displayId;
  final String fileName;

  const NotificationRingtone({
    required this.displayId,
    required this.fileName,
  });
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
          displayId: json["ringtoneId"],
          fileName: json["ringtoneFileName"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "sound": sound,
        "vibration": vibration,
        "ringtoneId": ringtone.displayId,
        "ringtoneFileName": ringtone.fileName,
      };
}
