import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/core/presentation/widgets/custom_app_bar.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/pharmacies_list/data/datasources/pharmacies_list_api_manager.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_filter_model.dart';
import 'package:app_health/features/pharmacies_list/data/repository/pharmacies_list_repository.dart';
import 'package:app_health/features/pharmacies_list/domain/repositories/base_pharmacies_list_repository.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/features/widgets/location_filter_selector_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/app_image/app_cached_network_image.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PharmaciesListFilterScreen extends BaseStatefulScreenWidget {
  final PharmacyFilterModel currentFilter;
  final BasePharmaciesListRepository? repository;

  const PharmaciesListFilterScreen({
    super.key,
    required this.currentFilter,
    this.repository,
  });

  static const String routeName = '/pharmacies-list-filter';

  static Future<PharmacyFilterModel?> open({
    required BuildContext context,
    required PharmacyFilterModel currentFilter,
    BasePharmaciesListRepository? repository,
  }) {
    return Navigator.of(context).push<PharmacyFilterModel>(
      MaterialPageRoute(
        builder: (_) => PharmaciesListFilterScreen(
          currentFilter: currentFilter,
          repository: repository,
        ),
      ),
    );
  }

  @override
  BaseScreenState<PharmaciesListFilterScreen> baseScreenCreateState() =>
      _PharmaciesListFilterScreenState();
}

