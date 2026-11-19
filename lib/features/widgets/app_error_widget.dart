import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class AppErrorWidget extends StatelessWidget {
  final String errorMessage;
  final bool isLocalizationKey;
  final VoidCallback? onRetry;
  final String? retryTitle;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const AppErrorWidget({
    super.key,
    required this.errorMessage,
    this.isLocalizationKey = false,
    this.onRetry,
    this.retryTitle,
    this.icon = Icons.error_outline_rounded,
    this.iconColor,
    this.iconSize,
    this.textColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMessage = isLocalizationKey
        ? context.translate(errorMessage)
        : errorMessage;

    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize ?? 56.r,
              color: iconColor ?? AppColors.errorRed,
            ),
            SizedBox(height: 16.h),
            Text(
              effectiveMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize ?? 14.sp,
                color: textColor ?? AppColors.labelSubtitle,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 16.h),
              AppElevatedButton.withTitle(
                title: retryTitle ?? context.translate(LocalizationKeys.retry),
                color: AppColors.colorPrimary,
                textColor: AppColors.white,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

