import 'package:flutter/material.dart';
import 'package:iathan/constants/app_constans.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return SimpleDialog(
      title: Text(t!.language),
      children: supportedLocales.entries.map((entry) {
        return SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, entry.key);
          },
          child: Text(entry.value),
        );
      }).toList(),
    );
  }
}
