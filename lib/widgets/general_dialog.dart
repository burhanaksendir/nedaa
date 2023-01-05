import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> customAlert(BuildContext context, String title, String content,
    {bool showOk = true, bool showCancel = true, dismissible = true}) async {
  var t = AppLocalizations.of(context);
  bool? ret = await showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            showOk
                ? TextButton(
                    child: Text(t!.ok),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                : Container(),
            showCancel
                ? TextButton(
                    child: Text(t!.cancel),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  )
                : Container(),
          ],
        );
      });
  return ret ?? false;
}
