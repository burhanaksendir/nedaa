import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iathan/constants/app_constans.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iathan/constants/theme.dart';
import 'package:iathan/modules/settings/bloc/settings_bloc.dart';
import 'package:iathan/modules/settings/bloc/user_settings_bloc.dart';
import 'package:iathan/modules/settings/repositories/settings_repository.dart';
import 'package:iathan/screens/main_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SettingsRepository settingsRepository = SettingsRepository(
    await SharedPreferences.getInstance(),
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>
          MyApp(settingsRepository: settingsRepository), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.settingsRepository}) : super(key: key);
  final SettingsRepository settingsRepository;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: settingsRepository,
      child: MultiBlocProvider(
        // create: (context) => SettingsBloc(),
        providers: [
          BlocProvider(
            create: (context) =>
                SettingsBloc(context.read<SettingsRepository>()),
          ),
          BlocProvider(
            create: (context) => UserSettingsBloc(),
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (BuildContext context, SettingsState settingsState) {
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
              theme: CustomTheme.light,
              darkTheme: CustomTheme.dark,
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
