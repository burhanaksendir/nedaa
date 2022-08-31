import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const arabicDigits = [
  "٠",
  "١",
  "٢",
  "٣",
  "٤",
  "٥",
  "٦",
  "٧",
  "٨",
  "٩",
];

String translateToArabicDigits(String input) {
  var outputCodeUnits = List<int>.filled(input.length, 0);
  var inputCodeUnits = input.codeUnits;
  var asciiZeroCodeUnit = "0".codeUnitAt(0);
  var arabicZeroCodeUnit = arabicDigits[0].codeUnitAt(0);

  for (var i = 0; i < inputCodeUnits.length; i++) {
    var codeUnit = inputCodeUnits[i];
    if (codeUnit >= asciiZeroCodeUnit && codeUnit <= (asciiZeroCodeUnit + 9)) {
      outputCodeUnits[i] = arabicZeroCodeUnit + (codeUnit - asciiZeroCodeUnit);
    } else {
      outputCodeUnits[i] = codeUnit;
    }
  }
  return String.fromCharCodes(outputCodeUnits);
}

String translateNumber(AppLocalizations t, String input) {
  if (t.localeName.split('_')[0] == "ar") {
    return translateToArabicDigits(input);
  } else {
    return input;
  }
}