class _PharmaciesListFilterScreenState
    extends BaseScreenState<PharmaciesListFilterScreen> {
  late BasePharmaciesListRepository _repository;

  late String _locationMode; // 'area' or 'saved'
  String? _selectedGovernorate;
  String? _selectedGovernorateId;
  String? _selectedArea;
  String? _selectedAreaId;
  int? _selectedWorkingHours; // null = all, 1 = openNow, 2 = 24h
  String? _selectedInsurance;
  String? _selectedInsuranceId;

  List<GovernorateModel> _governorates = [];
  List<InsuranceCompanyModel> _insuranceCompanies = [];

  @override
  void initState() {
    super.initState();
    _repository =
        widget.repository ??
        PharmaciesListRepository(
          PharmaciesListApiManager(GetIt.I<DioApiManager>()),
        );

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
    _selectedWorkingHours = filter.workingHoursFilter;
    _selectedInsurance = filter.insuranceCompany;
    _selectedInsuranceId = filter.insuranceCompanyId;
  }

  Future<void> _fetchLookups() async {
    try {
      final results = await Future.wait([
        _repository.getGovernoratesApi().catchError(
          (_) => const GovernoratesResponseModel(
            success: false,
            code: '',
            message: '',
            data: [],
          ),
        ),
        _repository.getInsuranceCompaniesApi().catchError(
          (_) => const InsuranceCompaniesResponseModel(
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
      _selectedWorkingHours = null;
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

  String? _resolveGovId(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final matches = _governorates.where((g) => g.id == raw || g.name == raw);
    if (matches.isNotEmpty) return matches.first.id;
    return raw;
  }

  String? _resolveAreaId(String? rawArea) {
    if (rawArea == null || rawArea.isEmpty) return null;
    final curGov = _currentGovernorate;
    if (curGov != null) {
      final matches = curGov.areas.where(
        (a) => a.id == rawArea || a.name == rawArea,
      );
      if (matches.isNotEmpty) return matches.first.id;
    }
    for (final g in _governorates) {
      final matches = g.areas.where(
        (a) => a.id == rawArea || a.name == rawArea,
      );
      if (matches.isNotEmpty) return matches.first.id;
    }
    return rawArea;
  }

  void _applyFilters() {
    final effectiveGovId = _locationMode == 'saved'
        ? null
        : _resolveGovId(_selectedGovernorateId ?? _selectedGovernorate);

    final effectiveAreaId = _locationMode == 'saved'
        ? null
        : _resolveAreaId(_selectedAreaId ?? _selectedArea);

    final result = widget.currentFilter.copyWith(
      locationMode: _locationMode,
      locationStrategy: _locationMode == 'saved' ? 1 : 0,
      governorate: _locationMode == 'saved' ? null : _selectedGovernorate,
      governorateId: effectiveGovId,
      area: _locationMode == 'saved' ? null : _selectedArea,
      areaId: effectiveAreaId,
      workingHoursFilter: _selectedWorkingHours,
      workingHoursLabel: _getWorkingHoursLabel(_selectedWorkingHours),
      insuranceCompany: _selectedInsurance,
      insuranceCompanyId: _selectedInsuranceId,
      clearGovernorate:
          _locationMode == 'saved' || _selectedGovernorate == null,
      clearArea: _locationMode == 'saved' || _selectedArea == null,
      clearWorkingHours: _selectedWorkingHours == null,
      clearInsurance: _selectedInsuranceId == null,
    );

    Navigator.of(context).pop(result);
  }

  String? _getWorkingHoursLabel(int? filter) {
    if (filter == 1) return context.translate(LocalizationKeys.openNow);
    if (filter == 2) {
      return context.translate(LocalizationKeys.twentyFourHoursOnly);
    }
    return null;
  }

  Widget _buildWorkingHoursChip({
    required int? filterValue,
    required String title,
  }) {
    final bool isSelected = _selectedWorkingHours == filterValue;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedWorkingHours = filterValue;
          });
        },
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          height: 46.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.chipSelectedBg : AppColors.white,
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
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.colorPrimary : AppColors.textBody,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildInsuranceDropdown() {
    final bool hasValidSelection = _insuranceCompanies.any(
      (c) => c.id == _selectedInsuranceId,
    );

    final List<DropdownMenuItem<String?>> items = [
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
              if (company.logoUrl != null && company.logoUrl!.isNotEmpty) ...[
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
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          isExpanded: true,
          value: hasValidSelection ? _selectedInsuranceId : null,
          hint: Text(
            context.translate(LocalizationKeys.chooseInsuranceCompany),
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        showLocation: false,
        screenTitle: context.translate(LocalizationKeys.filterResults),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: "اختار اللي يناسبك" + "مسح الكل"
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

                    // Section 1: Location Filter
                    LocationFilterSelectorWidget(
                      locationMode: _locationMode,
                      onLocationModeChanged: (mode) {
                        setState(() {
                          _locationMode = mode;
                        });
                      },
                      governorates: _governorates,
                      selectedGovernorateId: _selectedGovernorateId,
                      selectedGovernorateName: _selectedGovernorate,
                      selectedAreaId: _selectedAreaId,
                      selectedAreaName: _selectedArea,
                      onGovernorateChanged: (id, name) {
                        setState(() {
                          _selectedGovernorateId = id;
                          _selectedGovernorate = name;
                          _selectedAreaId = null;
                          _selectedArea = null;
                        });
                      },
                      onAreaChanged: (id, name) {
                        setState(() {
                          _selectedAreaId = id;
                          _selectedArea = name;
                        });
                      },
                      onSavedAddressSelected: (govId, areaId) {
                        setState(() {
                          _selectedGovernorateId = govId;
                          _selectedAreaId = areaId;
                        });
                      },
                    ),

                    SizedBox(height: 20.h),
                    const Divider(color: AppColors.borderSubtle, thickness: 1),
                    SizedBox(height: 16.h),

                    // Section 2: Working Hours
                    Text(
                      context.translate(LocalizationKeys.pharmacyWorkingHours),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        _buildWorkingHoursChip(
                          filterValue: null,
                          title: context.translate(
                            LocalizationKeys.allWorkingHours,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _buildWorkingHoursChip(
                          filterValue: 1,
                          title: context.translate(LocalizationKeys.openNow),
                        ),
                        SizedBox(width: 8.w),
                        _buildWorkingHoursChip(
                          filterValue: 2,
                          title: context.translate(
                            LocalizationKeys.twentyFourHoursOnly,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),
                    const Divider(color: AppColors.borderSubtle, thickness: 1),
                    SizedBox(height: 16.h),

                    // Section 3: Health Insurance
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
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),

            // Bottom Apply Button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: AppElevatedButton.withTitle(
                title: context.translate(LocalizationKeys.showResults),
                textColor: AppColors.buttonWhiteTextColor,
                color: AppColors.colorPrimary,
                onPressed: _applyFilters,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

