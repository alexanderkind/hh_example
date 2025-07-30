import 'package:hh_example/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension Localization on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}

extension AppLocalizationsExtension on AppLocalizations {
  // TODO(alexanderkind): Можно доработать по локализации
  String ordinalPostfix(int number) {
    var postfix = '';
    if (number >= 4 && number <= 20) {
      postfix = 'th';
    } else {
      final numberText = number.toString();
      final lastNumber = int.parse(numberText[numberText.length - 1]);
      postfix = switch (lastNumber) {
        0 => 'o',
        1 => 'st',
        2 => 'nd',
        3 => 'rd',
        _ => 'th',
      };
    }

    return '$number-$postfix';
  }
}
