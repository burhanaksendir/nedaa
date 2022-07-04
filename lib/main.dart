import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:nedaa/constants/app_constans.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nedaa/constants/theme.dart';
import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/prayer_times/repositories/prayer_times_repository.dart';
import 'package:nedaa/modules/settings/bloc/settings_bloc.dart';
import 'package:nedaa/modules/settings/bloc/user_settings_bloc.dart';
import 'package:nedaa/modules/settings/models/calculation_method.dart';
import 'package:nedaa/modules/settings/models/user_location.dart';
import 'package:nedaa/modules/settings/repositories/settings_repository.dart';
import 'package:nedaa/screens/main_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz_init;
import 'package:timezone/standalone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void handleForeground(NotificationResponse details) {
  debugPrint(
      'got notification ${details.id} ${details.input} ${details.payload}');
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    debugPrint('notification was tapped');
  }

  // Wait 1 seconds before removing the splash screen
  await Future.delayed(const Duration(seconds: 1));

  tz_init.initializeTimeZones();

  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false);

  const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: handleForeground,
      onDidReceiveBackgroundNotificationResponse: handleForeground);

  SettingsRepository settingsRepository = SettingsRepository(
    await SharedPreferences.getInstance(),
  );

  UserLocation location = settingsRepository.getUserLocation();
  CalculationMethod method = settingsRepository.getCalculationMethod();
  String timezone = settingsRepository.getTimezone();
  PrayerTimesRepository prayerTimesRepository =
      await PrayerTimesRepository.newRepo(location, method, timezone);

  FlutterNativeSplash.remove();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(
            settingsRepository: settingsRepository,
            prayerTimesRepository: prayerTimesRepository),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key,
      required this.settingsRepository,
      required this.prayerTimesRepository})
      : super(key: key);
  final SettingsRepository settingsRepository;
  final PrayerTimesRepository prayerTimesRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: settingsRepository),
        RepositoryProvider.value(value: prayerTimesRepository)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SettingsBloc(context.read<SettingsRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                UserSettingsBloc(context.read<SettingsRepository>()),
          ),
          BlocProvider(
            create: (context) {
              var settingsRepo = context.read<SettingsRepository>();
              var userLocation = settingsRepo.getUserLocation();
              var calculationMethod = settingsRepo.getCalculationMethod();
              var timezone = settingsRepository.getTimezone();
              return PrayerTimesBloc(context.read<PrayerTimesRepository>())
                ..add(FetchPrayerTimesEvent(
                    userLocation, calculationMethod, timezone))
                // this listens to all updates in prayer times and sets
                // calculation method to the default value we got from the API
                // if it is not set yet
                ..stream.forEach((state) async {
                  if (state.todayPrayerTimes != null) {
                    var userSettingsBloc = context.read<UserSettingsBloc>();
                    var oldCalculationMethod =
                        userSettingsBloc.state.calculationMethod;
                    if (oldCalculationMethod.index == -1) {
                      userSettingsBloc.add(
                        CalculationMethodEvent(
                          state.todayPrayerTimes!.calculationMethod,
                        ),
                      );
                    }
                  }

                  if (state.todayPrayerTimes == null ||
                      state.tomorrowPrayerTimes == null) return;

                  // cancel
                  await flutterLocalNotificationsPlugin.cancelAll();

                  const AndroidNotificationDetails
                      androidPlatformChannelSpecifics =
                      AndroidNotificationDetails(
                          'prayers', 'Prayers Notification',
                          channelDescription: 'Notifying prayers',
                          importance: Importance.max,
                          priority: Priority.high,
                          ticker: 'ticker');
                  const DarwinNotificationDetails
                      darwinPlatformChannelSpecifics =
                      DarwinNotificationDetails();
                  const NotificationDetails platformChannelSpecifics =
                      NotificationDetails(
                          android: androidPlatformChannelSpecifics,
                          iOS: darwinPlatformChannelSpecifics);

                  var id = 0;

                  for (var e in state.todayPrayerTimes!.prayerTimes.entries) {
                    var d = tz.TZDateTime.from(
                      e.value,
                      tz.getLocation(state.tomorrowPrayerTimes!.timeZoneName),
                    );
                    ++id;
                    await flutterLocalNotificationsPlugin.zonedSchedule(
                      id,
                      '${e.key.name} Prayer',
                      '${e.key.name} Prayer time',
                      d,
                      platformChannelSpecifics,
                      androidAllowWhileIdle: true,
                      uiLocalNotificationDateInterpretation:
                          UILocalNotificationDateInterpretation.absoluteTime,
                    );
                  }

                  for (var e
                      in state.tomorrowPrayerTimes!.prayerTimes.entries) {
                    var d = tz.TZDateTime.from(
                      e.value,
                      tz.getLocation(state.tomorrowPrayerTimes!.timeZoneName),
                    );
                    ++id;
                    await flutterLocalNotificationsPlugin.zonedSchedule(
                      id,
                      '${e.key.name} Prayer',
                      '${e.key.name} Prayer time',
                      d,
                      platformChannelSpecifics,
                      androidAllowWhileIdle: true,
                      uiLocalNotificationDateInterpretation:
                          UILocalNotificationDateInterpretation.absoluteTime,
                    );
                  }
                });
            },
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (BuildContext context, SettingsState settingsState) {
            var fontFamily = context.read<SettingsBloc>().state.font;
            return MaterialApp(
              onGenerateTitle: (context) {
                Locale activeLocale = Localizations.localeOf(context);
                debugPrint(
                    'Current locale => ${activeLocale.languageCode}'); // en/ar
                debugPrint(activeLocale
                    .countryCode); // => UK or empty for non-country-specific locales
                return AppLocalizations.of(context)!.appTitle;
              },
              locale: settingsState.appLanguage,
              builder: DevicePreview.appBuilder,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: supportedLocales.keys.map((e) => Locale(e, '')),
              theme: CustomTheme.light.copyWith(
                textTheme: ThemeData().textTheme.apply(fontFamily: fontFamily),
              ),
              darkTheme: CustomTheme.dark.copyWith(
                textTheme: ThemeData().textTheme.apply(
                    fontFamily: fontFamily,
                    bodyColor:
                        Theme.of(context).primaryTextTheme.bodyLarge?.color),
              ),
              themeMode: settingsState.appTheme,
              initialRoute: '/',
              routes: {
                '/': (context) => const MainScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
