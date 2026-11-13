import 'package:flutter/material.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/widgets/app_search_bar_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorSearchBarWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AppSearchBarWidget(
      controller: controller,
      hintText: context.translate(LocalizationKeys.searchDoctorHint),
      onChanged: onChanged,
      onClear: onClear,
      debounceDuration: debounceDuration,
    );
  }
}
