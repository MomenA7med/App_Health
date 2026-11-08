import 'package:app_health/features/addresses/presentation/widgets/choose_address_bottom_sheet.dart';
import 'package:app_health/features/core/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/doctor_list/data/datasources/doctor_list_api_manager.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/doctor_list/data/repository/doctor_list_repository.dart';
import 'package:app_health/features/doctor_list/domain/repositories/base_doctor_list_repository.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/logic/user_manager.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/app_image/app_cached_network_image.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorListFilterScreen extends BaseStatefulScreenWidget {
  final DoctorFilterModel currentFilter;
  final ValueChanged<DoctorFilterModel> onApply;
  final BaseDoctorListRepository? repository;

  const DoctorListFilterScreen({
    super.key,
    required this.currentFilter,
    required this.onApply,
    this.repository,
  });

  static Future<void> open({
    required BuildContext context,
    required DoctorFilterModel currentFilter,
    required ValueChanged<DoctorFilterModel> onApply,
    BaseDoctorListRepository? repository,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DoctorListFilterScreen(
          currentFilter: currentFilter,
          onApply: onApply,
          repository: repository,
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
  late BaseDoctorListRepository _repository;

  // Selected Filter State
  late String _locationMode; // 'area' or 'saved'
  String? _selectedGovernorate;
  String? _selectedGovernorateId;
  String? _selectedArea;
  String? _selectedAreaId;
  late int _selectedGender;
  late RangeValues _priceRange;
  late String _selectedDate;
  String? _selectedInsurance;
  String? _selectedInsuranceId;

  // Remote / Lookup Data
  List<GovernorateModel> _governorates = [];
  List<InsuranceCompanyModel> _insuranceCompanies = [];

  @override
  void initState() {
    super.initState();
    _repository =
        widget.repository ??
        DoctorListRepository(DoctorListApiManager(GetIt.I<DioApiManager>()));

    _resetToCurrent();
    _fetchLookups();
  }

  void _resetToCurrent() {
    final filter = widget.currentFilter;
    _locationMode = filter.locationMode ?? 'area';
    _selectedGovernorate = filter.governorate;
    _selectedGovernorateId = filter.governorateId;
    _selectedArea = filter.area;
    _selectedAreaId = filter.areaId;
    _selectedGender = filter.gender ?? 0;
    _priceRange = RangeValues(filter.minPrice ?? 0, filter.maxPrice ?? 1000);
    _selectedDate = filter.consultationDate ?? 'any';
    _selectedInsurance = filter.insuranceCompany;
    _selectedInsuranceId = filter.insuranceCompanyId;
  }

  Future<void> _fetchLookups() async {
    try {
      final results = await Future.wait([
        _repository.getGovernoratesApi().catchError(
          (_) => GovernoratesResponseModel(
            success: false,
            code: '',
            message: '',
            data: [],
          ),
        ),
        _repository.getInsuranceCompaniesApi().catchError(
          (_) => InsuranceCompaniesResponseModel(
            success: false,
            code: '',
            message: '',
            data: [],
          ),
        ),
      ]);

      if (!mounted) return;

      final govResponse = results[0] as GovernoratesResponseModel;
      final insResponse = results[1] as InsuranceCompaniesResponseModel;

      setState(() {
        if (govResponse.data.isNotEmpty) {
          _governorates = govResponse.data;
          // Synchronize only if user already had a saved selection
          if (_selectedGovernorateId != null || _selectedGovernorate != null) {
            final matches = _governorates.where(
              (g) =>
                  g.id == _selectedGovernorateId ||
                  g.name == _selectedGovernorate,
            );
            if (matches.isNotEmpty) {
              final matchGov = matches.first;
              _selectedGovernorate = matchGov.name;
              _selectedGovernorateId = matchGov.id;

              if (_selectedAreaId != null || _selectedArea != null) {
                final areaMatches = matchGov.areas.where(
                  (a) => a.id == _selectedAreaId || a.name == _selectedArea,
                );
                if (areaMatches.isNotEmpty) {
                  _selectedArea = areaMatches.first.name;
                  _selectedAreaId = areaMatches.first.id;
                }
              }
            }
          }
        }

        if (insResponse.data.isNotEmpty) {
          _insuranceCompanies = insResponse.data;
          if (_selectedInsuranceId != null) {
            final matchIns = _insuranceCompanies.where(
              (i) => i.id == _selectedInsuranceId,
            );
            if (matchIns.isNotEmpty) {
              _selectedInsurance = matchIns.first.nameAr;
            }
          }
        }
      });
    } catch (_) {}
  }

  void _clearAllFilters() {
    setState(() {
      _locationMode = 'area';
      _selectedGovernorate = null;
      _selectedGovernorateId = null;
      _selectedArea = null;
      _selectedAreaId = null;
      _selectedGender = 0;
      _priceRange = const RangeValues(0, 1000);
      _selectedDate = 'any';
      _selectedInsurance = null;
      _selectedInsuranceId = null;
    });
  }

  GovernorateModel? get _currentGovernorate {
    if (_governorates.isEmpty ||
        (_selectedGovernorateId == null && _selectedGovernorate == null)) {
      return null;
    }
    final matches = _governorates.where(
      (g) => g.id == _selectedGovernorateId || g.name == _selectedGovernorate,
    );
    return matches.isNotEmpty ? matches.first : null;
  }

  List<AreaModel> get _currentAreas {
    return _currentGovernorate?.areas ?? [];
  }

  String? _resolveGovId(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final matches = _governorates.where((g) => g.id == raw || g.name == raw);
    return matches.isNotEmpty ? matches.first.id : raw;
  }

  String? _resolveGovName(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final matches = _governorates.where((g) => g.id == raw || g.name == raw);
    return matches.isNotEmpty ? matches.first.name : raw;
  }

  String? _resolveAreaId(String? raw, String? govId) {
    if (raw == null || raw.isEmpty) return null;
    for (final g in _governorates) {
      if (govId == null || g.id == govId || g.name == govId) {
        final matches = g.areas.where((a) => a.id == raw || a.name == raw);
        if (matches.isNotEmpty) return matches.first.id;
      }
    }
    return raw;
  }

  String? _resolveAreaName(String? raw, String? govId) {
    if (raw == null || raw.isEmpty) return null;
    for (final g in _governorates) {
      if (govId == null || g.id == govId || g.name == govId) {
        final matches = g.areas.where((a) => a.id == raw || a.name == raw);
        if (matches.isNotEmpty) return matches.first.name;
      }
    }
    return raw;
  }

  Widget _buildProfileTabs() {
    final bool isAreaSelected = _locationMode == 'area';
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
              onTap: () {
                setState(() {
                  _locationMode = 'area';
                });
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                decoration: BoxDecoration(
                  color: isAreaSelected ? Colors.white : Colors.transparent,
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
                    fontWeight: isAreaSelected
                        ? FontWeight.bold
                        : FontWeight.w500,
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
              onTap: () {
                setState(() {
                  _locationMode = 'saved';
                });
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                decoration: BoxDecoration(
                  color: !isAreaSelected ? Colors.white : Colors.transparent,
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
                    fontWeight: !isAreaSelected
                        ? FontWeight.bold
                        : FontWeight.w500,
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

  Widget _buildDropdownField<T>({
    required String label,
    required String valueText,
    String? hintText,
    required List<DropdownMenuItem<T>> items,
    required T? currentValue,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
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

  Widget _buildSavedAddressCard() {
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
            setState(() {
              _selectedGovernorateId = selected.governorate;
              _selectedAreaId = selected.area;
            });
          },
        );
        if (address != null && mounted) {
          setState(() {
            _selectedGovernorateId = address.governorate;
            _selectedAreaId = address.area;
          });
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

  Widget _buildGenderChip({required int doctorType, required String title}) {
    final bool isSelected = _selectedGender == doctorType;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGender = doctorType;
          });
        },
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          height: 46.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.chipSelectedBg : Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.chipSelectedBg
                  : AppColors.borderSubtle,
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
                  : AppColors.textBody,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateChip({required String key, required String title}) {
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
          height: 46.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.chipSelectedBg : Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.chipSelectedBg
                  : AppColors.borderSubtle,
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
                  : AppColors.textBody,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsuranceDropdown() {
    final bool hasValidSelection = _insuranceCompanies.any(
      (c) => c.id == _selectedInsuranceId,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          isExpanded: true,
          value: hasValidSelection ? _selectedInsuranceId : null,
          hint: Text(
            context.translate(LocalizationKeys.chooseInsuranceCompany),
            style: TextStyle(fontSize: 14.sp, color: AppColors.textBody),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textBody,
          ),
          items: [
            DropdownMenuItem<String?>(
              value: '',
              child: Text(
                context.translate(LocalizationKeys.noInsurance),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBody,
                ),
              ),
            ),
            ..._insuranceCompanies.map((company) {
              final name = company.nameAr.isNotEmpty
                  ? company.nameAr
                  : company.nameEn;
              return DropdownMenuItem<String?>(
                value: company.id,
                child: Row(
                  children: [
                    if (company.logoUrl != null &&
                        company.logoUrl!.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: AppCachedNetworkImage(
                            imageUrl: company.logoUrl!,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          onChanged: (newCompanyId) {
            setState(() {
              if (newCompanyId == null || newCompanyId.isEmpty) {
                _selectedInsuranceId = null;
                _selectedInsurance = null;
              } else {
                _selectedInsuranceId = newCompanyId;
                final matched = _insuranceCompanies.firstWhere(
                  (c) => c.id == newCompanyId,
                );
                _selectedInsurance = matched.nameAr.isNotEmpty
                    ? matched.nameAr
                    : matched.nameEn;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    final currencyText = context.translate(LocalizationKeys.currencyEgp);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showLocation: false,
        screenTitle: context.translate(LocalizationKeys.filterResults),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter Intro: "اختار اللي يناسبك" + "مسح الكل"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            context.translate(
                              LocalizationKeys.chooseWhatSuitsYou,
                            ),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _clearAllFilters,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
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

                    // Location Filters Section: "طريقة تحديد الموقع"
                    Text(
                      context.translate(LocalizationKeys.locationMethod),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Profile Tabs
                    _buildProfileTabs(),
                    SizedBox(height: 12.h),

                    // Conditional Content based on Location Mode
                    if (_locationMode == 'area')
                      Row(
                        children: [
                          // Governorate Dropdown (المحافظة)
                          Expanded(
                            child: _buildDropdownField<String>(
                              label: context.translate(
                                LocalizationKeys.governorate,
                              ),
                              hintText: context.translate(
                                LocalizationKeys.governorate,
                              ),
                              valueText: _selectedGovernorate ?? '',
                              currentValue:
                                  _governorates.any(
                                    (g) => g.id == _selectedGovernorateId,
                                  )
                                  ? _selectedGovernorateId
                                  : null,
                              items: _governorates.map((gov) {
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
                                if (newGovId == null) return;
                                final gov = _governorates.firstWhere(
                                  (g) => g.id == newGovId,
                                );
                                setState(() {
                                  _selectedGovernorateId = gov.id;
                                  _selectedGovernorate = gov.name;
                                  _selectedAreaId = null;
                                  _selectedArea = null;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Area Dropdown (المنطقة)
                          Expanded(
                            child: _buildDropdownField<String>(
                              label: context.translate(LocalizationKeys.area),
                              hintText: context.translate(
                                LocalizationKeys.area,
                              ),
                              valueText: _selectedArea ?? '',
                              currentValue:
                                  _currentAreas.any(
                                    (a) => a.id == _selectedAreaId,
                                  )
                                  ? _selectedAreaId
                                  : null,
                              items: _currentAreas.map((area) {
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
                                if (newAreaId == null) return;
                                final area = _currentAreas.firstWhere(
                                  (a) => a.id == newAreaId,
                                );
                                setState(() {
                                  _selectedAreaId = area.id;
                                  _selectedArea = area.name;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      _buildSavedAddressCard(),

                    SizedBox(height: 20.h),
                    const Divider(color: AppColors.borderSubtle, thickness: 1),
                    SizedBox(height: 16.h),

                    // Doctor Gender Section: "نوع الطبيب"
                    Text(
                      context.translate(LocalizationKeys.doctorGender),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        _buildGenderChip(
                          doctorType: 0,
                          title: context.translate(LocalizationKeys.all),
                        ),
                        SizedBox(width: 10.w),
                        _buildGenderChip(
                          doctorType: 1,
                          title: context.translate(LocalizationKeys.maleDoctor),
                        ),
                        SizedBox(width: 10.w),
                        _buildGenderChip(
                          doctorType: 2,
                          title: context.translate(
                            LocalizationKeys.femaleDoctor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Consultation Fee Section: "سعر الكشف"
                    Text(
                      context.translate(LocalizationKeys.consultationFee),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
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
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: AppColors.borderSubtle,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              context
                                  .translate(LocalizationKeys.fromPrice)
                                  .replaceAll(
                                    '{price}',
                                    _priceRange.start.round().toString(),
                                  ),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.colorPrimary,
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
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: AppColors.borderSubtle,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              context
                                  .translate(LocalizationKeys.toPrice)
                                  .replaceAll(
                                    '{price}',
                                    _priceRange.end.round().toString(),
                                  ),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.colorPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      activeColor: AppColors.colorPrimary,
                      inactiveColor: AppColors.sliderInactiveTrack,
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
                            '0 $currencyText',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textBody,
                            ),
                          ),
                          Text(
                            '1000 $currencyText',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textBody,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    const Divider(color: AppColors.borderSubtle, thickness: 1),
                    SizedBox(height: 16.h),

                    // Consultation Date Section: "تاريخ الكشف"
                    Text(
                      context.translate(LocalizationKeys.consultationDate),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
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

                    // Health Insurance Section: "التأمين الصحي"
                    Text(
                      context.translate(LocalizationKeys.healthInsurance),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildInsuranceDropdown(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Bottom CTA Button: "عرض النتائج"
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: AppElevatedButton.withTitle(
                  onPressed: () {
                    final resolvedGovId = _locationMode == 'area'
                        ? _resolveGovId(
                            _selectedGovernorateId ?? _selectedGovernorate,
                          )
                        : null;
                    final resolvedGovName = _locationMode == 'area'
                        ? _resolveGovName(
                            _selectedGovernorate ?? _selectedGovernorateId,
                          )
                        : null;
                    final resolvedAreaId = _locationMode == 'area'
                        ? _resolveAreaId(
                            _selectedAreaId ?? _selectedArea,
                            resolvedGovId,
                          )
                        : null;
                    final resolvedAreaName = _locationMode == 'area'
                        ? _resolveAreaName(
                            _selectedArea ?? _selectedAreaId,
                            resolvedGovId,
                          )
                        : null;

                    final updatedFilter = DoctorFilterModel(
                      locationMode: _locationMode,
                      governorate: resolvedGovName,
                      governorateId: resolvedGovId,
                      area: resolvedAreaName,
                      areaId: resolvedAreaId,
                      gender: _selectedGender,
                      minPrice: _priceRange.start,
                      maxPrice: _priceRange.end,
                      consultationDate: _selectedDate,
                      insuranceCompany: _selectedInsurance,
                      insuranceCompanyId: _selectedInsuranceId,
                      searchQuery: widget.currentFilter.searchQuery,
                    );
                    widget.onApply(updatedFilter);
                    Navigator.of(context).pop();
                  },
                  title: context.translate(LocalizationKeys.showResults),
                  color: AppColors.colorPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
