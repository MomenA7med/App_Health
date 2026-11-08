import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/extensions/extension_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorDetailsClinicCardWidget extends StatelessWidget {
  final DoctorProfileModel doctor;

  const DoctorDetailsClinicCardWidget({
    super.key,
    required this.doctor,
  });

  Future<void> _makeCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    }
  }

  Future<void> _sendMessage(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges: Top rated & Accepts insurance
        Row(
          children: [
            if (doctor.ratingAverage >= 4.5) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.badgeGreenBg,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  context.translate(LocalizationKeys.topRated),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.badgeGreenText,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
            if (doctor.acceptsPatientInsurance) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  context.translate(LocalizationKeys.acceptsInsurance),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorPrimary,
                  ),
                ),
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
                Directionality.of(context) == TextDirection.ltr
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                size: 22.r,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),

        // Action Buttons Row: Call Clinic & Message
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _makeCall(doctor.phoneNumber),
                icon: Icon(
                  Icons.phone_outlined,
                  size: 18.r,
                  color: AppColors.colorPrimary,
                ),
                label: Text(
                  context.translate(LocalizationKeys.callClinic),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorPrimary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  side: const BorderSide(
                    color: AppColors.colorPrimary,
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _sendMessage(doctor.phoneNumber),
                icon: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 18.r,
                  color: AppColors.colorPrimary,
                ),
                label: Text(
                  context.translate(LocalizationKeys.message),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorPrimary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  side: const BorderSide(
                    color: AppColors.colorPrimary,
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

