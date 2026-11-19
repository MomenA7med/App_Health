import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

/// Reusable action buttons row for calling and messaging across all details screens
/// (Doctor Details, Hospital Details, Pharmacy Details).
class AppContactActionsWidget extends StatelessWidget {
  final String? phoneNumber;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;
  final String? callTitle;
  final String? messageTitle;
  final String callLocalizationKey;
  final String messageLocalizationKey;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double horizontalSpacing;
  final double verticalPadding;
  final double fontSize;

  const AppContactActionsWidget({
    super.key,
    this.phoneNumber,
    this.onCall,
    this.onMessage,
    this.callTitle,
    this.messageTitle,
    this.callLocalizationKey = LocalizationKeys.call,
    this.messageLocalizationKey = LocalizationKeys.message,
    this.textColor = AppColors.pharmacyChipText,
    this.borderColor = AppColors.cardBorder,
    this.borderWidth = 1.2,
    this.borderRadius = 24.0,
    this.horizontalSpacing = 12.0,
    this.verticalPadding = 10.0,
    this.fontSize = 13.0,
  });

  /// Factory constructor specialized for clinics with the "اتصال بالعيادة" title
  const AppContactActionsWidget.clinic({
    super.key,
    this.phoneNumber,
    this.onCall,
    this.onMessage,
    this.callTitle,
    this.messageTitle,
    this.callLocalizationKey = LocalizationKeys.callClinic,
    this.messageLocalizationKey = LocalizationKeys.message,
    this.textColor = AppColors.pharmacyChipText,
    this.borderColor = AppColors.cardBorder,
    this.borderWidth = 1.2,
    this.borderRadius = 24.0,
    this.horizontalSpacing = 12.0,
    this.verticalPadding = 10.0,
    this.fontSize = 13.0,
  });

  Future<void> _makeCall(BuildContext context) async {
    if (onCall != null) {
      onCall!();
      return;
    }
    final phone = phoneNumber?.trim();
    if (phone == null || phone.isEmpty) return;
    final Uri callUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    }
  }

  Future<void> _sendMessage(BuildContext context) async {
    if (onMessage != null) {
      onMessage!();
      return;
    }
    final phone = phoneNumber?.trim();
    if (phone == null || phone.isEmpty) return;
    final Uri smsUri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Call button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _makeCall(context),
            icon: SvgPicture.asset(
              AppAssetPaths.phoneIcon,
              colorFilter: ColorFilter.mode(
                textColor,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              callTitle ?? context.translate(callLocalizationKey),
              style: TextStyle(
                fontSize: fontSize.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
              side: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius.r),
              ),
            ),
          ),
        ),
        SizedBox(width: horizontalSpacing.w),

        // Message button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _sendMessage(context),
            icon: SvgPicture.asset(
              AppAssetPaths.messageIcon,
              colorFilter: ColorFilter.mode(
                textColor,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              messageTitle ?? context.translate(messageLocalizationKey),
              style: TextStyle(
                fontSize: fontSize.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
              side: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

typedef ContactActionsRowWidget = AppContactActionsWidget;

