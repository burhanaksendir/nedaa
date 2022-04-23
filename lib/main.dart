import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nedaa/constants/app_constans.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nedaa/constants/theme.dart';
import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/prayer_times/repositories/prayer_times_repository.dart';
import 'package:nedaa/modules/settings/bloc/settings_bloc.dart';
import 'package:nedaa/modules/settings/bloc/user_settings_bloc.dart';
import 'package:nedaa/modules/settings/repositories/settings_repository.dart';
import 'package:nedaa/screens/main_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SettingsRepository settingsRepository = SettingsRepository(
    await SharedPreferences.getInstance(),
  );

  tz.initializeTimeZones();

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
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.settingsRepository}) : super(key: key);
  final SettingsRepository settingsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: settingsRepository),
        RepositoryProvider(create: (context) => PrayerTimesRepository())
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
              return PrayerTimesBloc(context.read<PrayerTimesRepository>())
                ..add(FetchPrayerTimesEvent(userLocation, calculationMethod))
                // this listens to all updates in prayer times and sets
                // calculation method to the default value we got from the API
                // if it is not set yet
                ..stream.forEach((state) {
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
                    'Current locale => ' + activeLocale.languageCode); // en/ar
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
                textTheme: ThemeData().textTheme.apply(fontFamily: fontFamily),
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
