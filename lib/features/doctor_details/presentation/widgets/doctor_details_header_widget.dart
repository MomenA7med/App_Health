import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/features/widgets/app_favorite_button.dart';
import 'package:app_health/res/app_colors.dart';

class DoctorDetailsHeaderWidget extends StatelessWidget {
  final DoctorProfileModel doctor;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onBackTap;

  const DoctorDetailsHeaderWidget({
    super.key,
    required this.doctor,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient / Pattern
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.headerGradientStart, AppColors.headerGradientEnd],
              ),
            ),
          ),

          // Doctor image or fallback avatar
          if (doctor.imageUrl != null && doctor.imageUrl!.isNotEmpty)
            Image.network(
              doctor.imageUrl!,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => _buildAvatarFallback(),
            )
          else
            _buildAvatarFallback(),

          // Dark subtle gradient overlay at the bottom for text readability
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),

          // Doctor Info Overlay at Bottom
          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 24.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Doctor Name and Specialization
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        doctor.specializationTitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // Rating Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: AppColors.ratingStar,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${doctor.ratingAverage.toStringAsFixed(1)} (${doctor.totalReviews} تقييم)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top action buttons: Back (RTL start) & Favorite (RTL end)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                InkWell(
                  onTap: onBackTap,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: AppColors.borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Directionality.of(context) == TextDirection.ltr
                          ? Icons.arrow_forward_ios_rounded
                          : Icons.arrow_back_ios_rounded,
                      size: 16.r,
                      color: AppColors.buttonBlackTextColor,
                    ),
                  ),
                ),
                // Favorite Button
                AppFavoriteButton(
                  isFavorite: isFavorite,
                  onTap: onFavoriteTap,
                  size: 40,
                  activeColor: AppColors.colorPrimary,
                  inactiveColor: AppColors.buttonBlackTextColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Center(
      child: Icon(
        Icons.person_rounded,
        size: 140.r,
        color: Colors.white.withValues(alpha: 0.7),
      ),
    );
  }
}
