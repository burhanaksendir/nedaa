import 'package:flutter/material.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Theme'),
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
