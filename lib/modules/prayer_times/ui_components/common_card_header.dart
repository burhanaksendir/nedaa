import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nedaa/modules/settings/bloc/user_settings_bloc.dart';
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
    var currentUserState = context.watch<UserSettingsBloc>().state;
    var currentUserCity = currentUserState.location.cityAddress;

    return Column(
      children: <Widget>[
        Text(
          todaysDate,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Divider(
                color: Theme.of(context).dividerColor,
                thickness: 2,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
            Text(
              currentUserCity ?? '',
              style: Theme.of(context).textTheme.headline5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(context).dividerColor,
                thickness: 2,
              ),
            )
          ],
        )
      ],
    );
  }
}
