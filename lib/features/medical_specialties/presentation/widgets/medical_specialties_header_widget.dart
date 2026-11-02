import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class MedicalSpecialtiesHeaderWidget extends StatelessWidget {
  const MedicalSpecialtiesHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translate(LocalizationKeys.chooseSpecialtyTitle),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.buttonBlackTextColor,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          context.translate(LocalizationKeys.chooseSpecialtySubtitle),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.labelSubtitle,
          ),
        ),
      ],
    );
  }
}
