import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/features/widgets/app_badge_widget.dart';
import 'package:app_health/features/widgets/app_contact_actions_widget.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/extensions/extension_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorDetailsClinicCardWidget extends StatelessWidget {
  final DoctorProfileModel doctor;

  const DoctorDetailsClinicCardWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges: Top rated & Accepts insurance
        Row(
          children: [
            if (doctor.ratingAverage >= 4.5) ...[
              AppBadgeWidget(
                text: context.translate(LocalizationKeys.topRated),
                backgroundColor: AppColors.badgeGreenBg,
                textColor: AppColors.badgeGreenText,
              ),
              SizedBox(width: 8.w),
            ],
            if (doctor.acceptsPatientInsurance) ...[
              AppBadgeWidget.insurance(
                context: context,
                textColor: AppColors.colorPrimary,
              ),
            ],
          ],
        ),
        SizedBox(height: 14.h),

        // Clinic Box
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              // Clinic Icon
              ClipOval(
                child: SvgPicture.asset(
                  AppAssetPaths.clinicIcon,
                  width: 44.r,
                  height: 44.r,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),

              // Clinic details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.clinicName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonBlackTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${doctor.cityLocation ?? doctor.clinicAddress}${doctor.distanceKm != null ? ' • على بعد ${doctor.distanceKm} كم' : ''}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Chevron Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.r,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),

        // Action Buttons Row: Call Clinic & Message
        AppContactActionsWidget.clinic(
          phoneNumber: doctor.phoneNumber,
        ),
      ],
    );
  }
}
