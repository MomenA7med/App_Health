import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/extensions/extension_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorBookingBottomBarWidget extends StatelessWidget {
  final double? consultationFee;
  final VoidCallback onProceedTap;

  const DoctorBookingBottomBarWidget({
    super.key,
    this.consultationFee,
    required this.onProceedTap,
  });

  @override
  Widget build(BuildContext context) {
    final feeText = consultationFee != null
        ? (consultationFee! % 1 == 0
            ? consultationFee!.toInt().toString()
            : consultationFee!.toStringAsFixed(1))
        : '350';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Right: Consultation fee
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.translate(LocalizationKeys.consultationFee),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      feeText,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonBlackTextColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      context.translate(LocalizationKeys.currencyEgp),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.buttonBlackTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 20.w),

            // Left: Proceed to booking button
            Expanded(
              child: InkWell(
                onTap: onProceedTap,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    context.translate(LocalizationKeys.proceedToBooking),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonWhiteTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
