import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';
import 'package:app_health/features/widgets/app_badge_widget.dart';
import 'package:app_health/features/widgets/app_favorite_button.dart';
import 'package:app_health/features/widgets/app_rating_widget.dart';
import 'package:app_health/features/widgets/location_distance_widget.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PharmacyCardWidget extends StatelessWidget {
  final PharmacyModel pharmacy;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const PharmacyCardWidget({
    super.key,
    required this.pharmacy,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  Widget _buildLogo() {
    final logo = pharmacy.logoUrl?.trim();
    if (logo != null && logo.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CachedNetworkImage(
          imageUrl: logo,
          width: 62.r,
          height: 62.r,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildLogoPlaceholder(),
          errorWidget: (context, url, error) => _buildLogoPlaceholder(),
        ),
      );
    }
    return _buildLogoPlaceholder();
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      width: 62.r,
      height: 62.r,
      decoration: BoxDecoration(
        color: AppColors.suffixIcon,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: SvgPicture.asset(
          AppAssetPaths.clinicIcon,
          width: 32.r,
          height: 32.r,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasBranch =
        pharmacy.branchName != null && pharmacy.branchName!.trim().isNotEmpty;
    final hasWorkingHours = pharmacy.workingHoursStatus.isNotEmpty ||
        pharmacy.isTwentyFourHours ||
        pharmacy.isOpenNow;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderLight, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Section: Logo + Info (Name, Branch, Rating) + Favorite Button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  _buildLogo(),
                  SizedBox(width: 12.w),

                  // Name, Branch, Rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pharmacy.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.buttonBlackTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (hasBranch) ...[
                          SizedBox(height: 2.h),
                          Text(
                            pharmacy.branchName!,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.labelSubtitle,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        SizedBox(height: 4.h),
                        AppRatingWidget(
                          ratingAverage: pharmacy.ratingAverage,
                          totalReviews: pharmacy.totalReviews,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Circular Favorite Button
                  AppFavoriteButton(
                    isFavorite: isFavorite,
                    onTap: onFavoriteTap,
                    size: 38,
                    borderColor: AppColors.borderLight,
                    backgroundColor: AppColors.white,
                    inactiveColor: AppColors.textMuted,
                  ),
                ],
              ),

              // 2. Middle Section: Address & Distance
              SizedBox(height: 12.h),
              LocationDistanceWidget(
                address: pharmacy.address,
                formattedDistance: pharmacy.formattedDistance,
                iconColor: AppColors.textDark,
                textStyle: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.labelSubtitle,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // 3. Bottom Section: Working Hours & Insurance Badges
              if (hasWorkingHours || pharmacy.acceptsPatientInsurance) ...[
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    if (hasWorkingHours)
                      AppBadgeWidget.workingHours(
                        status: pharmacy.workingHoursStatus.isNotEmpty
                            ? pharmacy.workingHoursStatus
                            : (pharmacy.isTwentyFourHours
                                ? context.translate(LocalizationKeys.open24Hours)
                                : context.translate(LocalizationKeys.openNow)),
                        icon: Icon(
                          Icons.access_time_rounded,
                          size: 15.r,
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                    if (pharmacy.acceptsPatientInsurance)
                      AppBadgeWidget.insurance(context: context),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
