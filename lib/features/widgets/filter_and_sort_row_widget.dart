import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class FilterAndSortRowWidget extends StatelessWidget {
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;
  final String sortLabel;
  final String? filterLabel;
  final bool hasActiveFilter;
  final int activeFiltersCount;

  const FilterAndSortRowWidget({
    super.key,
    required this.onFilterTap,
    required this.onSortTap,
    required this.sortLabel,
    this.filterLabel,
    this.hasActiveFilter = false,
    this.activeFiltersCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Filter Button on start
        Expanded(
          child: InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: hasActiveFilter
                    ? AppColors.colorPrimary
                    : AppColors.colorSecondary,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColors.colorPrimary, width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssetPaths.filterIcon,
                    width: 18.w,
                    height: 18.h,
                    colorFilter: ColorFilter.mode(
                      hasActiveFilter
                          ? AppColors.buttonWhiteTextColor
                          : AppColors.textSecondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    filterLabel ?? context.translate(LocalizationKeys.filter),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: hasActiveFilter
                          ? AppColors.buttonWhiteTextColor
                          : AppColors.textSecondaryColor,
                    ),
                  ),
                  if (hasActiveFilter && activeFiltersCount > 0) ...[
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$activeFiltersCount',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Sort Dropdown Button on end
        Expanded(
          child: InkWell(
            onTap: onSortTap,
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: AppColors.textSecondaryColor,
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      sortLabel,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHeader,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
