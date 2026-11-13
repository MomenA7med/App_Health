import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';
import 'package:app_health/features/widgets/app_filter_dropdown_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class MedicalSpecialtyFilterDropdownWidget extends StatelessWidget {
  final List<MedicalSpecialtyModel> specialties;
  final String? selectedSpecialtyId;
  final void Function(String? id, String? name) onSpecialtyChanged;
  final bool showDividerAbove;

  const MedicalSpecialtyFilterDropdownWidget({
    super.key,
    required this.specialties,
    this.selectedSpecialtyId,
    required this.onSpecialtyChanged,
    this.showDividerAbove = true,
  });

  @override
  Widget build(BuildContext context) {
    final String allSpecialtiesText =
        context.translate(LocalizationKeys.allSpecialties);

    final List<DropdownMenuItem<String?>> items = [
      DropdownMenuItem<String?>(
        value: null,
        child: Text(
          allSpecialtiesText,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textBody,
          ),
        ),
      ),
      ...specialties.map((specialty) {
        final name = specialty.getName(context);
        return DropdownMenuItem<String?>(
          value: specialty.id,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.buttonBlackTextColor,
            ),
          ),
        );
      }),
    ];

    return AppFilterDropdownWidget<String?>(
      showDividerAbove: showDividerAbove,
      title: context.translate(LocalizationKeys.specialty),
      value: selectedSpecialtyId,
      hintText: allSpecialtiesText,
      items: items,
      onChanged: (newSpecialtyId) {
        if (newSpecialtyId == null || newSpecialtyId.isEmpty) {
          onSpecialtyChanged(null, null);
        } else {
          final matches = specialties.where((s) => s.id == newSpecialtyId);
          if (matches.isNotEmpty) {
            final matched = matches.first;
            onSpecialtyChanged(newSpecialtyId, matched.getName(context));
          } else {
            onSpecialtyChanged(newSpecialtyId, null);
          }
        }
      },
    );
  }
}

