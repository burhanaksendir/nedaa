import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> customAlert(
    BuildContext context, String title, String content) async {
  var t = AppLocalizations.of(context);

  bool? ret = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(t!.ok),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text(t.cancel),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            )
          ],
        );
      });
  return ret ?? false;
}
