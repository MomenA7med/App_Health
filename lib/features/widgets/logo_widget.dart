import 'package:flutter/material.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';

class LogoWidget extends StatelessWidget {
  final BoxFit? fit;
  final Color? color;
  const LogoWidget({super.key, this.fit, this.color});

  factory LogoWidget.white({Key? key, BoxFit? fit}) =>
      LogoWidget(fit: fit, key: key, color: AppColors.white);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssetPaths.appLogo,
      fit: fit ?? BoxFit.cover,
      color: color,
    );
  }
}
