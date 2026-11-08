import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/extensions/extension_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorDetailsTabsWidget extends StatelessWidget {
  final int activeTab; // 0: About Doctor, 1: Reviews
  final ValueChanged<int> onTabChanged;

  const DoctorDetailsTabsWidget({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          // Tab 0: About Doctor
          Expanded(
            child: _buildTabItem(
              context: context,
              title: context.translate(LocalizationKeys.aboutDoctor),
              isSelected: activeTab == 0,
              onTap: () => onTabChanged(0),
            ),
          ),

          // Tab 1: Reviews
          Expanded(
            child: _buildTabItem(
              context: context,
              title: context.translate(LocalizationKeys.reviews),
              isSelected: activeTab == 1,
              onTap: () => onTabChanged(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? AppColors.colorPrimary
                : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

