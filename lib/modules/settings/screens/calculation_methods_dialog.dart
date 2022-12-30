import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nedaa/constants/calculation_methods.dart';
import 'package:nedaa/modules/settings/models/calculation_method.dart';

class CalculationMethodsDialog extends StatelessWidget {
  const CalculationMethodsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    var locale = Localizations.localeOf(context);
    var methods =
        calculationMethods[locale.languageCode] ?? calculationMethods['en']!;
    var dividerColor = Theme.of(context).dividerColor;

    return SimpleDialog(
      title: Text(t!.calculationMethod),
      children: methods.entries.map((entry) {
        return SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, CalculationMethod(entry.key));
          },
          child:
          methods.length - 1 == entry.key
              ? Text(entry.value)
              : Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  // use the theme's divider color using the Theme.of(context).dividerColor
                  color: dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(entry.value),
            ),
          ),
        );
      }).toList(),
    );
  }
}
