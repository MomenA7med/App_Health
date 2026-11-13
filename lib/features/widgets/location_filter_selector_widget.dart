import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/addresses/presentation/widgets/choose_address_bottom_sheet.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/logic/user_manager.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class LocationFilterSelectorWidget extends StatelessWidget {
  final String locationMode; // 'area' or 'saved'
  final ValueChanged<String> onLocationModeChanged;
  final List<GovernorateModel> governorates;
  final String? selectedGovernorateId;
  final String? selectedGovernorateName;
  final String? selectedAreaId;
  final String? selectedAreaName;
  final void Function(String? id, String? name) onGovernorateChanged;
  final void Function(String? id, String? name) onAreaChanged;
  final void Function(String? govId, String? areaId)? onSavedAddressSelected;

  const LocationFilterSelectorWidget({
    super.key,
    required this.locationMode,
    required this.onLocationModeChanged,
    required this.governorates,
    this.selectedGovernorateId,
    this.selectedGovernorateName,
    this.selectedAreaId,
    this.selectedAreaName,
    required this.onGovernorateChanged,
    required this.onAreaChanged,
    this.onSavedAddressSelected,
  });

  GovernorateModel? get _currentGovernorate {
    if (governorates.isEmpty) return null;
    final matches = governorates.where(
      (g) =>
          (selectedGovernorateId != null && g.id == selectedGovernorateId) ||
          (selectedGovernorateName != null && g.name == selectedGovernorateName),
    );
    return matches.isNotEmpty ? matches.first : null;
  }

  List<AreaModel> get _currentAreas => _currentGovernorate?.areas ?? [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title: "طريقة تحديد الموقع"
        Text(
          context.translate(LocalizationKeys.locationMethod),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 12.h),

        // Tabs: تحديد المنطقة | عنوان محفوظ
        _buildTabs(context),
        SizedBox(height: 12.h),

        // Content: Side-by-side Dropdowns or Saved Address Card
        if (locationMode == 'area')
          _buildDropdownsRow(context)
        else
          _buildSavedAddressCard(context),
      ],
    );
  }

  Widget _buildTabs(BuildContext context) {
    final bool isAreaSelected = locationMode == 'area';

    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.tabBackground,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          // Tab 1: تحديد المنطقة
          Expanded(
            child: InkWell(
              onTap: () => onLocationModeChanged('area'),
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                decoration: BoxDecoration(
                  color: isAreaSelected ? AppColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: isAreaSelected
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
                  context.translate(LocalizationKeys.selectArea),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight:
                        isAreaSelected ? FontWeight.bold : FontWeight.w500,
                    color: isAreaSelected
                        ? AppColors.colorPrimary
                        : AppColors.textBody,
                  ),
                ),
              ),
            ),
          ),
          // Tab 2: عنوان محفوظ
          Expanded(
            child: InkWell(
              onTap: () => onLocationModeChanged('saved'),
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                decoration: BoxDecoration(
                  color: !isAreaSelected ? AppColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: !isAreaSelected
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
                  context.translate(LocalizationKeys.savedAddress),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight:
                        !isAreaSelected ? FontWeight.bold : FontWeight.w500,
                    color: !isAreaSelected
                        ? AppColors.colorPrimary
                        : AppColors.textBody,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownsRow(BuildContext context) {
    final curGov = _currentGovernorate;
    final validGovId = curGov != null ? curGov.id : null;

    final curAreas = _currentAreas;
    final validAreaMatch = curAreas.where(
      (a) =>
          (selectedAreaId != null && a.id == selectedAreaId) ||
          (selectedAreaName != null && a.name == selectedAreaName),
    );
    final validAreaId = validAreaMatch.isNotEmpty ? validAreaMatch.first.id : null;

    return Row(
      children: [
        // Governorate Dropdown (المحافظة)
        Expanded(
          child: _buildDropdownField<String>(
            label: context.translate(LocalizationKeys.governorate),
            hintText: context.translate(LocalizationKeys.governorate),
            currentValue: validGovId,
            items: governorates.map((gov) {
              return DropdownMenuItem<String>(
                value: gov.id,
                child: Text(
                  gov.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newGovId) {
              if (newGovId == null) {
                onGovernorateChanged(null, null);
                onAreaChanged(null, null);
                return;
              }
              final matches = governorates.where((g) => g.id == newGovId);
              if (matches.isNotEmpty) {
                final gov = matches.first;
                onGovernorateChanged(gov.id, gov.name);
                onAreaChanged(null, null);
              }
            },
          ),
        ),
        SizedBox(width: 12.w),

        // Area Dropdown (المنطقة)
        Expanded(
          child: _buildDropdownField<String>(
            label: context.translate(LocalizationKeys.area),
            hintText: context.translate(LocalizationKeys.area),
            currentValue: validAreaId,
            items: curAreas.map((area) {
              return DropdownMenuItem<String>(
                value: area.id,
                child: Text(
                  area.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newAreaId) {
              if (newAreaId == null) {
                onAreaChanged(null, null);
                return;
              }
              final matches = curAreas.where((a) => a.id == newAreaId);
              if (matches.isNotEmpty) {
                final area = matches.first;
                onAreaChanged(area.id, area.name);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    String? hintText,
    required List<DropdownMenuItem<T>> items,
    required T? currentValue,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textBody,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: currentValue,
              hint: hintText != null
                  ? Text(
                      hintText,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textBody,
                      ),
                    )
                  : null,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textBody,
              ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedAddressCard(BuildContext context) {
    String savedAddress = '';
    if (GetIt.I.isRegistered<UserMangers>()) {
      savedAddress = GetIt.I<UserMangers>().getAddress();
    }
    if (savedAddress.trim().isEmpty) {
      savedAddress = context.translate(
        LocalizationKeys.fromAddressesOrCurrentLocation,
      );
    }

    return InkWell(
      onTap: () async {
        final address = await ChooseAddressBottomSheet.show(
          context: context,
          onSelectAddress: (selected) {
            onSavedAddressSelected?.call(selected.governorate, selected.area);
          },
        );
        if (address != null) {
          onSavedAddressSelected?.call(address.governorate, address.area);
        }
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: AppColors.colorSecondary.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: AppColors.colorPrimary,
                size: 20.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.translate(LocalizationKeys.chooseAddress),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    savedAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textBody,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.colorPrimary,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}

