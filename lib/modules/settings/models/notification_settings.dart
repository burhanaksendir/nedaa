class NotificationSettings {
  NotificationSettings(
      {required this.sound,
      required this.vibration,
      required this.prayerName,
      required this.ringtoneName});

  final bool sound;
  final bool vibration;
  final String prayerName;
  final String ringtoneName;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        sound: json["sound"],
        vibration: json["vibration"],
        prayerName: json["prayerName"],
        ringtoneName: json["ringtoneName"],
      );

  Map<String, dynamic> toJson() => {
        "sound": sound,
        "vibration": vibration,
        "prayerName": prayerName,
        "ringtoneName": ringtoneName,
      };
}
