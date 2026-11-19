import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/pharmacy_details/data/models/pharmacy_profile_response_model.dart';
import 'package:app_health/features/widgets/app_badge_widget.dart';
import 'package:app_health/features/widgets/app_capsule_tabs_widget.dart';
import 'package:app_health/features/widgets/app_contact_actions_widget.dart';
import 'package:app_health/features/widgets/app_favorite_button.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PharmacyDetailsHeaderWidget extends StatelessWidget {
  final PharmacyProfileModel pharmacy;
  final bool isFavorite;
  final int activeTab;
  final VoidCallback onFavoriteTap;
  final VoidCallback onBackTap;
  final VoidCallback? onCallTap;
  final VoidCallback? onMessageTap;
  final ValueChanged<int> onTabSelected;

  const PharmacyDetailsHeaderWidget({
    super.key,
    required this.pharmacy,
    required this.isFavorite,
    required this.activeTab,
    required this.onFavoriteTap,
    required this.onBackTap,
    this.onCallTap,
    this.onMessageTap,
    required this.onTabSelected,
  });

  Widget _buildHeroImage() {
    final image = (pharmacy.coverUrl?.trim().isNotEmpty == true)
        ? pharmacy.coverUrl!.trim()
        : (pharmacy.logoUrl?.trim().isNotEmpty == true)
            ? pharmacy.logoUrl!.trim()
            : null;

    if (image != null) {
      return CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250.h,
        placeholder: (_, __) => _buildHeroPlaceholder(),
        errorWidget: (_, __, ___) => _buildHeroPlaceholder(),
      );
    }
    return _buildHeroPlaceholder();
  }

  Widget _buildHeroPlaceholder() {
    return Container(
      width: double.infinity,
      height: 250.h,
      decoration: BoxDecoration(
        color: AppColors.suffixIcon,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.suffixIcon,
            AppColors.colorPrimary,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.local_pharmacy_rounded,
          size: 72.r,
          color: AppColors.white.withValues(alpha: 0.35),
        ),
      ),
    );
  }

  Widget _buildTranslucentButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22.r),
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.25),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final distanceText = pharmacy.formattedDistance.isNotEmpty
        ? context
            .translate(LocalizationKeys.distanceKmAway)
            .replaceAll('{distance}', pharmacy.formattedDistance)
        : '';

    return Column(
      children: [
        // 1. Hero Image Stack (Cover, Gradient, Actions, Name & Rating)
        Stack(
          children: [
            SizedBox(
              height: 250.h,
              width: double.infinity,
              child: _buildHeroImage(),
            ),

            // Gradient Overlay for text readability
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 140.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
            ),

            // Top Action Buttons: Back + Favorite
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              left: 16.w,
              right: 16.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTranslucentButton(
                    onTap: onBackTap,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 18.r,
                      color: AppColors.white,
                    ),
                  ),
                  AppFavoriteButton.translucent(
                    isFavorite: isFavorite,
                    onTap: onFavoriteTap,
                    size: 44,
                    iconSize: 22,
                  ),
                ],
              ),
            ),

            // Bottom Hero Row: Name and Rating
            Positioned(
              left: 20.w,
              right: 20.w,
              bottom: 24.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Pharmacy Name
                  Expanded(
                    child: Text(
                      pharmacy.displayName,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Rating Row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 18.r,
                        color: AppColors.badgeYellow,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        pharmacy.ratingAverage.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      if (pharmacy.totalReviews > 0) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '(${pharmacy.totalReviews} ${context.translate(LocalizationKeys.reviews)})',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // 2. Profile Content (Curved White Sheet)
        Transform.translate(
          offset: Offset(0, -16.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badges Row (Insurance & Working Hours / Status)
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    if (pharmacy.acceptsPatientInsurance)
                      AppBadgeWidget.insurance(context: context),
                    if (pharmacy.isOpenNow)
                      AppBadgeWidget(
                        text: context.translate(LocalizationKeys.openNow),
                        backgroundColor: AppColors.badgeGreenBg,
                        textColor: AppColors.badgeGreenText,
                        fontWeight: FontWeight.w600,
                      )
                    else if (pharmacy.isTwentyFourHours)
                      AppBadgeWidget.workingHours(
                        status: context.translate(LocalizationKeys.open24Hours),
                      )
                    else if (pharmacy.workingHoursStatus.isNotEmpty)
                      AppBadgeWidget.workingHours(
                        status: pharmacy.workingHoursStatus,
                      ),
                  ],
                ),
                SizedBox(height: 14.h),

                // Location Details Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppAssetPaths.locationIcon,
                      width: 20.r,
                      height: 20.r,
                      colorFilter: const ColorFilter.mode(
                        AppColors.colorPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pharmacy.areaName.isNotEmpty
                                ? '${pharmacy.areaName}، ${pharmacy.governorateName}'
                                : pharmacy.address,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.buttonBlackTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            distanceText.isNotEmpty
                                ? '${pharmacy.address} · $distanceText'
                                : pharmacy.address,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.labelSubtitle,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Contact Actions: Call & Message
                AppContactActionsWidget(
                  phoneNumber: pharmacy.phone,
                  onCall: onCallTap,
                  onMessage: onMessageTap,
                ),
                SizedBox(height: 20.h),

                // Tabs Section
                AppCapsuleTabsWidget(
                  tabs: [
                    context.translate(LocalizationKeys.aboutPharmacy),
                    context.translate(LocalizationKeys.branches),
                    context.translate(LocalizationKeys.insurance),
                  ],
                  selectedIndex: activeTab,
                  onTabSelected: onTabSelected,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

