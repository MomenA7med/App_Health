import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class AppRatingWidget extends StatelessWidget {
  final double ratingAverage;
  final int? totalReviews;
  final double starSize;
  final Color starColor;
  final TextStyle? ratingStyle;
  final TextStyle? reviewsStyle;
  final MainAxisSize mainAxisSize;
  final bool showReviews;

  const AppRatingWidget({
    super.key,
    required this.ratingAverage,
    this.totalReviews,
    this.starSize = 16,
    this.starColor = AppColors.badgeYellow,
    this.ratingStyle,
    this.reviewsStyle,
    this.mainAxisSize = MainAxisSize.min,
    this.showReviews = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRatingStyle = ratingStyle ??
        TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.buttonBlackTextColor,
        );

    final effectiveReviewsStyle = reviewsStyle ??
        TextStyle(
          fontSize: 12.sp,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
        );

    return Row(
      mainAxisSize: mainAxisSize,
      children: [
        Icon(
          Icons.star_rounded,
          size: starSize,
          color: starColor,
        ),
        SizedBox(width: 4.w),
        Text(
          ratingAverage.toStringAsFixed(1),
          style: effectiveRatingStyle,
        ),
        if (showReviews && totalReviews != null) ...[
          SizedBox(width: 4.w),
          Text(
            '($totalReviews ${context.translate(LocalizationKeys.reviews)})',
            style: effectiveReviewsStyle,
          ),
        ],
      ],
    );
  }
}

