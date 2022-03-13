import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CommonCardHeader extends StatefulWidget {
  const CommonCardHeader({Key? key}) : super(key: key);

  @override
  State<CommonCardHeader> createState() => _CommonCardHeaderState();
}

class _CommonCardHeaderState extends State<CommonCardHeader> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    final todaysDate =
        DateFormat('EEEE\n d MMMM y', t!.localeName).format(DateTime.now());
    return Column(
      children: <Widget>[
        Text(
          todaysDate,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 20),
        Text(
          "Kuala Lumpur",
          style: Theme.of(context).textTheme.headline5,
        ),
        const Divider(
          thickness: 1,
          height: 108,
          color: Colors.black,
        ),
      ],
    );
  }
}
