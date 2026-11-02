import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/local_storage/local_storage_manager.dart';
import 'package:app_health/logic/user_manager.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class LocaleCubit extends Cubit<Locale> {
  final LocalStorageManager localStorageManager;

  LocaleCubit(this.localStorageManager) : super(LocaleApp.en.toLocale()) {
    getDefaultLocale();
  }

  void changeLocale(LocaleApp selectedLanguage) async {
    final defaultLanguageCode = await localStorageManager.getLocale();

    if (selectedLanguage == LocaleApp.ar && defaultLanguageCode != codeArSA) {
      emit(LocaleApp.ar.toLocale());
      await localStorageManager.setLocale(
        selectedLanguage.mapToPreferenceKey(),
      );
    } else if (selectedLanguage == LocaleApp.en &&
        defaultLanguageCode != codeArSA) {
      emit(LocaleApp.en.toLocale());
      await localStorageManager.setLocale(
        selectedLanguage.mapToPreferenceKey(),
      );
    }
  }

  void getDefaultLocale() async {
    final defaultLanguageCode = await localStorageManager.getLocale();
    // const defaultLanguageCode = null;
    Locale locale;
    if (defaultLanguageCode == null) {
      locale = LocaleApp.en.toLocale();
      await localStorageManager.setLocale(
        LocaleApp.mapFromString(locale.languageCode).mapToPreferenceKey(),
      );
    } else {
      if (defaultLanguageCode == codeEn) {
        locale = LocaleApp.en.toLocale();
        Locale(defaultLanguageCode);
        await localStorageManager.setLocale(
          LocaleApp.mapFromString(locale.languageCode).mapToPreferenceKey(),
        );
      } else {
        locale = LocaleApp.ar.toLocale();
        await localStorageManager.setLocale(
          LocaleApp.mapFromString(locale.languageCode).mapToPreferenceKey(),
        );
      }
    }
    GetIt.I<UserMangers>().setLocaleApp(
      LocaleApp.mapFromString(locale.languageCode),
    );
    emit(locale);
  }

  Locale get defaultSystemLocale =>
      LocaleApp.mapFromString(Platform.localeName.substring(0, 2)).toLocale();
}

enum LocaleApp {
  en,
  ar;

  String mapToApiKey() {
    switch (this) {
      case LocaleApp.en:
        return codeEnUS;
      case LocaleApp.ar:
        return codeArSA;
    }
  }

  Locale toLocale() {
    switch (this) {
      case LocaleApp.en:
        return const Locale(codeEn, codeUs);

      case LocaleApp.ar:
        return const Locale(codeAr, codeSa);
    }
  }

  static LocaleApp mapFromString(String languageCode) {
    switch (languageCode) {
      case codeEn:
        return LocaleApp.en;
      case codeAr:
        return LocaleApp.ar;
      default:
        return LocaleApp.ar;
    }
  }

  static String appLocalizationsKey(String languageCode) {
    switch (languageCode) {
      case codeEn:
        return LocalizationKeys.english;
      case codeAr:
        return LocalizationKeys.arabic;
      default:
        return LocalizationKeys.arabic;
    }
  }

  static String iconAssetPath(String languageCode) {
    switch (languageCode) {
      case codeEn:
        return AppAssetPaths.ukFlagIcon;
      case codeAr:
        return AppAssetPaths.uaeFlagIcon;
      default:
        return AppAssetPaths.uaeFlagIcon;
    }
  }

  String mapToPreferenceKey() {
    switch (this) {
      case LocaleApp.en:
        return codeEn;
      case LocaleApp.ar:
        return codeAr;
    }
  }
}
