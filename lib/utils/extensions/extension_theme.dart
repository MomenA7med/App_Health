import 'package:flutter/material.dart';

extension ThemesValuesExtension on BuildContext {
  ThemeData get themeData => Theme.of(this);

  TextTheme get textTheme => themeData.textTheme;

  TextStyle? get displayLarge => themeData.textTheme.displayLarge;
  TextStyle? get displayMedium => themeData.textTheme.displayMedium;
  TextStyle? get displaySmall => themeData.textTheme.displaySmall;

  /// Headline styles are smaller than display styles.
  /// They're best-suited for short, high-emphasis text on smaller screens.
  TextStyle? get headlineLarge => themeData.textTheme.headlineLarge;
  TextStyle? get headlineMedium => themeData.textTheme.headlineMedium;
  TextStyle? get headlineSmall => themeData.textTheme.headlineSmall;

  /// Titles are smaller than headline styles
  /// and should be used for shorter, medium-emphasis text.
  TextStyle? get titleLarge => themeData.textTheme.titleLarge;
  TextStyle? get titleMedium => themeData.textTheme.titleMedium;
  TextStyle? get titleSmall => themeData.textTheme.titleSmall;

  TextStyle? get bodyLarge => themeData.textTheme.bodyLarge;
  TextStyle? get bodyMedium => themeData.textTheme.bodyMedium;
  TextStyle? get bodySmall => themeData.textTheme.bodySmall;
}
