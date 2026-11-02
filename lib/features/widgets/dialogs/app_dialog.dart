import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/features/widgets/app_buttons/app_text_button.dart';
import 'package:app_health/res/app_colors.dart';

class AppDialog {
  static void showAppDialog({
    required BuildContext context,
    required String iconPath,
    required String title,
    required String cancelLbl,
    required String actionLbl,
    required void Function() action,
  }) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(iconPath, width: 56, height: 56),
                SizedBox(height: 16.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 20.h),
                Divider(color: AppColors.taskItemBorder),
                SizedBox(height: 12.h),
                SizedBox(width: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppElevatedButton.withTitle(
                      onPressed: () {
                        context.pop();
                      },
                      title: cancelLbl,
                      color: AppColors.appNavigationBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    SizedBox(width: 30),
                    AppTextButton(
                      onPressed: () {
                        context.pop();
                        action();
                      },
                      child: Text(
                        actionLbl,
                        style: TextStyle(color: AppColors.delete),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
