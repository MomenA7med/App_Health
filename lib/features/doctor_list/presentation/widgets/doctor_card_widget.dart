import 'package:app_health/res/app_asset_paths.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/features/widgets/app_badge_widget.dart';
import 'package:app_health/features/widgets/app_favorite_button.dart';
import 'package:app_health/features/widgets/app_rating_widget.dart';
import 'package:app_health/features/widgets/location_distance_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorCardWidget extends StatelessWidget {
  final DoctorModel doctor;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onBookTap;

  const DoctorCardWidget({
    super.key,
    required this.doctor,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onBookTap,
  });

  Widget _buildAvatar() {
    final hasImage =
        doctor.imageUrl != null && doctor.imageUrl!.trim().isNotEmpty;

    if (hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CachedNetworkImage(
          imageUrl: doctor.imageUrl!,
          width: 68.r,
          height: 68.r,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildInitialsAvatar(),
          errorWidget: (context, url, error) => _buildInitialsAvatar(),
        ),
      );
    }

    return _buildInitialsAvatar();
  }

  Widget _buildInitialsAvatar() {
    return Container(
      width: 68.r,
      height: 68.r,
      decoration: BoxDecoration(
        color: AppColors.colorSecondary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      alignment: Alignment.center,
      child: Text(
        doctor.initials,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.colorPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBookTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.cardBorder, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Top Row: Avatar on the right (RTL start), Doctor details in the middle, Favorite icon on the left (RTL end)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar on the start/right
              _buildAvatar(),
              SizedBox(width: 12.w),
              // Doctor Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonBlackTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      doctor.specializationTitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.labelSubtitle,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    AppRatingWidget(
                      ratingAverage: doctor.ratingAverage,
                      totalReviews: doctor.totalReviews,
                      starSize: 18,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Favorite Button on the end/left
              AppFavoriteButton(
                isFavorite: isFavorite,
                onTap: onFavoriteTap,
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Clinic Info Box
          if (doctor.clinicName.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppAssetPaths.clinicIcon,
                    width: 38.r,
                    height: 38.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.clinicName,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.buttonBlackTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${doctor.clinicAddress} · ${context.translate(LocalizationKeys.distanceKmAway).replaceAll('{distance}', doctor.formattedDistance)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (doctor.clinicAddress.isNotEmpty)
            LocationDistanceWidget(
              address: doctor.clinicAddress,
              formattedDistance: doctor.formattedDistance,
            ),
          SizedBox(height: 12.h),

          // Badges: Next Available Slot on the right + Accepts Insurance on the left
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (doctor.nextAvailableSlot != null &&
                  doctor.nextAvailableSlot!.isNotEmpty)
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.colorSecondary,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 20.r,
                          color: AppColors.textSecondaryColor,
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            doctor.nextAvailableSlot!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(width: 8.w),
              if (doctor.acceptsPatientInsurance)
                AppBadgeWidget.insurance(context: context),
            ],
          ),
          SizedBox(height: 14.h),

          // Bottom Row: Price on the right & Book Now button on the left
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.translate(LocalizationKeys.consultationFee),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        doctor.formattedFee,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonBlackTextColor,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        context.translate(LocalizationKeys.currencyEgp),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.buttonBlackTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: onBookTap,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    context.translate(LocalizationKeys.showDetails),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonWhiteTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}
