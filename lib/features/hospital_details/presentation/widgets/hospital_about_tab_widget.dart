import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/hospital_details/data/models/hospital_profile_response_model.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class HospitalAboutTabWidget extends StatelessWidget {
  final HospitalProfileModel hospital;

  const HospitalAboutTabWidget({
    super.key,
    required this.hospital,
  });

  @override
  Widget build(BuildContext context) {
    final services = hospital.services;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: "نبذة عن المستشفى"
          Text(
            context.translate(LocalizationKeys.aboutTheHospital),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonBlackTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            hospital.aboutText.isNotEmpty
                ? hospital.aboutText
                : context.translate(LocalizationKeys.aboutTheHospital),
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.6,
              color: AppColors.textBody,
            ),
          ),
          SizedBox(height: 18.h),

          const Divider(color: AppColors.borderLight, thickness: 1),
          SizedBox(height: 18.h),

          // Section 2: "مواعيد العمل"
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
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.borderLight,
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        context.translate(LocalizationKeys.receptionAndEmergency),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonBlackTextColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.colorSecondary.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        hospital.workingHoursStatus.isNotEmpty
                            ? hospital.workingHoursStatus
                            : context.translate(LocalizationKeys.available24Hours),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  context.translate(LocalizationKeys.clinicsHoursVaryBySpecialty),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),

          const Divider(color: AppColors.borderLight, thickness: 1),
          SizedBox(height: 18.h),

          // Section 3: "الخدمات والمرافق"
          Text(
            context.translate(LocalizationKeys.servicesAndFacilities),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonBlackTextColor,
            ),
          ),
          SizedBox(height: 12.h),

          if (services.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, index) {
                final service = services[index];
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 7.r,
                        height: 7.r,
                        decoration: const BoxDecoration(
                          color: AppColors.colorPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          service.getName(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.buttonBlackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          else
            Text(
              context.translate(LocalizationKeys.servicesAndFacilities),
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
