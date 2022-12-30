import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nedaa/constants/theme_mode.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    var locale = Localizations.localeOf(context);
    var themeModesNames = themeModes[locale.languageCode] ?? themeModes['en']!;

    return SimpleDialog(
      title: Text(t!.theme),
      children: ThemeMode.values.map((themeMode) {
        return SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, themeMode);
          },
          child: ThemeMode.values.last == themeMode
              ? Text(themeModesNames[themeMode]!)
              : Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(themeModesNames[themeMode]!),
                  ),
                ),
        );
      }).toList(),
    );
  }
}
