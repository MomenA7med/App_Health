import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

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
    final hasImage = doctor.imageUrl != null && doctor.imageUrl!.trim().isNotEmpty;

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
          fontWeight: FontWeight.bold,
          color: AppColors.colorPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
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
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Color(0xFFF59E0B),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          doctor.ratingAverage.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.buttonBlackTextColor,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${doctor.totalReviews} ${context.translate(LocalizationKeys.reviews)})',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Favorite Button on the end/left
              InkWell(
                onTap: onFavoriteTap,
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF8FAFC),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 20.r,
                    color: isFavorite
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Clinic Info Box
          if (doctor.clinicName.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                children: [
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
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.local_hospital_rounded,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                ],
              ),
            )
          else if (doctor.clinicAddress.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.r,
                  color: const Color(0xFF64748B),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    '${doctor.clinicAddress} · ${context.translate(LocalizationKeys.distanceKmAway).replaceAll('{distance}', doctor.formattedDistance)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          SizedBox(height: 12.h),

          // Badges: Next Available Slot on the right + Accepts Insurance on the left
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              if (doctor.nextAvailableSlot != null &&
                  doctor.nextAvailableSlot!.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.colorSecondary.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14.r,
                        color: AppColors.colorPrimary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        doctor.nextAvailableSlot!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  context.translate(LocalizationKeys.acceptsInsurance),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
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
                      color: const Color(0xFF94A3B8),
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
                    context.translate(LocalizationKeys.bookNow),
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
    );
  }
}

