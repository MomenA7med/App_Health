import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/res/app_colors.dart';

class AppFilterDropdownWidget<T> extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final T? value;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool showDividerAbove;
  final bool enabled;

  const AppFilterDropdownWidget({
    super.key,
    this.title,
    this.subtitle,
    required this.value,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.showDividerAbove = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValidSelection =
        value != null && items.any((item) => item.value == value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDividerAbove) ...[
          const Divider(color: AppColors.borderSubtle, thickness: 1),
          SizedBox(height: 16.h),
        ],
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: 12.h),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: enabled ? AppColors.white : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: hasValidSelection ? value : null,
              hint: Text(
                hintText,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textBody,
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textBody,
              ),
              items: items,
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}

