import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_filter_model.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PharmacySortBottomSheetWidget extends StatefulWidget {
  final PharmacySortOption initialSort;
  final ValueChanged<PharmacySortOption> onApply;

  const PharmacySortBottomSheetWidget({
    super.key,
    required this.initialSort,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required PharmacySortOption currentSort,
    required ValueChanged<PharmacySortOption> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => PharmacySortBottomSheetWidget(
        initialSort: currentSort,
        onApply: onApply,
      ),
    );
  }

  @override
  State<PharmacySortBottomSheetWidget> createState() =>
      _PharmacySortBottomSheetWidgetState();
}

class _PharmacySortBottomSheetWidgetState
    extends State<PharmacySortBottomSheetWidget> {
  late PharmacySortOption _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSort;
  }

  Widget _buildOptionTile({
    required PharmacySortOption option,
    required String title,
    required Widget icon,
  }) {
    final bool isSelected = _selectedSort == option;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedSort = option;
        });
      },
      borderRadius: BorderRadius.circular(26.r),
      child: Container(
        height: 52.h,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.colorSecondary.withValues(alpha: 0.3)
              : AppColors.white,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(
            color: isSelected ? AppColors.colorPrimary : AppColors.borderLight,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppColors.buttonBlackTextColor
                      : AppColors.textHeader,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.colorPrimary
                      : AppColors.borderLight,
                  width: 2,
                ),
                color: isSelected ? AppColors.colorPrimary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14.r,
                      color: AppColors.buttonWhiteTextColor,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              context.translate(LocalizationKeys.sortPharmacies),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonBlackTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),

            // Highest Rated Option
            _buildOptionTile(
              option: PharmacySortOption.highestRated,
              title: context.translate(LocalizationKeys.highestRated),
              icon: Icon(
                Icons.star_rounded,
                color: AppColors.starFilled,
                size: 24.r,
              ),
            ),

            // Nearest Option
            _buildOptionTile(
              option: PharmacySortOption.nearest,
              title: context.translate(LocalizationKeys.nearestToYou),
              icon: Icon(
                Icons.near_me_rounded,
                color: AppColors.colorPrimary,
                size: 22.r,
              ),
            ),

            SizedBox(height: 16.h),

            // Apply Button
            AppElevatedButton.withTitle(
              title: context.translate(LocalizationKeys.showResults),
              onPressed: () {
                widget.onApply(_selectedSort);
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

