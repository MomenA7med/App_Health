import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class AppBadgeWidget extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;

  const AppBadgeWidget({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.surfaceMuted,
    this.textColor = AppColors.textSecondaryColor,
    this.icon,
    this.padding,
    this.borderRadius = 16,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
  });

  factory AppBadgeWidget.insurance({
    Key? key,
    required BuildContext context,
    Color backgroundColor = AppColors.lightBlue,
    Color textColor = AppColors.textSecondaryColor,
  }) {
    return AppBadgeWidget(
      key: key,
      text: context.translate(LocalizationKeys.acceptsInsurance),
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  factory AppBadgeWidget.workingHours({
    Key? key,
    required String status,
    Widget? icon,
    Color backgroundColor = AppColors.colorSecondary,
    Color textColor = AppColors.textSecondaryColor,
  }) {
    return AppBadgeWidget(
      key: key,
      text: status,
      icon: icon,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(width: 6.w),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize.sp,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

