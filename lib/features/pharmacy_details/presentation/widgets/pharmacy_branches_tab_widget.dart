import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/pharmacy_details/data/models/pharmacy_branch_model.dart';
import 'package:app_health/features/widgets/app_badge_widget.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PharmacyBranchesTabWidget extends StatelessWidget {
  final List<PharmacyBranchModel> branches;

  const PharmacyBranchesTabWidget({
    super.key,
    required this.branches,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title: "العناوين"
          Text(
            context.translate(LocalizationKeys.branches),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonBlackTextColor,
            ),
          ),
          SizedBox(height: 16.h),

          if (branches.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              alignment: Alignment.center,
              child: Text(
                context.translate(LocalizationKeys.noBranchesInPharmacy),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: branches.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final branch = branches[index];
                final distanceText = branch.formattedDistance.isNotEmpty
                    ? context
                        .translate(LocalizationKeys.distanceKmAway)
                        .replaceAll('{distance}', branch.formattedDistance)
                    : '';

                return Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Branch Name + Primary Tag
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              branch.branchName,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.buttonBlackTextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (branch.isPrimary)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.colorSecondary,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                context.translate(
                                  LocalizationKeys.primaryBranch,
                                ),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.colorPrimary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Address & Distance
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssetPaths.locationIcon,
                            width: 16.r,
                            height: 16.r,
                            colorFilter: const ColorFilter.mode(
                              AppColors.textMuted,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              distanceText.isNotEmpty
                                  ? '${branch.address} · $distanceText'
                                  : branch.address,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.labelSubtitle,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Status Badge (Working Hours / Open Now)
                      if (branch.workingHoursStatus.isNotEmpty ||
                          branch.isOpenNow ||
                          branch.isTwentyFourHours) ...[
                        SizedBox(height: 10.h),
                        AppBadgeWidget.workingHours(
                          status: branch.workingHoursStatus.isNotEmpty
                              ? branch.workingHoursStatus
                              : (branch.isTwentyFourHours
                                  ? context.translate(
                                      LocalizationKeys.open24Hours,
                                    )
                                  : context.translate(
                                      LocalizationKeys.openNow,
                                    )),
                          icon: Icon(
                            Icons.access_time_rounded,
                            size: 14.r,
                            color: AppColors.textSecondaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

