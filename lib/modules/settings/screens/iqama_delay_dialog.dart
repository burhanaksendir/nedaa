import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IqamaDelayDialog extends StatefulWidget {
  const IqamaDelayDialog({Key? key, required this.inputDelay})
      : super(key: key);

  final int inputDelay;

  @override
  State<IqamaDelayDialog> createState() => _IqamaDelayDialogState();
}

class _IqamaDelayDialogState extends State<IqamaDelayDialog> {
  int _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.inputDelay.clamp(1, 30);
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return SimpleDialog(title: Text(t!.iqamaDelayTime), children: [
      Center(
          child: Text(
        _currentSliderValue.toInt().toString(),
      )),
      Slider(
        value: _currentSliderValue.toDouble(),
        min: 1,
        max: 30,
        label: _currentSliderValue.toInt().toString(),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value.toInt();
          });
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _currentSliderValue);
            },
            child: Text(t.ok),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text(t.cancel),
          ),
        ],
      ),
    ]);
  }
}
