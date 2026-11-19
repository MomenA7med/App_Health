import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/pharmacy_details/data/models/pharmacy_profile_response_model.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PharmacyAboutTabWidget extends StatelessWidget {
  final PharmacyProfileModel pharmacy;

  const PharmacyAboutTabWidget({
    super.key,
    required this.pharmacy,
  });

  Widget _buildScheduleRow({
    required String days,
    required String hours,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              days,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              hours,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.labelSubtitle,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHours = pharmacy.workingHoursStatus.isNotEmpty
        ? pharmacy.workingHoursStatus
        : (pharmacy.isTwentyFourHours
            ? context.translate(LocalizationKeys.open24Hours)
            : context.translate(LocalizationKeys.openNow));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. About Pharmacy
          if (pharmacy.aboutText.isNotEmpty) ...[
            Text(
              context.translate(LocalizationKeys.aboutPharmacy),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              pharmacy.aboutText,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.6,
                color: AppColors.labelSubtitle,
              ),
            ),
            SizedBox(height: 20.h),
            const Divider(color: AppColors.borderSubtle, thickness: 1),
            SizedBox(height: 16.h),
          ],

          // 2. Working Hours Schedule
          Text(
            context.translate(LocalizationKeys.workingHours),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonBlackTextColor,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderLight, width: 1.0),
            ),
            child: Column(
              children: [
                _buildScheduleRow(
                  days: context.translate(LocalizationKeys.saturdayToThursday),
                  hours: effectiveHours,
                ),
                const Divider(
                  color: AppColors.borderLight,
                  thickness: 1,
                  height: 1,
                ),
                _buildScheduleRow(
                  days: context.translate(LocalizationKeys.friday),
                  hours: effectiveHours,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
