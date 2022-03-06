import 'package:flutter/material.dart';
import 'package:iathan/constants/app_constans.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_literals_to_create_immutables
    return SimpleDialog(
      title: Text('Language'),
      children:  supportedLocales.entries.map((entry) {
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
