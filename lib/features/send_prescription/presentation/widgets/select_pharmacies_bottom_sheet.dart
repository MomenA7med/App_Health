import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class SelectPharmaciesBottomSheet extends StatefulWidget {
  final List<PharmacyModel> availablePharmacies;
  final List<PharmacyModel> initialSelectedPharmacies;
  final ValueChanged<List<PharmacyModel>> onConfirm;

  const SelectPharmaciesBottomSheet({
    super.key,
    required this.availablePharmacies,
    required this.initialSelectedPharmacies,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required List<PharmacyModel> availablePharmacies,
    required List<PharmacyModel> initialSelectedPharmacies,
    required ValueChanged<List<PharmacyModel>> onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => SelectPharmaciesBottomSheet(
        availablePharmacies: availablePharmacies,
        initialSelectedPharmacies: initialSelectedPharmacies,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<SelectPharmaciesBottomSheet> createState() =>
      _SelectPharmaciesBottomSheetState();
}

class _SelectPharmaciesBottomSheetState
    extends State<SelectPharmaciesBottomSheet> {
  late final TextEditingController _searchController;
  late List<PharmacyModel> _selectedPharmacies;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedPharmacies = List<PharmacyModel>.from(widget.initialSelectedPharmacies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PharmacyModel> get _filteredPharmacies {
    if (_searchQuery.trim().isEmpty) {
      return widget.availablePharmacies;
    }
    final q = _searchQuery.trim().toLowerCase();
    return widget.availablePharmacies.where((p) {
      final nameMatches = p.name.toLowerCase().contains(q);
      final branchMatches = p.branchName?.toLowerCase().contains(q) ?? false;
      final addressMatches = p.address.toLowerCase().contains(q);
      return nameMatches || branchMatches || addressMatches;
    }).toList();
  }

  void _toggleSelection(PharmacyModel pharmacy) {
    setState(() {
      final index = _selectedPharmacies.indexWhere((p) => p.id == pharmacy.id);
      if (index >= 0) {
        _selectedPharmacies.removeAt(index);
      } else {
        _selectedPharmacies.add(pharmacy);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        final pharmacies = _filteredPharmacies;

        return Column(
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.bottomSheetDragHandle,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // Header: Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.translate(LocalizationKeys.selectPharmacies),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonBlackTextColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 22.r,
                      color: AppColors.textBody,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Container(
                height: 46.h,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: AppColors.borderLight, width: 1.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 20.r,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: context.translate(
                            LocalizationKeys.searchPharmacy,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textMuted,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        child: Icon(
                          Icons.clear_rounded,
                          size: 18.r,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Pharmacies List
            Expanded(
              child: pharmacies.isEmpty
                  ? Center(
                      child: Text(
                        context.translate(
                          LocalizationKeys.noPharmaciesAvailableInArea,
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      itemCount: pharmacies.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final item = pharmacies[index];
                        final isSelected = _selectedPharmacies
                            .any((p) => p.id == item.id);
                        final distanceText = item.formattedDistance.isNotEmpty
                            ? context
                                .translate(LocalizationKeys.distanceKmAway)
                                .replaceAll('{distance}', item.formattedDistance)
                            : '';

                        return InkWell(
                          onTap: () => _toggleSelection(item),
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            height: 64.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.lightBlue
                                  : AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.colorPrimary
                                    : AppColors.borderLight,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Checkbox
                                Container(
                                  width: 22.r,
                                  height: 22.r,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.colorPrimary
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.colorPrimary
                                          : AppColors.borderLight,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check_rounded,
                                          size: 16.r,
                                          color: AppColors.white,
                                        )
                                      : null,
                                ),
                                SizedBox(width: 12.w),

                                // Pharmacy Information
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.displayName,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.buttonBlackTextColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        distanceText.isNotEmpty
                                            ? '${item.address} · $distanceText'
                                            : item.address,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.labelSubtitle,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Confirm Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: AppElevatedButton.withTitle(
                    title: context.translate(LocalizationKeys.confirmSelection),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    color: AppColors.colorPrimary,
                    textColor: AppColors.buttonWhiteTextColor,
                    onPressed: () {
                      widget.onConfirm(_selectedPharmacies);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

