import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class LocationDistanceWidget extends StatelessWidget {
  final String address;
  final String formattedDistance;
  final double iconSize;
  final Color iconColor;
  final TextStyle? textStyle;
  final int maxLines;

  const LocationDistanceWidget({
    super.key,
    required this.address,
    required this.formattedDistance,
    this.iconSize = 16,
    this.iconColor = AppColors.textMuted,
    this.textStyle,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (address.isEmpty) return const SizedBox.shrink();

    final effectiveTextStyle = textStyle ??
        TextStyle(
          fontSize: 12.sp,
          color: AppColors.textMuted,
          fontWeight: FontWeight.w400,
        );

    final distanceText = context
        .translate(LocalizationKeys.distanceKmAway)
        .replaceAll('{distance}', formattedDistance);

    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: iconSize.r,
          color: iconColor,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            '$address · $distanceText',
            style: effectiveTextStyle,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

