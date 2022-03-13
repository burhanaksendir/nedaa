import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iathan/constants/app_constans.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iathan/constants/theme.dart';
import 'package:iathan/modules/settings/screens/bloc/settings_bloc.dart';
import 'package:iathan/modules/settings/screens/bloc/settings_state.dart';
import 'package:iathan/screens/main_screen.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(),
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
    );
  }
}
