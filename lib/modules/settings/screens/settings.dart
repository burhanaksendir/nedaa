import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iathan/constants/app_constans.dart';
import 'package:iathan/constants/calculation_methods.dart';
import 'package:iathan/modules/settings/bloc/settings_bloc.dart';
import 'package:iathan/modules/settings/bloc/user_settings_bloc.dart';
import 'package:iathan/modules/settings/models/calcualtiom_method.dart';
import 'package:iathan/modules/settings/screens/calculation_methods_dialog.dart';
import 'package:iathan/modules/settings/screens/languages_dialog.dart';
import 'package:iathan/modules/settings/screens/location.dart';
import 'package:iathan/modules/settings/screens/notification.dart';
import 'package:iathan/modules/settings/screens/theme_dialog.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool lockInBackground = false;
  bool notificationsEnabled = false;

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
        methods[_currentCalculationMethod?.index];
    var _currentUserCity = _currentUserState.location?.cityAddress;

    return SettingsList(
      sections: [
        SettingsSection(
          title: Text(t!.settings),
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
              trailing: Text(_currentCalculationMethodName ?? t.defaultString),
              leading: const Icon(Icons.access_time_filled),
              onPressed: (context) async {
                final calculationMethod = await showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => const CalculationMethodsDialog(),
                );
                if (calculationMethod is CalculationMethod) {
                  context
                      .read<UserSettingsBloc>()
                      .add(CalculationMethodEvent(calculationMethod));
                }
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text(t.contactUs),
          tiles: [
            // TODO: forward to creating new email
            SettingsTile(
              title: const Text('support@iathan.app'),
              leading: const Icon(Icons.email),
            ),
            // TODO: forward to open the page in the browser
            SettingsTile(
              title: const Text('https://iathan.app'),
              leading: const Icon(Icons.public),
            ),
          ],
        ),
      ],
    );
  }
}
