import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_model.dart';
import 'package:app_health/features/widgets/app_badge_widget.dart';
import 'package:app_health/features/widgets/app_favorite_button.dart';
import 'package:app_health/features/widgets/app_rating_widget.dart';
import 'package:app_health/features/widgets/location_distance_widget.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class HospitalCardWidget extends StatelessWidget {
  final HospitalModel hospital;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const HospitalCardWidget({
    super.key,
    required this.hospital,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  Widget _buildCoverImage() {
    final cover = hospital.coverUrl?.trim();
    if (cover != null && cover.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: cover,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 130.h,
        placeholder: (context, url) => _buildCoverPlaceholder(),
        errorWidget: (context, url, error) => _buildCoverPlaceholder(),
      );
    }
    return _buildCoverPlaceholder();
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      width: double.infinity,
      height: 130.h,
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
          size: 48.r,
          color: AppColors.colorPrimary.withValues(alpha: 0.35),
        ),
      ),
    );
  }

  Widget _buildLogoAvatar() {
    final logo = hospital.logoUrl?.trim();
    if (logo != null && logo.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: logo,
        fit: BoxFit.cover,
        width: 58.r,
        height: 58.r,
        placeholder: (context, url) => _buildClinicIconPlaceholder(),
        errorWidget: (context, url, error) => _buildClinicIconPlaceholder(),
      );
    }
    return _buildClinicIconPlaceholder();
  }

  Widget _buildClinicIconPlaceholder() {
    return SvgPicture.asset(
      AppAssetPaths.clinicIcon,
      width: 58.r,
      height: 58.r,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.cardBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cover Image + Overlapping Logo + Favorite Button
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cover Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: SizedBox(
                      height: 130.h,
                      width: double.infinity,
                      child: _buildCoverImage(),
                    ),
                  ),

                  // Favorite Button on top-left of cover
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: AppFavoriteButton.translucent(
                      isFavorite: isFavorite,
                      onTap: onFavoriteTap,
                    ),
                  ),

                  // Overlapping Circular Logo on bottom-right of cover
                  Positioned(
                    bottom: -24.h,
                    right: 12.w,
                    child: Container(
                      width: 58.r,
                      height: 58.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        border: Border.all(color: AppColors.white, width: 3.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(child: _buildLogoAvatar()),
                    ),
                  ),
                ],
              ),

              // 2. Rating row below cover (placed on the left side)
              SizedBox(height: 8.h),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AppRatingWidget(
                  ratingAverage: hospital.ratingAverage,
                  totalReviews: hospital.totalReviews,
                ),
              ),

              // 3. Hospital Name
              SizedBox(height: 6.h),
              Text(
                hospital.name,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buttonBlackTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // 4. Address & Distance Row
              SizedBox(height: 6.h),
              LocationDistanceWidget(
                address: hospital.address,
                formattedDistance: hospital.formattedDistance,
              ),

              // 5. Chips Row: Accepts Insurance, Working Hours, Specialties Count
              SizedBox(height: 12.h),
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
            ],
          ),
        ),
      ),
    );
  }
}
