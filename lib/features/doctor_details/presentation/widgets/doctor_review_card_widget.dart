import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';
import 'package:app_health/res/app_colors.dart';

class DoctorReviewCardWidget extends StatelessWidget {
  final DoctorReviewModel review;

  const DoctorReviewCardWidget({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Patient Name & Relative Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.patientName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buttonBlackTextColor,
                ),
              ),
              Text(
                review.formattedTimeAgo,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Rating Stars
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < review.rating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                size: 16.r,
                color: AppColors.ratingStar,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Comment
          if (review.comment.isNotEmpty)
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
                color: AppColors.textDescription,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}

