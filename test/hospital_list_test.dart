import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_filter_model.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_list_send_model.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_lists_api_model_successful_response.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_model.dart';
import 'package:app_health/features/hospital_list/domain/entities/hospital_lists_ui_response.dart';
import 'package:app_health/features/hospital_list/domain/repositories/base_hospital_list_repository.dart';
import 'package:app_health/features/hospital_list/domain/usecases/get_hospital_list_use_case.dart';
import 'package:app_health/features/hospital_list/presentation/bloc/hospital_list_bloc.dart';
import 'package:app_health/features/hospital_list/presentation/bloc/hospital_list_event.dart';
import 'package:app_health/features/hospital_list/presentation/bloc/hospital_list_state.dart';
import 'package:app_health/features/hospital_list/presentation/screens/hospital_list_filter_screen.dart';
import 'package:app_health/features/hospital_list/presentation/widgets/hospital_card_widget.dart';
import 'package:app_health/features/hospital_list/presentation/widgets/hospital_sort_bottom_sheet_widget.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';
import 'package:app_health/features/medical_specialties/domain/repositories/base_medical_specialties_repository.dart';
import 'package:app_health/features/medical_specialties/domain/usecases/get_medical_specialties_usecase.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakeHospitalLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakeHospitalLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return _FakeHospitalLocalizations(locale);
  }

  @override
  bool shouldReload(_FakeHospitalLocalizationsDelegate old) => false;
}

class _FakeHospitalLocalizations extends AppLocalizations {
  _FakeHospitalLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.hospitals: 'المستشفيات',
    LocalizationKeys.searchHospitals: 'ابحث عن مستشفى...',
    LocalizationKeys.noHospitalsFound: 'لم يتم العثور على مستشفيات',
    LocalizationKeys.sortHospitals: 'ترتيب المستشفيات',
    LocalizationKeys.open24Hours: 'مفتوحة 24 ساعة',
    LocalizationKeys.nearestToYou: 'الأقرب إليك',
    LocalizationKeys.highestRated: 'الأعلى تقييماً',
    LocalizationKeys.reviews: 'تقييم',
    LocalizationKeys.distanceKmAway: '{distance} كم',
    LocalizationKeys.acceptsInsurance: 'يقبل تأمينك',
    LocalizationKeys.showDetails: 'عرض التفاصيل',
    LocalizationKeys.filter: 'فلترة',
    LocalizationKeys.applySorting: 'تطبيق الترتيب',
    LocalizationKeys.clearAll: 'مسح الكل',
    LocalizationKeys.showResults: 'عرض النتائج',
    LocalizationKeys.searchLocation: 'موقع البحث',
    LocalizationKeys.locationMethod: 'طريقة تحديد الموقع',
    LocalizationKeys.savedAddress: 'عنوان محفوظ',
    LocalizationKeys.selectArea: 'منطقة محددة',
    LocalizationKeys.chooseGovernorate: 'اختر المحافظة',
    LocalizationKeys.chooseArea: 'اختر المنطقة',
    LocalizationKeys.governorate: 'المحافظة',
    LocalizationKeys.area: 'المنطقة',
    LocalizationKeys.healthInsurance: 'التأمين الصحي',
    LocalizationKeys.chooseInsuranceCompany: 'اختر شركة التأمين',
    LocalizationKeys.noInsurance: 'بدون تأمين',
    LocalizationKeys.filterResults: 'فلترة النتائج',
    LocalizationKeys.chooseWhatSuitsYou: 'اختر ما يناسبك للحصول على نتائج أدق',
    LocalizationKeys.specialty: 'التخصص',
    LocalizationKeys.allSpecialties: 'كل التخصصات',
  };

  @override
  String translate(String key) {
    return _translations[key] ?? key;
  }
}

class _MockHospitalRepository implements BaseHospitalListRepository {
  bool shouldFail = false;

