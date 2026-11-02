import 'package:flutter/services.dart';

void showStatusBar() async {
  /// to show status and navigation bar again
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
}

void setStatusBarColor({required Color color, Brightness? brightness}) {
  showStatusBar();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: color,
      statusBarIconBrightness: brightness ?? Brightness.light,
    ),
  );
}

void hideStatusBar() async {
  /// to make screen -> full
  /// hidden status bar in splash screen

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
}
