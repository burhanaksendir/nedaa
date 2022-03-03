import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CommonCardHeader extends StatefulWidget {
  const CommonCardHeader({Key? key}) : super(key: key);

  @override
  State<CommonCardHeader> createState() => _CommonCardHeaderState();
}

class _CommonCardHeaderState extends State<CommonCardHeader> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Column(
      children: <Widget>[
          Text(
            "${t!.monday}\n02 February 2022",
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