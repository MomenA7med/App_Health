import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_filter_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_lists_api_model_successful_response.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';
import 'package:app_health/features/pharmacies_list/domain/entities/pharmacy_lists_ui_response.dart';
import 'package:app_health/features/pharmacies_list/domain/repositories/base_pharmacies_list_repository.dart';
import 'package:app_health/features/pharmacies_list/domain/usecases/get_pharmacies_list_use_case.dart';
import 'package:app_health/features/pharmacies_list/presentation/bloc/pharmacies_list_bloc.dart';
import 'package:app_health/features/pharmacies_list/presentation/bloc/pharmacies_list_event.dart';
import 'package:app_health/features/pharmacies_list/presentation/bloc/pharmacies_list_state.dart';
import 'package:app_health/features/pharmacies_list/presentation/screens/pharmacies_list_filter_screen.dart';
import 'package:app_health/features/pharmacies_list/presentation/widgets/pharmacy_card_widget.dart';
import 'package:app_health/features/pharmacies_list/presentation/widgets/pharmacy_sort_bottom_sheet_widget.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakePharmacyLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakePharmacyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return _FakePharmacyLocalizations(locale);
  }

  @override
  bool shouldReload(_FakePharmacyLocalizationsDelegate old) => false;
}

class _FakePharmacyLocalizations extends AppLocalizations {
  _FakePharmacyLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.pharmacies: 'الصيدليات',
    LocalizationKeys.searchPharmacies: 'ابحث عن صيدلية...',
    LocalizationKeys.noPharmaciesFound: 'لم يتم العثور على صيدليات',
    LocalizationKeys.sortPharmacies: 'ترتيب الصيدليات',
    LocalizationKeys.openNow: 'مفتوح الآن',
    LocalizationKeys.allWorkingHours: 'جميع المواعيد',
    LocalizationKeys.twentyFourHoursOnly: '٢٤ ساعة فقط',
    LocalizationKeys.pharmacyWorkingHours: 'مواعيد عمل الصيدلية',
    LocalizationKeys.open24Hours: 'مفتوحة 24 ساعة',
    LocalizationKeys.nearestToYou: 'الأقرب إليك',
    LocalizationKeys.highestRated: 'الأعلى تقييماً',
    LocalizationKeys.reviews: 'تقييم',
    LocalizationKeys.distanceKmAway: '{distance} كم',
    LocalizationKeys.acceptsInsurance: 'يقبل تأمينك',
    LocalizationKeys.filter: 'فلترة',
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
  };

  @override
  String translate(String key) {
    return _translations[key] ?? key;
  }
}

class _MockPharmaciesRepository implements BasePharmaciesListRepository {
  bool shouldFail = false;

