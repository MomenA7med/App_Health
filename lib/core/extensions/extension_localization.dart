import 'package:flutter/material.dart';
import 'package:app_health/utils/locale/app_localization.dart';

extension ExtensionLocalization on BuildContext {
  AppLocalizations get appLocale => AppLocalizations.of(this)!;
  String get languageCode => appLocale.locale.languageCode;

  String translate(String localizationKeys) {
    return appLocale.translate(localizationKeys) ?? localizationKeys;
  }

  String getArabic(String localizationKeys) {
    return appLocale.getArabic(localizationKeys) ?? localizationKeys;
  }

  String getEnglish(String localizationKeys) {
    return appLocale.getEnglish(localizationKeys) ?? localizationKeys;
  }

  bool get isEnglish {
    return appLocale.locale.languageCode == codeEn;
  }

  String get languageKey {
    return appLocale.locale.languageCode;
  }
}
