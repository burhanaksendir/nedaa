class NotificationSettings {
  NotificationSettings(
      {required this.sound,
      required this.vibration,
      required this.ringtoneName});

  NotificationSettings.defaultValue()
      : this(
          sound: true,
          vibration: false,
          ringtoneName: 'knock, knock',
        );

  bool sound;
  bool vibration;
  String ringtoneName;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        sound: json["sound"],
        vibration: json["vibration"],
        ringtoneName: json["ringtoneName"],
      );

  Map<String, dynamic> toJson() => {
        "sound": sound,
        "vibration": vibration,
        "ringtoneName": ringtoneName,
      };
}
