import 'package:app_health/features/medical_specialties/presentation/screen/emergency_specialties_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/home/presentation/widgets/home_category_card_widget.dart';
import 'package:app_health/features/home/presentation/widgets/home_header_widget.dart';
import 'package:app_health/features/hospital_list/presentation/screens/hospital_list_screen.dart';
import 'package:app_health/features/medical_specialties/presentation/screen/medical_specialties_screen.dart';
import 'package:app_health/features/pharmacies_list/presentation/screens/pharmacies_list_screen.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  static void open({required BuildContext context}) {
    context.go(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with greeting, banner and actions
              const HomeHeaderWidget(),
              SizedBox(height: 24.h),

              // Categories Section Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        context.translate(LocalizationKeys.healthServices),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonBlackTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.colorSecondary.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '3 ${context.translate(LocalizationKeys.healthServices)}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // 3 Main Categories
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    // 1. Medical Specialties
                    HomeCategoryCardWidget(
                      title: context.translate(
                        LocalizationKeys.medicalSpecialties,
                      ),
                      description: context.translate(
                        LocalizationKeys.medicalSpecialtiesDesc,
                      ),
                      badge: context.translate(LocalizationKeys.doctors),
                      icon: Icon(
                        Icons.medical_services_rounded,
                        size: 28.r,
                        color: AppColors.colorPrimary,
                      ),
                      iconBackgroundColor: AppColors.colorSecondary,
                      accentColor: AppColors.colorPrimary,
                      onTap: () {
                        EmergencySpecialtiesScreen.open(context: context);
                      },
                    ),
                    SizedBox(height: 14.h),

                    // 2. Hospital List
                    HomeCategoryCardWidget(
                      title: context.translate(LocalizationKeys.hospitals),
                      description: context.translate(
                        LocalizationKeys.hospitalsDesc,
                      ),
                      badge: context.translate(LocalizationKeys.hospitals),
                      icon: Icon(
                        Icons.apartment_rounded,
                        size: 28.r,
                        color: AppColors.colorPrimary,
                      ),
                      iconBackgroundColor: AppColors.lightBlue,
                      accentColor: AppColors.colorPrimary,
                      onTap: () {
                        HospitalListScreen.open(context: context);
                      },
                    ),
                    SizedBox(height: 14.h),

                    // 3. Pharmacies List
                    HomeCategoryCardWidget(
                      title: context.translate(LocalizationKeys.pharmacies),
                      description: context.translate(
                        LocalizationKeys.pharmaciesDesc,
                      ),
                      badge: context.translate(LocalizationKeys.pharmacies),
                      icon: Icon(
                        Icons.medication_rounded,
                        size: 28.r,
                        color: AppColors.colorPrimary,
                      ),
                      iconBackgroundColor: AppColors.colorSecondary,
                      accentColor: AppColors.colorPrimary,
                      onTap: () {
                        PharmaciesListScreen.open(context: context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
