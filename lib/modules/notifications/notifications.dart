import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nedaa/modules/prayer_times/models/prayer_times.dart';
import 'package:nedaa/modules/settings/bloc/settings_bloc.dart';
import 'package:nedaa/modules/settings/models/prayer_type.dart';
import 'package:nedaa/utils/helper.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void _handleForeground(NotificationResponse details) {
  debugPrint(
      'got notification ${details.id} ${details.input} ${details.payload}');
}

void _requestIOSNotificationPermissions() {
  if (Platform.isIOS) {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}

Future<void> initNotifications() async {
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      !kIsWeb && Platform.isLinux
          ? null
          : await _flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    debugPrint('notification was tapped');
  }

  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false);

  const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  _flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: _handleForeground,
      onDidReceiveBackgroundNotificationResponse: _handleForeground);

  _requestIOSNotificationPermissions();
}

Future<void> cancelNotifications() async {
  await _flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> scheduleNotifications(
  BuildContext context,
  List<DayPrayerTimes> days,
) async {
  var t = AppLocalizations.of(context);
  if (t == null) {
    //TODO: this is a hack to force load of app localization,
    //      since we schedule on `main` before any widget appearing
    var locale = context.read<SettingsBloc>().state.appLanguage;
    t = await AppLocalizations.delegate.load(locale);
  }

  var prayersTranslation = {
    PrayerType.fajr: t.fajr,
    PrayerType.sunrise: t.sunrise,
    PrayerType.duhur: t.duhur,
    PrayerType.asr: t.asr,
    PrayerType.maghrib: t.maghrib,
    PrayerType.isha: t.isha,
  };

  await cancelNotifications();

  debugPrint('got 1 ${days.length}');

  if (days.isEmpty) return;
  debugPrint('got 2');

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('prayers', 'Prayers Notification',
          channelDescription: 'Notifying prayers',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const DarwinNotificationDetails darwinPlatformChannelSpecifics =
      DarwinNotificationDetails();
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics);

  var id = 0;
  var now = getCurrentTimeWithTimeZone(
    days.first.timeZoneName,
  );

  await _flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    'First Minute',
    'Minute Minute Debugging',
    now.add(const Duration(minutes: 1)),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );

  var counter = 0;
  var lastTime = now;
  debugPrint('got 3');

  for (var day in days) {
    for (var e in day.prayerTimes.entries) {
      var d = tz.TZDateTime.from(
        e.value,
        tz.getLocation(day.timeZoneName),
      );
      ++id;
      if (d.isBefore(now)) continue;
      String prayerName = prayersTranslation[e.key] ?? "";
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        t.prayerTimeNotificationTitle(prayerName),
        t.prayerTimeNotificationContent(prayerName),
        d,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      counter++;
      // reached the end for iOS
      if (counter == 63) {
        break;
      }
      lastTime = d;
    }
  }

  // remind the user to open the app
  await _flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    t.openAppReminderTitle,
    t.openAppReminderContent,
    lastTime.add(const Duration(minutes: 10)),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );

  debugPrint(
    "scheduled ${(await _flutterLocalNotificationsPlugin.pendingNotificationRequests()).length} notifications",
  );
}

Future<List<PendingNotificationRequest>> getPendingNotifications() async {
  return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
}
