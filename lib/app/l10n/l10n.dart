// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum LanguageType {
  English(Locale('en'), 'English'),
  Vietnamese(Locale('vi'), 'TIếng Việt');

  final Locale locale;
  final String nameLanguage;
  const LanguageType(this.locale, this.nameLanguage);
}

class L10n {
  static final all = LanguageType.values.map(
    (e) => e.locale,
  );
}

///S.of(context). .... Để lấy ngôn ngữ
class S {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}
