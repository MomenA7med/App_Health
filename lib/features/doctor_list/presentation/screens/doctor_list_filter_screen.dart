import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorListFilterScreen extends BaseStatefulScreenWidget {
  final DoctorFilterModel currentFilter;
  final ValueChanged<DoctorFilterModel> onApply;

  const DoctorListFilterScreen({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  static Future<void> open({
    required BuildContext context,
    required DoctorFilterModel currentFilter,
    required ValueChanged<DoctorFilterModel> onApply,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DoctorListFilterScreen(
          currentFilter: currentFilter,
          onApply: onApply,
        ),
      ),
    );
  }

  @override
  BaseScreenState<DoctorListFilterScreen> baseScreenCreateState() =>
      _DoctorListFilterScreenState();
}

class _DoctorListFilterScreenState
    extends BaseScreenState<DoctorListFilterScreen> {
  late String _selectedGovernorate;
  late String _selectedArea;
  late String _selectedGender;
  late RangeValues _priceRange;
  late String _selectedDate;
  late String? _selectedInsurance;

  final List<String> _governorates = ['القاهرة', 'الجيزة', 'الإسكندرية'];
  final List<String> _areas = [
    'مدينة نصر',
    'المعادي',
    'المهندسين',
    'الدقي',
    'مصر الجديدة'
  ];
  final List<String> _insuranceCompanies = [
    'بوبا (Bupa)',
    'أكسا (AXA)',
    'ميتلايف (MetLife)',
    'أليانز (Allianz)',
    'التعاونية',
  ];

  @override
  void initState() {
    super.initState();
    _resetToCurrent();
  }

  void _resetToCurrent() {
    _selectedGovernorate = widget.currentFilter.governorate ?? 'القاهرة';
    _selectedArea = widget.currentFilter.area ?? 'مدينة نصر';
    _selectedGender = widget.currentFilter.gender ?? 'all';
    _priceRange = RangeValues(
      widget.currentFilter.minPrice ?? 200,
      widget.currentFilter.maxPrice ?? 800,
    );
    _selectedDate = widget.currentFilter.consultationDate ?? 'any';
    _selectedInsurance = widget.currentFilter.insuranceCompany;
  }

  void _clearAllFilters() {
    setState(() {
      _selectedGovernorate = 'القاهرة';
      _selectedArea = 'مدينة نصر';
      _selectedGender = 'all';
      _priceRange = const RangeValues(100, 1000);
      _selectedDate = 'any';
      _selectedInsurance = null;
    });
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16.r,
          color: AppColors.buttonBlackTextColor,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF94A3B8),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: items.contains(value) ? value : items.first,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF64748B),
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.buttonBlackTextColor,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderChip({
    required String key,
    required String title,
  }) {
    final bool isSelected = _selectedGender == key;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGender = key;
          });
        },
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.colorSecondary : Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.colorPrimary
                  : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? AppColors.colorPrimary
                  : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateChip({
    required String key,
    required String title,
  }) {
    final bool isSelected = _selectedDate == key;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDate = key;
          });
        },
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.colorSecondary : Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.colorPrimary
                  : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? AppColors.colorPrimary
                  : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: _buildBackButton(),
        ),
        title: Text(
          context.translate(LocalizationKeys.filterResults),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonBlackTextColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Title on the right & Clear All on the left
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.translate(LocalizationKeys.chooseWhatSuitsYou),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonBlackTextColor,
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    context.translate(LocalizationKeys.clearAll),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Search Location Section
            Text(
              context.translate(LocalizationKeys.searchLocation),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: context.translate(LocalizationKeys.governorate),
                    value: _selectedGovernorate,
                    items: _governorates,
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGovernorate = val);
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildDropdownField(
                    label: context.translate(LocalizationKeys.area),
                    value: _selectedArea,
                    items: _areas,
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedArea = val);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Choose Address Box: Icon on the right (RTL start), Text in middle, "اختيار" on the left
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: AppColors.colorSecondary.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.colorPrimary,
                      size: 20.r,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.translate(LocalizationKeys.chooseAddress),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.buttonBlackTextColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          context.translate(
                            LocalizationKeys.fromAddressesOrCurrentLocation,
                          ),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      context.translate(LocalizationKeys.choose),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            const Divider(color: Color(0xFFF1F5F9)),
            SizedBox(height: 16.h),

            // Doctor Gender Section
            Text(
              context.translate(LocalizationKeys.doctorGender),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildGenderChip(
                  key: 'all',
                  title: context.translate(LocalizationKeys.all),
                ),
                SizedBox(width: 10.w),
                _buildGenderChip(
                  key: 'male',
                  title: context.translate(LocalizationKeys.maleDoctor),
                ),
                SizedBox(width: 10.w),
                _buildGenderChip(
                  key: 'female',
                  title: context.translate(LocalizationKeys.femaleDoctor),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Consultation Fee Section
            Text(
              context.translate(LocalizationKeys.consultationFee),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      context.translate(LocalizationKeys.fromPrice).replaceAll(
                            '{price}',
                            _priceRange.start.round().toString(),
                          ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.buttonBlackTextColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      context.translate(LocalizationKeys.toPrice).replaceAll(
                            '{price}',
                            _priceRange.end.round().toString(),
                          ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.buttonBlackTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            RangeSlider(
              values: _priceRange,
              min: 100,
              max: 1000,
              divisions: 18,
              activeColor: AppColors.colorPrimary,
              inactiveColor: const Color(0xFFE2E8F0),
              onChanged: (values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '100 ${context.translate(LocalizationKeys.currencyEgp)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  Text(
                    '1000 ${context.translate(LocalizationKeys.currencyEgp)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            const Divider(color: Color(0xFFF1F5F9)),
            SizedBox(height: 16.h),

            // Consultation Date Section
            Text(
              context.translate(LocalizationKeys.consultationDate),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildDateChip(
                  key: 'any',
                  title: context.translate(LocalizationKeys.anyDay),
                ),
                SizedBox(width: 10.w),
                _buildDateChip(
                  key: 'today',
                  title: context.translate(LocalizationKeys.today),
                ),
                SizedBox(width: 10.w),
                _buildDateChip(
                  key: 'tomorrow',
                  title: context.translate(LocalizationKeys.tomorrow),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Health Insurance Section
            Text(
              context.translate(LocalizationKeys.healthInsurance),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  isExpanded: true,
                  hint: Text(
                    context.translate(LocalizationKeys.chooseInsuranceCompany),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  value: _selectedInsurance,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF64748B),
                  ),
                  items: _insuranceCompanies.map((item) {
                    return DropdownMenuItem<String?>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.buttonBlackTextColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedInsurance = val;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Bottom CTA: Show Results Button
            AppElevatedButton.withTitle(
              onPressed: () {
                final updatedFilter = widget.currentFilter.copyWith(
                  governorate: _selectedGovernorate,
                  area: _selectedArea,
                  gender: _selectedGender,
                  minPrice: _priceRange.start,
                  maxPrice: _priceRange.end,
                  consultationDate: _selectedDate,
                  insuranceCompany: _selectedInsurance,
                );
                widget.onApply(updatedFilter);
                Navigator.of(context).pop();
              },
              title: context.translate(LocalizationKeys.showResults),
              color: AppColors.colorPrimary,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

