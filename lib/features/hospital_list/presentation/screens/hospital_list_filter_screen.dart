import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/core/presentation/widgets/custom_app_bar.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/hospital_list/data/datasources/hospital_list_api_manager.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_filter_model.dart';
import 'package:app_health/features/hospital_list/data/repository/hospital_list_repository.dart';
import 'package:app_health/features/hospital_list/domain/repositories/base_hospital_list_repository.dart';
import 'package:app_health/features/medical_specialties/data/datasources/medical_specialties_api_manager.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';
import 'package:app_health/features/medical_specialties/data/repository/medical_specialties_repository.dart';
import 'package:app_health/features/medical_specialties/domain/usecases/get_medical_specialties_usecase.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/features/widgets/app_filter_dropdown_widget.dart';
import 'package:app_health/features/widgets/location_filter_selector_widget.dart';
import 'package:app_health/features/widgets/medical_specialty_filter_dropdown_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/app_image/app_cached_network_image.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class HospitalListFilterScreen extends BaseStatefulScreenWidget {
  final HospitalFilterModel currentFilter;
  final BaseHospitalListRepository? repository;
  final GetMedicalSpecialtiesUseCase? getMedicalSpecialtiesUseCase;

  const HospitalListFilterScreen({
    super.key,
    required this.currentFilter,
    this.repository,
    this.getMedicalSpecialtiesUseCase,
  });

  static const String routeName = '/hospital-list-filter';

  static Future<HospitalFilterModel?> open({
    required BuildContext context,
    required HospitalFilterModel currentFilter,
    BaseHospitalListRepository? repository,
    GetMedicalSpecialtiesUseCase? getMedicalSpecialtiesUseCase,
  }) {
    return Navigator.of(context).push<HospitalFilterModel>(
      MaterialPageRoute(
        builder: (_) => HospitalListFilterScreen(
          currentFilter: currentFilter,
          repository: repository,
          getMedicalSpecialtiesUseCase: getMedicalSpecialtiesUseCase,
        ),
      ),
    );
  }

  @override
  BaseScreenState<HospitalListFilterScreen> baseScreenCreateState() =>
      _HospitalListFilterScreenState();
}

class _HospitalListFilterScreenState
    extends BaseScreenState<HospitalListFilterScreen> {
  late BaseHospitalListRepository _repository;
  late GetMedicalSpecialtiesUseCase _getMedicalSpecialtiesUseCase;

  late String _locationMode; // 'area' or 'saved'
  String? _selectedGovernorate;
  String? _selectedGovernorateId;
  String? _selectedArea;
  String? _selectedAreaId;
  String? _selectedSpecialty;
  String? _selectedSpecialtyId;
  String? _selectedInsurance;
  String? _selectedInsuranceId;

  List<GovernorateModel> _governorates = [];
  List<MedicalSpecialtyModel> _specialties = [];
  List<InsuranceCompanyModel> _insuranceCompanies = [];

  @override
  void initState() {
    super.initState();
    _repository =
        widget.repository ??
        HospitalListRepository(
          HospitalListApiManager(GetIt.I<DioApiManager>()),
        );
    _getMedicalSpecialtiesUseCase =
        widget.getMedicalSpecialtiesUseCase ??
        GetMedicalSpecialtiesUseCase(
          MedicalSpecialtiesRepository(
            MedicalSpecialtiesApiManager(GetIt.I<DioApiManager>()),
          ),
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
    _selectedSpecialty = filter.specialty;
    _selectedSpecialtyId = filter.specialtyId;
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
        _getMedicalSpecialtiesUseCase(NoParams()).catchError(
          (err) => Left(ErrorApiModel.identifyError(error: err)),
        ),
      ]);

      if (!mounted) return;

      final govResponse = results[0] as GovernoratesResponseModel;
      final insResponse = results[1] as InsuranceCompaniesResponseModel;
      final specEither = results[2]
          as Either<ErrorApiModel, MedicalSpecialtiesResponseModel>;

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

        specEither.fold(
          (_) {},
          (specResponse) {
            if (specResponse.data.isNotEmpty) {
              _specialties = specResponse.data;
              if (_selectedSpecialtyId != null) {
                final matchSpec = _specialties.where(
                  (s) => s.id == _selectedSpecialtyId,
                );
                if (matchSpec.isNotEmpty) {
                  _selectedSpecialty = matchSpec.first.getName(context);
                }
              }
            }
          },
        );
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
      _selectedSpecialty = null;
      _selectedSpecialtyId = null;
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
      governorate: _locationMode == 'saved' ? null : _selectedGovernorate,
      governorateId: effectiveGovId,
      area: _locationMode == 'saved' ? null : _selectedArea,
      areaId: effectiveAreaId,
      specialty: _selectedSpecialty,
      specialtyId: _selectedSpecialtyId,
      insuranceCompany: _selectedInsurance,
      insuranceCompanyId: _selectedInsuranceId,
      clearGovernorate:
          _locationMode == 'saved' || _selectedGovernorate == null,
      clearArea: _locationMode == 'saved' || _selectedArea == null,
      clearSpecialty: _selectedSpecialtyId == null,
      clearInsurance: _selectedInsuranceId == null,
    );

    Navigator.of(context).pop(result);
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

                    // Section 1: Location
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

                    // Section 2: Medical Specialty
                    MedicalSpecialtyFilterDropdownWidget(
                      showDividerAbove: true,
                      specialties: _specialties,
                      selectedSpecialtyId: _selectedSpecialtyId,
                      onSpecialtyChanged: (id, name) {
                        setState(() {
                          _selectedSpecialtyId = id;
                          _selectedSpecialty = name;
                        });
                      },
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
    ];

    return AppFilterDropdownWidget<String?>(
      value: hasValidSelection ? _selectedInsuranceId : null,
      hintText: context.translate(LocalizationKeys.chooseInsuranceCompany),
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
    );
  }
}
