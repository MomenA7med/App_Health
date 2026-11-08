import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_review_card_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/extensions/extension_localization.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorReviewsTabWidget extends StatelessWidget {
  final DoctorReviewsDataModel? reviews;
  final bool isLoading;
  final String? error;

  const DoctorReviewsTabWidget({
    super.key,
    required this.reviews,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && reviews == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: const Center(child: LoaderWidget()),
      );
    }

    if (error != null && reviews == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Text(
            error!,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.labelSubtitle,
            ),
          ),
        ),
      );
    }

    final data = reviews;
    if (data == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Rating Summary Box
        Center(
          child: Column(
            children: [
              Text(
                data.ratingAverage.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 42.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buttonBlackTextColor,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) {
                    final double starVal = index + 1;
                    if (data.ratingAverage >= starVal) {
                      return const Icon(
                        Icons.star_rounded,
                        size: 24,
                        color: AppColors.ratingStar,
                      );
                    } else if (data.ratingAverage >= starVal - 0.5) {
                      return const Icon(
                        Icons.star_half_rounded,
                        size: 24,
                        color: AppColors.ratingStar,
                      );
                    } else {
                      return const Icon(
                        Icons.star_border_rounded,
                        size: 24,
                        color: AppColors.ratingStar,
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                context
                    .translate(LocalizationKeys.basedOnReviews)
                    .replaceAll('{count}', data.totalReviews.toString()),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),

        // Breakdown bars if present
        if (data.breakdown.isNotEmpty && data.totalReviews > 0) ...[
          ...data.breakdown.map((item) {
            final double percent = data.totalReviews > 0
                ? (item.count / data.totalReviews).clamp(0.0, 1.0)
                : 0.0;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 20.w,
                    child: Text(
                      '${item.rating}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: AppColors.ratingStar,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: percent,
                        minHeight: 6.h,
                        backgroundColor: AppColors.borderLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.ratingStar,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 24.w,
                    child: Text(
                      '${item.count}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 16.h),
        ],

        const Divider(color: AppColors.borderLight, thickness: 1),
        SizedBox(height: 16.h),

        // Section Title: Patient Reviews
        Text(
          context.translate(LocalizationKeys.patientReviews),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonBlackTextColor,
          ),
        ),
        SizedBox(height: 12.h),

        // Reviews List
        if (data.items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Center(
              child: Text(
                context.translate(LocalizationKeys.noReviewsFound),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.labelSubtitle,
                ),
              ),
            ),
          )
        else
          ...data.items.map((review) => DoctorReviewCardWidget(review: review)),
      ],
    );
  }
}

