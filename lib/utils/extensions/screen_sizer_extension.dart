import 'package:flutter/material.dart';

extension ScreenSizerExtension on BuildContext {
  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  double get width => mediaQueryData.size.width;
  double get height => mediaQueryData.size.height;
  Orientation get orientation => mediaQueryData.orientation;

  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
}
