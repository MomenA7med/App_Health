import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';

SnackBar createSnackBar(String message) {
  return SnackBar(duration: const Duration(seconds: 2), content: Text(message));
}

void showSnackBarWithContext(SnackBar snackBar, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showSnackBarMassage(
  String message,
  BuildContext context, {
  SnackBarType type = SnackBarType.normal,
}) {
  switch (type) {
    case SnackBarType.normal:
      showSnackBarWithContext(createSnackBar(message), context);

    case SnackBarType.success:
      showSnackBarWithContext(createSuccessSnackBar(message), context);
  }
}

SnackBar createSuccessSnackBar(String message) {
  return SnackBar(
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.successSnackBg,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
    content: Row(
      children: [
        SvgPicture.asset(AppAssetPaths.checkmarkIcon),
        SizedBox(width: 8),
        Text(message, style: TextStyle(color: AppColors.successSnackText)),
      ],
    ),
  );
}

enum SnackBarType { normal, success }
