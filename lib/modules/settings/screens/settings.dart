import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nedaa/constants/app_constans.dart';
import 'package:nedaa/constants/calculation_methods.dart';
import 'package:nedaa/modules/prayer_times/bloc/prayer_times_bloc.dart';
import 'package:nedaa/modules/settings/bloc/settings_bloc.dart';
import 'package:nedaa/modules/settings/bloc/user_settings_bloc.dart';
import 'package:nedaa/modules/settings/models/calcualtion_method.dart';
import 'package:nedaa/modules/settings/models/user_location.dart';
import 'package:nedaa/modules/settings/screens/calculation_methods_dialog.dart';
import 'package:nedaa/modules/settings/screens/languages_dialog.dart';
import 'package:nedaa/modules/settings/screens/location.dart';
import 'package:nedaa/modules/settings/screens/notification.dart';
import 'package:nedaa/modules/settings/screens/theme_dialog.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool lockInBackground = false;
  bool notificationsEnabled = false;
  static const email = 'support@nedaa.io';
  static const website = 'https://nedaa.io';

  _updateAddressTranslation(BuildContext context, Location _currentUserLocation,
      String language) async {
    Placemark placemark = await placemarkFromCoordinates(
            _currentUserLocation.latitude, _currentUserLocation.longitude,
            localeIdentifier: language)
        .then((value) => value[0]);

    context.read<UserSettingsBloc>().add(
          UserLocationEvent(
            UserLocation(
              location: _currentUserLocation,
              city: placemark.locality,
              country: placemark.country,
              state: placemark.administrativeArea,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    var _currentAppState = context.watch<SettingsBloc>().state;
    var _stateLocale = _currentAppState.appLanguage!.languageCode;

    var _currentLocale = supportedLocales[_stateLocale];
    var _currentTheme = _currentAppState.appTheme;

    var _currentUserState = context.watch<UserSettingsBloc>().state;
    var _currentCalculationMethod = _currentUserState.calculationMethod;
    var locale = Localizations.localeOf(context);
    var methods =
        calculationMethods[locale.languageCode] ?? calculationMethods['en']!;

    var _currentCalculationMethodName =
        methods[_currentCalculationMethod.index];
    var _currentUserCity = _currentUserState.location.cityAddress;

    var _currentUserLocation = _currentUserState.location.location;

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(t!.appTitle),
          centerTitle: true,
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Text(t.settings),
              tiles: [
                SettingsTile(
                  title: Text(t.language),
                  trailing: Text(_currentLocale!),
                  leading: const Icon(Icons.language),
                  onPressed: (context) async {
                    final language = await showCupertinoDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => const LanguageDialog(),
                    );
                    if (language is String) {
                      context
                          .read<SettingsBloc>()
                          .add(LanguageEvent(Locale(language)));

                      // update address language
                      _updateAddressTranslation(
                          context, _currentUserLocation!, language);
                    }
                  },
                ),
                SettingsTile(
                  title: Text(t.theme),
                  trailing: Text(_currentTheme!.name),
                  leading: const Icon(Icons.color_lens),
                  onPressed: (context) async {
                    final themeMode = await showCupertinoDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => const ThemeDialog(),
                    );
                    if (themeMode is ThemeMode) {
                      context.read<SettingsBloc>().add(ThemeEvent(themeMode));
                    }
                  },
                ),
                SettingsTile(
                  title: Text(t.location),
                  trailing: Text(_currentUserCity ?? ""),
                  leading: const Icon(Icons.room),
                  onPressed: (context) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LocationSettings(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  title: Text(t.notification),
                  leading: const Icon(Icons.notifications),
                  onPressed: (context) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationScreen(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  title: Text(t.calculationMethods),
                  trailing: Text(_currentCalculationMethodName!.length > 25
                      ? _currentCalculationMethodName.substring(0, 25) + '...'
                      : _currentCalculationMethodName),
                  leading: const Icon(Icons.access_time_filled),
                  onPressed: (context) async {
                    final calculationMethod = await showCupertinoDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => const CalculationMethodsDialog(),
                    );
                    if (calculationMethod is CalculationMethod) {
                      var userSettingsBloc = context.read<UserSettingsBloc>();

                      userSettingsBloc
                          .add(CalculationMethodEvent(calculationMethod));

                      context.read<PrayerTimesBloc>().add(FetchPrayerTimesEvent(
                          userSettingsBloc.state.location, calculationMethod));
                    }
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text(t.contactUs),
              tiles: [
                SettingsTile(
                  title: const Text(email),
                  leading: const Icon(Icons.email),
                  onPressed: (context) async {
                    EmailContent emailContent = EmailContent(to: [
                      email,
                    ]);
                    // Android: Will open mail app or show native picker.
                    // iOS: Will open mail app if single mail app found.
                    var result = await OpenMailApp.composeNewEmailInMailApp(
                      emailContent: emailContent,
                    );
                    // If no mail apps found, show error
                    if (!result.didOpen && !result.canOpen) {
                      showNoMailAppsDialog(context);

                      // iOS: if multiple mail apps found, show dialog to select.
                      // There is no native intent/default app system in iOS so
                      // you have to do it yourself.
                    } else if (!result.didOpen && result.canOpen) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return MailAppPickerDialog(
                            mailApps: result.options,
                            title: t.selectMailApp,
                            emailContent: emailContent,
                          );
                        },
                      );
                    }
                  },
                ),
                SettingsTile(
                  onPressed: (context) async {
                    if (!await launch(website)) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(t.error),
                            content: Text(t.unableToLunchLink),
                            actions: [
                              TextButton(
                                child: Text(t.ok),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  title: RichText(
                    text: const TextSpan(
                      text: website,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  leading: const Icon(Icons.public),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showNoMailAppsDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(""),
          content: Text(AppLocalizations.of(context)!.noMailAppFound),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.ok),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}