  @override
  Future<HospitalListsApiModelSuccessfulResponse> getHospitalListsApi(
      HospitalListSendModel sendModel) async {
    if (shouldFail) {
      throw Exception('Server error');
    }
    return const HospitalListsApiModelSuccessfulResponse(
      success: true,
      code: 'HOSPITALS_RETRIEVED',
      message: 'Hospitals retrieved successfully.',
      data: HospitalListsDataModel(
        items: [
          HospitalModel(
            id: 'hosp_1',
            name: 'مستشفى القاهرة التخصصي',
            ratingAverage: 5.0,
            totalReviews: 1,
            address: 'شارع 9، المعادي',
            distanceKm: 3.4,
            workingHoursStatus: 'مفتوحة حتى ١٠ مساءً',
            governorateId: 'gov_1',
            governorateName: 'القاهرة',
            areaId: 'area_1',
            areaName: 'المعادي',
            isFavorite: false,
            acceptsPatientInsurance: true,
            specialtiesCount: 2,
            specialtiesCountLabel: 'تخصصان',
          ),
        ],
        page: 1,
        pageSize: 20,
        totalCount: 1,
      ),
    );
  }

  @override
  Future<GovernoratesResponseModel> getGovernoratesApi() async {
    return const GovernoratesResponseModel(
      success: true,
      code: 'GOVERNORATES_RETRIEVED',
      message: 'Success',
      data: [],
    );
  }

  @override
  Future<InsuranceCompaniesResponseModel> getInsuranceCompaniesApi() async {
    return const InsuranceCompaniesResponseModel(
      success: true,
      code: 'INSURANCE_COMPANIES_RETRIEVED',
      message: 'Success',
      data: [],
    );
  }
}

class _MockSpecialtiesRepository implements BaseMedicalSpecialtiesRepository {
  @override
  Future<MedicalSpecialtiesResponseModel> getMedicalSpecialties() async {
    return MedicalSpecialtiesResponseModel(
      success: true,
      code: 'SPECIALTIES_RETRIEVED',
      message: 'Success',
      data: [
        MedicalSpecialtyModel(
          id: 'spec_1',
          nameAr: 'قلب وأوعية دموية',
          nameEn: 'Cardiology',
          descriptionAr: '',
          descriptionEn: '',
          imageUrl: '',
          displayOrder: 1,
        ),
      ],
    );
  }
}

