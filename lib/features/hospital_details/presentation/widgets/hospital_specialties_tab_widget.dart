import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/hospital_details/data/models/hospital_profile_response_model.dart';
import 'package:app_health/features/widgets/app_search_bar_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class HospitalSpecialtiesTabWidget extends StatefulWidget {
  final List<HospitalSpecialtyItemModel> specialties;
  final ValueChanged<HospitalSpecialtyItemModel>? onSpecialtyTap;

  const HospitalSpecialtiesTabWidget({
    super.key,
    required this.specialties,
    this.onSpecialtyTap,
  });

  @override
  State<HospitalSpecialtiesTabWidget> createState() =>
      _HospitalSpecialtiesTabWidgetState();
}

class _HospitalSpecialtiesTabWidgetState
    extends State<HospitalSpecialtiesTabWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getSpecialtyIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('قلب') || lower.contains('cardio')) {
      return Icons.favorite_outline_rounded;
    }
    if (lower.contains('باطن') || lower.contains('internal')) {
      return Icons.monitor_heart_outlined;
    }
    if (lower.contains('عظام') || lower.contains('ortho')) {
      return Icons.airline_seat_legroom_extra_rounded;
    }
    if (lower.contains('أطفال') || lower.contains('اطفال') || lower.contains('pediatric')) {
      return Icons.child_care_rounded;
    }
    if (lower.contains('جلد') || lower.contains('derma')) {
      return Icons.shield_outlined;
    }
    if (lower.contains('عيون') || lower.contains('ophthalm')) {
      return Icons.visibility_outlined;
    }
    if (lower.contains('أسنان') || lower.contains('اسنان') || lower.contains('dental')) {
      return Icons.sentiment_very_satisfied_outlined;
    }
    if (lower.contains('نساء') || lower.contains('توليد') || lower.contains('gynecol')) {
      return Icons.pregnant_woman_rounded;
    }
    if (lower.contains('مخ') || lower.contains('أعصاب') || lower.contains('neuro')) {
      return Icons.psychology_outlined;
    }
    return Icons.medical_services_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final filteredSpecialties = widget.specialties.where((s) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      return s.nameAr.toLowerCase().contains(q) ||
          s.nameEn.toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title: "التخصصات المتاحة"
          Text(
            context.translate(LocalizationKeys.availableSpecialties),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonBlackTextColor,
            ),
          ),
          SizedBox(height: 12.h),

          // Search Field
          AppSearchBarWidget(
            controller: _searchController,
            hintText: context.translate(LocalizationKeys.searchSpecialtyHint),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
          SizedBox(height: 16.h),

          // Specialties Grid or Empty State
          if (filteredSpecialties.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              alignment: Alignment.center,
              child: Text(
                context.translate(LocalizationKeys.noSpecialtiesFound),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredSpecialties.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                final specialty = filteredSpecialties[index];
                final name = specialty.getName(context);

                return InkWell(
                  onTap: () => widget.onSpecialtyTap?.call(specialty),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.borderLight,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getSpecialtyIcon(name),
                          size: 28.r,
                          color: AppColors.colorPrimary,
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.buttonBlackTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

