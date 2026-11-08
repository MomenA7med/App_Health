import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/extensions/extension_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorAboutTabWidget extends StatelessWidget {
  final DoctorProfileModel doctor;

  const DoctorAboutTabWidget({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: About the doctor
        Text(
          context.translate(LocalizationKeys.aboutTheDoctor),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonBlackTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          doctor.aboutText ?? '',
          style: TextStyle(
            fontSize: 14.sp,
            height: 1.6,
            color: AppColors.textDescription,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 16.h),
        const Divider(color: AppColors.borderLight, thickness: 1),
        SizedBox(height: 16.h),

        // Section 2: Qualifications & Experience
        Text(
          context.translate(LocalizationKeys.qualificationsAndExperience),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonBlackTextColor,
          ),
        ),
        SizedBox(height: 10.h),
        if (doctor.qualifications.isNotEmpty)
          ...doctor.qualifications.map(
            (qualification) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6.h),
                    width: 6.r,
                    height: 6.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      qualification,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textDescription,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Text(
            '—',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        SizedBox(height: 16.h),
        const Divider(color: AppColors.borderLight, thickness: 1),
        SizedBox(height: 16.h),

        // Section 3: Clinic Working Hours
        Text(
          context.translate(LocalizationKeys.clinicWorkingHours),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonBlackTextColor,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 20.r,
                color: AppColors.colorPrimary,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  doctor.workingHours ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.buttonBlackTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

