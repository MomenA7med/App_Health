import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/logic/user_manager.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class HomeHeaderWidget extends StatelessWidget {
  final VoidCallback? onLogoutTap;

  const HomeHeaderWidget({
    super.key,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final userManager = GetIt.I.isRegistered<UserMangers>()
        ? GetIt.I<UserMangers>()
        : null;
    final isEnglish = Directionality.of(context) == TextDirection.ltr;
    final userName = userManager?.getUserName(isEnglish) ?? '';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Logo / Avatar, Welcome text, and Logout action
          Row(
            children: [
              // App Logo / Avatar
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: AppColors.colorSecondary.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.colorPrimary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    AppAssetPaths.appLogo,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.person_rounded,
                      size: 26.r,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Greeting & User Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.isNotEmpty
                          ? '${context.translate(LocalizationKeys.welcomeBack)}، $userName'
                          : context.translate(LocalizationKeys.welcomeBack),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonBlackTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      context.translate(LocalizationKeys.howCanWeHelp),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.labelSubtitle,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              // Sign Out Button
              InkWell(
                onTap: onLogoutTap ?? () async => await userManager?.signOut(),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 18.r,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Promotional / Welcoming Health Banner Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.colorPrimary,
                  AppColors.colorPrimary.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.colorPrimary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate(LocalizationKeys.healthServices),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        context.translate(LocalizationKeys.howCanWeHelp),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.white.withValues(alpha: 0.9),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.health_and_safety_rounded,
                    size: 28.r,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
