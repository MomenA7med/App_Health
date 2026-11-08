import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class SavedAddressItemWidget extends StatelessWidget {
  final UserAddressModel address;
  final bool isSelected;
  final List<GovernorateModel> governorates;
  final VoidCallback onTap;

  const SavedAddressItemWidget({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onTap,
    this.governorates = const [],
  });

  String _buildSubtitle() {
    String govName = '';
    String areaName = '';

    for (final gov in governorates) {
      if (gov.id == address.governorate) {
        govName = gov.name;
        for (final a in gov.areas) {
          if (a.id == address.area) {
            areaName = a.name;
            break;
          }
        }
        break;
      }
    }

    if (areaName.isNotEmpty && govName.isNotEmpty) {
      return '$areaName، $govName';
    } else if (govName.isNotEmpty) {
      return govName;
    } else if (address.detailedAddress.isNotEmpty) {
      return address.detailedAddress;
    }
    return '';
  }

  bool _isHomeAddress() {
    final name = address.addressName.toLowerCase().trim();
    return name.contains('منزل') ||
        name.contains('بيت') ||
        name.contains('home');
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _buildSubtitle();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.colorSecondary.withValues(alpha: 0.3)
              : AppColors.tabBackground,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected
                ? AppColors.colorPrimary
                : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Icon Badge on the start (RTL right)
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.chipSelectedBg,
              ),
              alignment: Alignment.center,
              child: Icon(
                _isHomeAddress()
                    ? Icons.home_outlined
                    : Icons.location_on_outlined,
                size: 20.r,
                color: AppColors.colorPrimary,
              ),
            ),
            SizedBox(width: 12.w),

            // Address Details in the middle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    address.addressName.isNotEmpty
                        ? address.addressName
                        : context.translate(LocalizationKeys.savedAddress),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textBody,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 12.w),

            // Action on the end (RTL left)
            Text(
              context.translate(LocalizationKeys.selectAction),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

