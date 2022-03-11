import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return SimpleDialog(
      title: Text(t!.theme),
      children: ThemeMode.values.map((themeMode) {
        return SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, themeMode);
          },
          child: Text(themeMode.name),
        );
      }).toList(),
    );
  }
}
