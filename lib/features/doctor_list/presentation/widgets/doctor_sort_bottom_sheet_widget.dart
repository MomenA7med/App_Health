import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorSortBottomSheetWidget extends StatefulWidget {
  final DoctorSortOption initialSort;
  final ValueChanged<DoctorSortOption> onApply;

  const DoctorSortBottomSheetWidget({
    super.key,
    required this.initialSort,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required DoctorSortOption currentSort,
    required ValueChanged<DoctorSortOption> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => DoctorSortBottomSheetWidget(
        initialSort: currentSort,
        onApply: onApply,
      ),
    );
  }

  @override
  State<DoctorSortBottomSheetWidget> createState() =>
      _DoctorSortBottomSheetWidgetState();
}

class _DoctorSortBottomSheetWidgetState
    extends State<DoctorSortBottomSheetWidget> {
  late DoctorSortOption _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSort;
  }

  Widget _buildOptionTile({
    required DoctorSortOption option,
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
              : Colors.white,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(
            color: isSelected
                ? AppColors.colorPrimary
                : const Color(0xFFE2E8F0),
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
                      : const Color(0xFF334155),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            // Radio circle on the left (RTL end)
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.colorPrimary
                      : const Color(0xFFCBD5E1),
                  width: 2.0,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.r,
                        height: 12.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorPrimary,
                        ),
                      ),
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
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              context.translate(LocalizationKeys.sortDoctors),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
            SizedBox(height: 18.h),
            _buildOptionTile(
              option: DoctorSortOption.nearest,
              title: context.translate(LocalizationKeys.nearestToYou),
              icon: Icon(
                Icons.location_on_outlined,
                color: AppColors.colorPrimary,
                size: 20.r,
              ),
            ),
            _buildOptionTile(
              option: DoctorSortOption.highestRated,
              title: context.translate(LocalizationKeys.highestRated),
              icon: Icon(
                Icons.star_rounded,
                color: const Color(0xFFFBBF24),
                size: 22.r,
              ),
            ),
            _buildOptionTile(
              option: DoctorSortOption.priceLowToHigh,
              title: context.translate(LocalizationKeys.priceLowToHigh),
              icon: Icon(
                Icons.credit_card_outlined,
                color: const Color(0xFF64748B),
                size: 20.r,
              ),
            ),
            _buildOptionTile(
              option: DoctorSortOption.priceHighToLow,
              title: context.translate(LocalizationKeys.priceHighToLow),
              icon: Icon(
                Icons.credit_card_outlined,
                color: const Color(0xFF64748B),
                size: 20.r,
              ),
            ),
            SizedBox(height: 12.h),
            AppElevatedButton.withTitle(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onApply(_selectedSort);
              },
              title: context.translate(LocalizationKeys.applySorting),
              color: AppColors.colorPrimary,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

