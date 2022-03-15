import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iathan/constants/calculation_methods.dart';
import 'package:iathan/modules/settings/models/calcualtiom_method.dart';

class CalculationMethodsDialog extends StatelessWidget {
  const CalculationMethodsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    var locale = Localizations.localeOf(context);
    var methods =
        calculation_methods[locale.languageCode] ?? calculation_methods['en']!;

    return SimpleDialog(
      title: Text(t!.calculationMethods),
      children: methods.entries.map((entry) {
        return SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, CalculationMethod(entry.key, entry.value));
          },
          child: Text(entry.value),
        );
      }).toList(),
    );
  }
}
