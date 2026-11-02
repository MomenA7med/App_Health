import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_health/res/app_colors.dart';

abstract class BaseAppTheme {
  ThemeData get themeDataLight;

  TextTheme get txtThemeLight;

  ThemeData get themeDataDark;

  TextTheme get txtTheme;

  TextStyle get txtTextStyle;

  static TextTheme get defaultTextTheme =>
      GoogleFonts.alexandriaTextTheme(const TextTheme());
  static TextStyle get defaultTextStyle => GoogleFonts.alexandria();
  static String get defaultFontFamily =>
      GoogleFonts.alexandria().fontFamily!;
}

class LightAppTheme implements BaseAppTheme {
  /// The Light Theme
  @override
  ThemeData get themeDataLight {
    return ThemeData(
      brightness: Brightness.light,
      textTheme: txtThemeLight,
      fontFamily: BaseAppTheme.defaultFontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.colorSchemeSeed,
        primary: AppColors.colorPrimary,
      ),
      primaryColor: AppColors.colorPrimary,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      iconTheme: ThemeData.light().iconTheme.copyWith(
        color: AppColors.iconTheme,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: AppColors.floatActionBtnForegroundColor,
        backgroundColor: AppColors.floatActionBtnBackgroundColor,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bottomNavigationBarBackground,
      ),
      cardTheme: ThemeData.light().cardTheme.copyWith(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        ),
        iconTheme: ThemeData.light().iconTheme.copyWith(
          color: AppColors.appBarIconColor,
        ),
        titleTextStyle: txtThemeLight.titleMedium?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.appBarTextColor,
        ),
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.appBarBackground,
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: AppColors.checkboxBorder, width: 1),
      ),
    );
  }

  @override
  TextTheme get txtThemeLight => txtTheme.copyWith(
    // Sherpa Blue
    bodyMedium: txtTheme.bodyMedium?.copyWith(color: AppColors.bodyMedium),
    titleMedium: txtTheme.titleMedium?.copyWith(color: AppColors.titleMedium),
    labelMedium: txtTheme.labelMedium?.copyWith(color: AppColors.labelMedium),
    headlineMedium: txtTheme.headlineMedium?.copyWith(
      color: AppColors.headlineMedium,
    ),
    bodyLarge: txtTheme.bodyLarge?.copyWith(color: AppColors.bodyLarge),
    titleSmall: txtTheme.titleSmall?.copyWith(color: AppColors.titleSmall),
    labelSmall: txtTheme.labelSmall?.copyWith(color: AppColors.labelSmall),
    displaySmall: txtTheme.displaySmall?.copyWith(
      color: AppColors.displaySmall,
    ),
  );

  @override
  ThemeData get themeDataDark => themeDataLight;

  @override
  TextTheme get txtTheme => BaseAppTheme.defaultTextTheme;

  @override
  TextStyle get txtTextStyle => BaseAppTheme.defaultTextStyle;
}
