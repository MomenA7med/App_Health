import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/hospital_details/data/models/hospital_profile_response_model.dart';
import 'package:app_health/features/widgets/app_badge_widget.dart';
import 'package:app_health/features/widgets/app_capsule_tabs_widget.dart';
import 'package:app_health/features/widgets/app_contact_actions_widget.dart';
import 'package:app_health/features/widgets/app_rating_widget.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class HospitalDetailsHeaderWidget extends StatelessWidget {
  final HospitalProfileModel hospital;
  final bool isFavorite;
  final int activeTab;
  final VoidCallback onFavoriteTap;
  final VoidCallback onBackTap;
  final VoidCallback? onCallTap;
  final VoidCallback? onMessageTap;
  final ValueChanged<int> onTabSelected;

  const HospitalDetailsHeaderWidget({
    super.key,
    required this.hospital,
    required this.isFavorite,
    required this.activeTab,
    required this.onFavoriteTap,
    required this.onBackTap,
    this.onCallTap,
    this.onMessageTap,
    required this.onTabSelected,
  });

  Widget _buildCoverImage() {
    final cover = hospital.coverUrl?.trim();
    if (cover != null && cover.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: cover,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 230.h,
        placeholder: (_, __) => _buildCoverPlaceholder(),
        errorWidget: (_, __, ___) => _buildCoverPlaceholder(),
      );
    }
    return _buildCoverPlaceholder();
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      width: double.infinity,
      height: 230.h,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.colorSecondary.withValues(alpha: 0.4),
            AppColors.lightBlue.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.apartment_rounded,
          size: 64.r,
          color: AppColors.colorPrimary.withValues(alpha: 0.35),
        ),
      ),
    );
  }

  Widget _buildLogoAvatar() {
    final logo = hospital.logoUrl?.trim();
    return Container(
      width: 72.r,
      height: 72.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(color: AppColors.white, width: 3.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: logo != null && logo.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: logo,
                fit: BoxFit.cover,
                placeholder: (_, __) => _buildLogoFallback(),
                errorWidget: (_, __, ___) => _buildLogoFallback(),
              )
            : _buildLogoFallback(),
      ),
    );
  }

  Widget _buildLogoFallback() {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(10.r),
      child: SvgPicture.asset(
        AppAssetPaths.clinicIcon,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final distanceText = hospital.formattedDistance.isNotEmpty
        ? ' · ${context.translate(LocalizationKeys.distanceKmAway).replaceAll('{distance}', hospital.formattedDistance)}'
        : '';

    final locationLine1 = [
      if (hospital.areaName.isNotEmpty) hospital.areaName,
      if (hospital.governorateName.isNotEmpty) hospital.governorateName,
    ].join('، ');

    return Column(
      children: [
        // Cover Image with Top Buttons and Overlapping Logo
        Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Cover Image
            _buildCoverImage(),

            // 2. Top Bar Buttons (Back & Favorite)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 10.h,
              left: 16.w,
              right: 16.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  InkWell(
                    onTap: onBackTap,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 18.r,
                        color: AppColors.buttonBlackTextColor,
                      ),
                    ),
                  ),

                  // Favorite button
                  InkWell(
                    onTap: onFavoriteTap,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 20.r,
                        color: isFavorite
                            ? AppColors.errorRed
                            : AppColors.buttonBlackTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Rounded top white container overlapping
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 24.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                ),
              ),
            ),

            // 4. Overlapping Avatar Logo
            Positioned(
              bottom: -16.h,
              right: 20.w,
              child: _buildLogoAvatar(),
            ),
          ],
        ),

        // Hospital Info & Actions Section
        Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),

              // Hospital Name
              Text(
                hospital.name,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buttonBlackTextColor,
                ),
              ),
              SizedBox(height: 8.h),

              // Rating
              AppRatingWidget(
                ratingAverage: hospital.ratingAverage,
                totalReviews: hospital.totalReviews,
              ),
              SizedBox(height: 12.h),

              // Badges Row
              Wrap(
                spacing: 8.w,
                runSpacing: 6.h,
                children: [
                  if (hospital.acceptsPatientInsurance)
                    AppBadgeWidget.insurance(context: context),
                  if (hospital.workingHoursStatus.isNotEmpty)
                    AppBadgeWidget.workingHours(
                      status: hospital.workingHoursStatus,
                    ),
                  if (hospital.specialtiesCountLabel.isNotEmpty ||
                      hospital.specialtiesCount > 0)
                    AppBadgeWidget(
                      text: hospital.specialtiesCountLabel.isNotEmpty
                          ? hospital.specialtiesCountLabel
                          : '${hospital.specialtiesCount} ${context.translate(LocalizationKeys.specialties)}',
                      backgroundColor: AppColors.surfaceMuted,
                      textColor: AppColors.labelSubtitle,
                      fontWeight: FontWeight.w500,
                    ),
                ],
              ),
              SizedBox(height: 14.h),

              // Location Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 26.r,
                    color: AppColors.buttonBlackTextColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (locationLine1.isNotEmpty)
                          Text(
                            locationLine1,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.buttonBlackTextColor,
                            ),
                          ),
                        if (hospital.address.isNotEmpty)
                          Text(
                            '${hospital.address}$distanceText',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.r,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Action Buttons Row (اتصال / مراسلة)
              AppContactActionsWidget(
                phoneNumber: hospital.phone,
                onCall: onCallTap,
                onMessage: onMessageTap,
              ),
              SizedBox(height: 20.h),

              // Capsule Tabs
              AppCapsuleTabsWidget(
                tabs: [
                  context.translate(LocalizationKeys.specialties),
                  context.translate(LocalizationKeys.insurance),
                  context.translate(LocalizationKeys.aboutHospital),
                ],
                selectedIndex: activeTab,
                onTabSelected: onTabSelected,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
  }
}
