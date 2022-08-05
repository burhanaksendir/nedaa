import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nedaa/modules/settings/bloc/user_settings_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nedaa/utils/helper.dart';

class CommonCardHeader extends StatefulWidget {
  const CommonCardHeader({Key? key}) : super(key: key);

  @override
  State<CommonCardHeader> createState() => _CommonCardHeaderState();
}

class _CommonCardHeaderState extends State<CommonCardHeader> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    var currentUserState = context.watch<UserSettingsBloc>().state;
    var currentUserCity = currentUserState.location.cityAddress;
    var timezone = currentUserState.timezone;
    var tzDateTime = getCurrentTimeWithTimeZone(timezone);
    final todaysDate = DateFormat('EEEE\n d MMMM y', t!.localeName)
        .format(tzDateTime);

    return Column(
      children: <Widget>[
        Text(
          todaysDate,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Divider(
                color: Theme.of(context).dividerColor,
                thickness: 2,
              ),
            ),
            Padding(
                padding: MediaQuery.of(context).size == Size.zero
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.all(8)),
            Text(
              currentUserCity ?? '',
              style: MediaQuery.of(context).size.width > 600
                  ? Theme.of(context).textTheme.headline6
                  : Theme.of(context).textTheme.headline5,
            ),
            Padding(
              padding: MediaQuery.of(context).size == Size.zero
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.all(8),
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
