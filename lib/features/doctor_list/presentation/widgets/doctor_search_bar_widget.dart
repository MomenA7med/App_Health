import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorSearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Duration debounceDuration;

  const DoctorSearchBarWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<DoctorSearchBarWidget> createState() => _DoctorSearchBarWidgetState();
}

class _DoctorSearchBarWidgetState extends State<DoctorSearchBarWidget> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onChanged?.call(value);
    });
  }

  void _handleClear() {
    _debounceTimer?.cancel();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: AppColors.borderLight, width: 1.0),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: _onTextChanged,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.buttonBlackTextColor,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: context.translate(LocalizationKeys.searchDoctorHint),
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textMuted,
            size: 22,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context, value, _) {
              if (value.text.isNotEmpty) {
                return IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  onPressed: _handleClear,
                );
              }
              return const SizedBox.shrink();
            },
          ),

          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
