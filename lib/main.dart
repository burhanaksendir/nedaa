import 'package:flutter/material.dart';
import 'package:iathan/screens/main.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) {
        Locale activeLocale = Localizations.localeOf(context);
        debugPrint('Current locale => ' + activeLocale.languageCode); // en/ar
        debugPrint(activeLocale
            .countryCode); // => UK or empty for non-country-specific locales
        return AppLocalizations.of(context)!.appTitle;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        /* Flutter try to match the locale of the device,
        if it's not found in the list of supported locales. 
        the default locale is the first one in the list.*/
        Locale('en', ''),
        Locale('ar', ''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const MainScreen(),
      },
    );
  }
}