void main() {
  group('HospitalModel Tests', () {
    const rawJson = '''
    {
      "id": "f1a0e002-6f7a-4890-b123-456789abe002",
      "name": "مستشفى القاهرة التخصصي",
      "ratingAverage": 5,
      "totalReviews": 1,
      "address": "شارع 9، المعادي",
      "distanceKm": 3.4,
      "workingHoursStatus": "مفتوحة حتى ١٠ مساءً",
      "governorateId": "e3c2f001-6f7a-4890-b123-456789abd001",
      "governorateName": "القاهرة",
      "areaId": "e3c2f012-6f7a-4890-b123-456789abd012",
      "areaName": "المعادي",
      "isFavorite": false,
      "acceptsPatientInsurance": true,
      "specialtiesCount": 2,
      "specialtiesCountLabel": "تخصصان",
      "logo_Url": "https://example.com/logo.png",
      "cover_url": "https://example.com/cover.png"
    }
    ''';

    test('parses fromJson and converts to toJson correctly', () {
      final jsonMap = jsonDecode(rawJson) as Map<String, dynamic>;
      final hospital = HospitalModel.fromJson(jsonMap);

      expect(hospital.id, 'f1a0e002-6f7a-4890-b123-456789abe002');
      expect(hospital.name, 'مستشفى القاهرة التخصصي');
      expect(hospital.ratingAverage, 5.0);
      expect(hospital.totalReviews, 1);
      expect(hospital.address, 'شارع 9، المعادي');
      expect(hospital.distanceKm, 3.4);
      expect(hospital.workingHoursStatus, 'مفتوحة حتى ١٠ مساءً');
      expect(hospital.governorateName, 'القاهرة');
      expect(hospital.areaName, 'المعادي');
      expect(hospital.isFavorite, false);
      expect(hospital.acceptsPatientInsurance, true);
      expect(hospital.specialtiesCount, 2);
      expect(hospital.specialtiesCountLabel, 'تخصصان');
      expect(hospital.logoUrl, 'https://example.com/logo.png');
      expect(hospital.coverUrl, 'https://example.com/cover.png');
      expect(hospital.formattedDistance, '3.4');
      expect(hospital.initials, 'ما');

      final serialized = hospital.toJson();
      expect(serialized['id'], hospital.id);
      expect(serialized['name'], hospital.name);
      expect(serialized['logo_Url'], hospital.logoUrl);
    });

    test('HospitalListsApiModelSuccessfulResponse parsing', () {
      const responseJson = '''
      {
        "success": true,
        "code": "HOSPITALS_RETRIEVED",
        "message": "Hospitals retrieved successfully.",
        "data": {
          "items": [
            {
              "id": "hosp_1",
              "name": "دار الشفاء",
              "ratingAverage": 4.5,
              "totalReviews": 2,
              "address": "شارع الطيران",
              "distanceKm": 0.8,
              "workingHoursStatus": "مفتوحة 24 ساعة",
              "governorateId": "gov_1",
              "governorateName": "القاهرة",
              "areaId": "area_1",
              "areaName": "مدينة نصر",
              "isFavorite": true,
              "acceptsPatientInsurance": false,
              "specialtiesCount": 8,
              "specialtiesCountLabel": "٨ تخصصات"
            }
          ],
          "page": 1,
          "pageSize": 20,
          "totalCount": 1
        }
      }
      ''';

      final jsonMap = jsonDecode(responseJson) as Map<String, dynamic>;
      final response = HospitalListsApiModelSuccessfulResponse.fromJson(jsonMap);

      expect(response.success, true);
      expect(response.data.items.length, 1);
      expect(response.data.items.first.name, 'دار الشفاء');
      expect(response.data.totalCount, 1);

      final uiResponse = HospitalListsUiResponse.fromApiModel(response);
      expect(uiResponse.hospitalList.length, 1);
      expect(uiResponse.metaUiModel.currentPage, 1);
      expect(uiResponse.metaUiModel.total, 1);
    });

    test('HospitalListSendModel serializes toMap correctly', () {
      final model = HospitalListSendModel(
        pagination: PagingListSendModel(pageNumber: 2, pageSize: 15, searchText: 'شفاء'),
        sortBy: 'nearest',
        governorateId: 'gov_1',
        areaId: 'area_2',
        insuranceCompanyId: 'ins_3',
      );

      final map = model.toMap();
      expect(map['page'], 2);
      expect(map['pageSize'], 15);
      expect(map['search'], 'شفاء');
      expect(map['sortBy'], 'nearest');
      expect(map['governorateId'], 'gov_1');
      expect(map['areaId'], 'area_2');
      expect(map['insuranceCompanyId'], 'ins_3');
    });

    test('HospitalFilterModel copyWith and active filters', () {
      const initial = HospitalFilterModel.initial;
      expect(initial.hasActiveFilters, false);
      expect(initial.activeFiltersCount, 0);

      final updated = initial.copyWith(
        governorate: 'القاهرة',
        governorateId: 'gov_1',
        insuranceCompanyId: 'ins_1',
      );
      expect(updated.hasActiveFilters, true);
      expect(updated.activeFiltersCount, 2);

      final cleared = updated.copyWith(clearGovernorate: true, clearInsurance: true);
      expect(cleared.hasActiveFilters, false);
    });
  });

  group('HospitalListsBloc Tests', () {
    late _MockHospitalRepository mockRepository;
    late GetHospitalListsUseCase useCase;
    late HospitalListsBloc bloc;

    setUp(() {
      mockRepository = _MockHospitalRepository();
      useCase = GetHospitalListsUseCase(mockRepository);
      bloc = HospitalListsBloc(getHospitalListsUseCase: useCase);
    });

    tearDown(() {
      bloc.close();
    });

    test('emits HospitalListsLoadedState when GetHospitalListsApiEvent succeeds',
        () async {
      final sendModel = HospitalListSendModel(
        pagination: PagingListSendModel(pageNumber: 1, pageSize: 10),
      );

      final states = <HospitalListsState>[];
      bloc.stream.listen(states.add);

      bloc.add(GetHospitalListsApiEvent(sendModel: sendModel));

      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0], isA<HospitalListLoadingState>());
      expect(states[1], isA<HospitalListsLoadedState>());

      final loadedState = states[1] as HospitalListsLoadedState;
      expect(loadedState.hospitalList.length, 1);
      expect(loadedState.hospitalList.first.name, 'مستشفى القاهرة التخصصي');
    });

    test('ToggleFavoriteHospitalEvent toggles favorite set correctly', () async {
      final sendModel = HospitalListSendModel(
        pagination: PagingListSendModel(pageNumber: 1, pageSize: 10),
      );

      bloc.add(GetHospitalListsApiEvent(sendModel: sendModel));
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(ToggleFavoriteHospitalEvent('hosp_1'));
      await Future.delayed(const Duration(milliseconds: 50));

      final state = bloc.state as HospitalListsLoadedState;
      expect(state.favoriteHospitalIds.contains('hosp_1'), true);

      bloc.add(ToggleFavoriteHospitalEvent('hosp_1'));
      await Future.delayed(const Duration(milliseconds: 50));

      final state2 = bloc.state as HospitalListsLoadedState;
      expect(state2.favoriteHospitalIds.contains('hosp_1'), false);
    });
  });

  group('Hospital UI Widgets Tests', () {
    Widget buildTestableWidget(Widget child) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, _) {
          return MaterialApp(
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              _FakeHospitalLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(body: child),
          );
        },
      );
    }

    testWidgets('HospitalCardWidget renders correctly', (tester) async {
      const hospital = HospitalModel(
        id: 'hosp_test',
        name: 'مستشفى دار الفؤاد',
        ratingAverage: 4.8,
        totalReviews: 12,
        address: 'مدينة 6 أكتوبر',
        distanceKm: 5.2,
        workingHoursStatus: 'مفتوحة 24 ساعة',
        governorateId: 'gov_giza',
        governorateName: 'الجيزة',
        areaId: 'area_october',
        areaName: '6 أكتوبر',
        isFavorite: false,
        acceptsPatientInsurance: true,
        specialtiesCount: 15,
        specialtiesCountLabel: '١٥ تخصص',
      );

      bool wasTapped = false;

      await tester.pumpWidget(buildTestableWidget(
        HospitalCardWidget(
          hospital: hospital,
          isFavorite: false,
          onTap: () => wasTapped = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('مستشفى دار الفؤاد'), findsOneWidget);
      expect(find.text('مفتوحة 24 ساعة'), findsOneWidget);
      expect(find.text('١٥ تخصص'), findsOneWidget);
      expect(find.text('يقبل تأمينك'), findsOneWidget);

      await tester.tap(find.text('مستشفى دار الفؤاد'));
      expect(wasTapped, true);
    });

    testWidgets('HospitalSortBottomSheetWidget selection', (tester) async {
      HospitalSortOption? selected;

      await tester.pumpWidget(buildTestableWidget(
        Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () {
              HospitalSortBottomSheetWidget.show(
                context: context,
                currentSort: HospitalSortOption.nearest,
                onApply: (sort) => selected = sort,
              );
            },
            child: const Text('Open Sort'),
          );
        }),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Sort'));
      await tester.pumpAndSettle();

      expect(find.text('ترتيب المستشفيات'), findsOneWidget);
      expect(find.text('الأقرب إليك'), findsOneWidget);
      expect(find.text('الأعلى تقييماً'), findsOneWidget);

      await tester.tap(find.text('الأعلى تقييماً'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('تطبيق الترتيب'));
      await tester.pumpAndSettle();

      expect(selected, HospitalSortOption.highestRated);
    });

    testWidgets('HospitalListFilterScreen renders medical specialties and selects one',
        (tester) async {
      final mockRepo = _MockHospitalRepository();
      final mockSpecUseCase =
          GetMedicalSpecialtiesUseCase(_MockSpecialtiesRepository());

      await tester.pumpWidget(buildTestableWidget(
        HospitalListFilterScreen(
          currentFilter: const HospitalFilterModel(),
          repository: mockRepo,
          getMedicalSpecialtiesUseCase: mockSpecUseCase,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('التخصص'), findsOneWidget);
      expect(find.text('كل التخصصات'), findsWidgets);
    });
  });
}
