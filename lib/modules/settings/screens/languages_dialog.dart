import 'package:flutter/material.dart';
import 'package:nedaa/constants/app_constans.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    var dividerColor = Theme.of(context).dividerColor;
    return SimpleDialog(
      title: Text(t!.language),
      children: supportedLocales.entries.map((entry) {
        return SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, entry.key);
          },
          child: supportedLocales.entries.last.key == entry.key
              ? Text(entry.value)
              : Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Text(entry.value),
                ),
        );
      }).toList(),
    );
  }
}