  @override
  Future<PharmacyListsApiModelSuccessfulResponse> getPharmaciesListsApi(
    PharmacyListSendModel sendModel,
  ) async {
    if (shouldFail) {
      throw Exception('Server error');
    }
    return const PharmacyListsApiModelSuccessfulResponse(
      success: true,
      code: 'PHARMACIES_RETRIEVED',
      message: 'Pharmacies retrieved successfully.',
      data: PharmacyListsDataModel(
        items: [
          PharmacyModel(
            id: 'a7b0e002-6f7a-4890-b123-456789abf102',
            name: 'صيدلية سيف',
            branchName: 'فرع المعادي',
            ratingAverage: 5.0,
            totalReviews: 1,
            address: 'شارع 9، المعادي',
            distanceKm: 2.4,
            workingHoursStatus: 'مفتوح حتى ١١ مساءً',
            isTwentyFourHours: false,
            isOpenNow: true,
            governorateId: 'e3c2f001-6f7a-4890-b123-456789abd001',
            governorateName: 'القاهرة',
            areaId: 'e3c2f012-6f7a-4890-b123-456789abd012',
            areaName: 'المعادي',
            isFavorite: false,
            acceptsPatientInsurance: true,
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

void main() {
  group('PharmacyModel Tests', () {
    const rawJson = '''
    {
      "id": "a7b0e002-6f7a-4890-b123-456789abf102",
      "name": "صيدلية سيف",
      "branchName": "فرع المعادي",
      "ratingAverage": 5,
      "totalReviews": 1,
      "address": "شارع 9، المعادي",
      "distanceKm": 2.4,
      "workingHoursStatus": "مفتوح حتى ١١ مساءً",
      "isTwentyFourHours": false,
      "isOpenNow": true,
      "governorateId": "e3c2f001-6f7a-4890-b123-456789abd001",
      "governorateName": "القاهرة",
      "areaId": "e3c2f012-6f7a-4890-b123-456789abd012",
      "areaName": "المعادي",
      "isFavorite": false,
      "acceptsPatientInsurance": false,
      "coverUrl": null,
      "logoUrl": null
    }
    ''';

    test('parses fromJson and converts to toJson correctly', () {
      final jsonMap = jsonDecode(rawJson) as Map<String, dynamic>;
      final pharmacy = PharmacyModel.fromJson(jsonMap);

      expect(pharmacy.id, 'a7b0e002-6f7a-4890-b123-456789abf102');
      expect(pharmacy.name, 'صيدلية سيف');
      expect(pharmacy.branchName, 'فرع المعادي');
      expect(pharmacy.displayName, 'صيدلية سيف - فرع المعادي');
      expect(pharmacy.ratingAverage, 5.0);
      expect(pharmacy.totalReviews, 1);
      expect(pharmacy.address, 'شارع 9، المعادي');
      expect(pharmacy.distanceKm, 2.4);
      expect(pharmacy.workingHoursStatus, 'مفتوح حتى ١١ مساءً');
      expect(pharmacy.isTwentyFourHours, false);
      expect(pharmacy.isOpenNow, true);
      expect(pharmacy.governorateName, 'القاهرة');
      expect(pharmacy.areaName, 'المعادي');
      expect(pharmacy.isFavorite, false);
      expect(pharmacy.acceptsPatientInsurance, false);
      expect(pharmacy.formattedDistance, '2.4');
      expect(pharmacy.initials, 'صس');

      final serialized = pharmacy.toJson();
      expect(serialized['id'], pharmacy.id);
      expect(serialized['name'], pharmacy.name);
      expect(serialized['branchName'], pharmacy.branchName);
      expect(serialized['isOpenNow'], true);
    });

    test('PharmacyListsApiModelSuccessfulResponse parsing', () {
      const responseJson = '''
      {
        "success": true,
        "code": "PHARMACIES_RETRIEVED",
        "message": "Pharmacies retrieved successfully.",
        "data": {
          "items": [
            {
              "id": "a7b0e001-6f7a-4890-b123-456789abf101",
              "name": "صيدليات العزبي",
              "branchName": "فرع مدينة نصر",
              "ratingAverage": 4.5,
              "totalReviews": 2,
              "address": "شارع الطيران، مدينة نصر",
              "distanceKm": 0.6,
              "workingHoursStatus": "٢٤ ساعة",
              "isTwentyFourHours": true,
              "isOpenNow": true,
              "governorateId": "e3c2f001-6f7a-4890-b123-456789abd001",
              "governorateName": "القاهرة",
              "areaId": "e3c2f011-6f7a-4890-b123-456789abd011",
              "areaName": "مدينة نصر",
              "isFavorite": false,
              "acceptsPatientInsurance": false,
              "coverUrl": null,
              "logoUrl": null
            }
          ],
          "page": 1,
          "pageSize": 20,
          "totalCount": 1
        }
      }
      ''';

      final jsonMap = jsonDecode(responseJson) as Map<String, dynamic>;
      final response =
          PharmacyListsApiModelSuccessfulResponse.fromJson(jsonMap);

      expect(response.success, true);
      expect(response.data.items.length, 1);
      expect(response.data.items.first.name, 'صيدليات العزبي');
      expect(response.data.items.first.isTwentyFourHours, true);
      expect(response.data.totalCount, 1);

      final uiResponse = PharmacyListsUiResponse.fromApiModel(response);
      expect(uiResponse.pharmacyList.length, 1);
      expect(uiResponse.metaUiModel.currentPage, 1);
      expect(uiResponse.metaUiModel.total, 1);
    });

    test('PharmacyListSendModel serializes toMap correctly', () {
      final model = PharmacyListSendModel(
        pagination: PagingListSendModel(
          pageNumber: 1,
          pageSize: 10,
          searchText: 'سيف',
        ),
        sortBy: 'nearest',
        locationStrategy: 0,
        governorateId: 'gov_1',
        areaId: 'area_2',
        workingHoursFilter: 2,
        insuranceCompanyId: 'ins_3',
      );

      final map = model.toMap();
      expect(map['page'], 1);
      expect(map['pageSize'], 10);
      expect(map['search'], 'سيف');
      expect(map['sortBy'], 1);
      expect(map['locationStrategy'], 0);
      expect(map['governorateId'], 'gov_1');
      expect(map['areaId'], 'area_2');
      expect(map['workingHoursFilter'], 2);
      expect(map['insuranceCompanyId'], 'ins_3');
    });

    test('PharmacyFilterModel copyWith and active filters', () {
      const initial = PharmacyFilterModel.initial;
      expect(initial.hasActiveFilters, false);
      expect(initial.activeFiltersCount, 0);

      final updated = initial.copyWith(
        governorate: 'القاهرة',
        governorateId: 'gov_1',
        workingHoursFilter: 1,
        insuranceCompanyId: 'ins_1',
      );
      expect(updated.hasActiveFilters, true);
      expect(updated.activeFiltersCount, 3);

      final cleared = updated.copyWith(
        clearGovernorate: true,
        clearWorkingHours: true,
        clearInsurance: true,
      );
      expect(cleared.hasActiveFilters, false);
    });
  });

  group('PharmaciesListsBloc Tests', () {
    late _MockPharmaciesRepository mockRepository;
    late GetPharmaciesListUseCase useCase;
    late PharmaciesListsBloc bloc;

    setUp(() {
      mockRepository = _MockPharmaciesRepository();
      useCase = GetPharmaciesListUseCase(mockRepository);
      bloc = PharmaciesListsBloc(getPharmaciesListUseCase: useCase);
    });

    tearDown(() {
      bloc.close();
    });

    test('emits PharmaciesListsLoadedState when GetPharmaciesListsApiEvent succeeds',
        () async {
      final sendModel = PharmacyListSendModel(
        pagination: PagingListSendModel(pageNumber: 1, pageSize: 10),
      );

      final states = <PharmaciesListsState>[];
      bloc.stream.listen(states.add);

      bloc.add(GetPharmaciesListsApiEvent(sendModel: sendModel));

      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0], isA<PharmacyListLoadingState>());
      expect(states[1], isA<PharmaciesListsLoadedState>());

      final loadedState = states[1] as PharmaciesListsLoadedState;
      expect(loadedState.pharmacyList.length, 1);
      expect(loadedState.pharmacyList.first.name, 'صيدلية سيف');
    });

    test('ToggleFavoritePharmacyEvent toggles favorite set correctly', () async {
      final sendModel = PharmacyListSendModel(
        pagination: PagingListSendModel(pageNumber: 1, pageSize: 10),
      );

      bloc.add(GetPharmaciesListsApiEvent(sendModel: sendModel));
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(ToggleFavoritePharmacyEvent('pharm_1'));
      await Future.delayed(const Duration(milliseconds: 50));

      final state = bloc.state as PharmaciesListsLoadedState;
      expect(state.favoritePharmacyIds.contains('pharm_1'), true);

      bloc.add(ToggleFavoritePharmacyEvent('pharm_1'));
      await Future.delayed(const Duration(milliseconds: 50));

      final state2 = bloc.state as PharmaciesListsLoadedState;
      expect(state2.favoritePharmacyIds.contains('pharm_1'), false);
    });
  });

  group('Pharmacy UI Widgets Tests', () {
    Widget buildTestableWidget(Widget child) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, _) {
          return MaterialApp(
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              _FakePharmacyLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(body: child),
          );
        },
      );
    }

    testWidgets('PharmacyCardWidget renders correctly', (tester) async {
      const pharmacy = PharmacyModel(
        id: 'pharm_test',
        name: 'صيدلية رشدي',
        branchName: 'فرع الدقي',
        ratingAverage: 4.8,
        totalReviews: 12,
        address: 'شارع مصدق، الدقي',
        distanceKm: 1.5,
        workingHoursStatus: '٢٤ ساعة',
        isTwentyFourHours: true,
        isOpenNow: true,
        governorateId: 'gov_giza',
        governorateName: 'الجيزة',
        areaId: 'area_dokki',
        areaName: 'الدقي',
        isFavorite: false,
        acceptsPatientInsurance: true,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const PharmacyCardWidget(pharmacy: pharmacy),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('صيدلية رشدي'), findsOneWidget);
      expect(find.text('فرع الدقي'), findsOneWidget);
      expect(find.textContaining('شارع مصدق، الدقي'), findsOneWidget);
      expect(find.textContaining('1.5'), findsOneWidget);
      expect(find.text('يقبل تأمينك'), findsOneWidget);
      expect(find.text('٢٤ ساعة'), findsOneWidget);
    });

    testWidgets('PharmacySortBottomSheetWidget renders and selects option',
        (tester) async {
      PharmacySortOption? selected;

      await tester.pumpWidget(
        buildTestableWidget(
          PharmacySortBottomSheetWidget(
            initialSort: PharmacySortOption.highestRated,
            onApply: (sort) {
              selected = sort;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ترتيب الصيدليات'), findsOneWidget);
      expect(find.text('الأعلى تقييماً'), findsOneWidget);
      expect(find.text('الأقرب إليك'), findsOneWidget);

      await tester.tap(find.text('الأقرب إليك'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('عرض النتائج'));
      await tester.pumpAndSettle();

      expect(selected, PharmacySortOption.nearest);
    });

    testWidgets('PharmaciesListFilterScreen renders sections correctly',
        (tester) async {
      final mockRepo = _MockPharmaciesRepository();

      await tester.pumpWidget(
        buildTestableWidget(
          PharmaciesListFilterScreen(
            currentFilter: PharmacyFilterModel.initial,
            repository: mockRepo,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('فلترة النتائج'), findsOneWidget);
      expect(find.text('مواعيد عمل الصيدلية'), findsOneWidget);
      expect(find.text('جميع المواعيد'), findsOneWidget);
      expect(find.text('مفتوح الآن'), findsOneWidget);
      expect(find.text('٢٤ ساعة فقط'), findsOneWidget);
      expect(find.text('التأمين الصحي'), findsOneWidget);
      expect(find.text('عرض النتائج'), findsOneWidget);
    });
  });
}
