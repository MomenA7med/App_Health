import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/pharmacy_details/data/models/pharmacy_branch_model.dart';
import 'package:app_health/features/pharmacy_details/data/models/pharmacy_profile_response_model.dart';
import 'package:app_health/features/pharmacy_details/domain/repositories/base_pharmacy_details_repository.dart';
import 'package:app_health/features/pharmacy_details/domain/usecases/get_pharmacy_profile_use_case.dart';
import 'package:app_health/features/pharmacy_details/presentation/bloc/pharmacy_details_bloc.dart';
import 'package:app_health/features/pharmacy_details/presentation/bloc/pharmacy_details_event.dart';
import 'package:app_health/features/pharmacy_details/presentation/bloc/pharmacy_details_state.dart';
import 'package:app_health/features/pharmacy_details/presentation/screens/pharmacy_details_screen.dart';
import 'package:app_health/features/pharmacy_details/presentation/widgets/pharmacy_about_tab_widget.dart';
import 'package:app_health/features/pharmacy_details/presentation/widgets/pharmacy_branches_tab_widget.dart';
import 'package:app_health/features/pharmacy_details/presentation/widgets/pharmacy_details_header_widget.dart';
import 'package:app_health/features/pharmacy_details/presentation/widgets/pharmacy_insurance_tab_widget.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakePharmacyDetailsLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakePharmacyDetailsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      _FakePharmacyDetailsLocalizations(locale);

  @override
  bool shouldReload(_FakePharmacyDetailsLocalizationsDelegate old) => false;
}

class _FakePharmacyDetailsLocalizations extends AppLocalizations {
  _FakePharmacyDetailsLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.reviews: 'تقييم',
    LocalizationKeys.distanceKmAway: '{distance} كم',
    LocalizationKeys.acceptsInsurance: 'تقبل تأمينك',
    LocalizationKeys.call: 'اتصال',
    LocalizationKeys.message: 'مراسلة',
    LocalizationKeys.aboutPharmacy: 'عن الصيدلية',
    LocalizationKeys.branches: 'العناوين',
    LocalizationKeys.insurance: 'التأمين',
    LocalizationKeys.acceptedInsuranceCompanies: 'شركات التأمين المقبولة',
    LocalizationKeys.noAcceptedInsurance: 'لا توجد شركات تأمين مضافة حالياً',
    LocalizationKeys.workingHours: 'مواعيد العمل',
    LocalizationKeys.saturdayToThursday: 'السبت – الخميس',
    LocalizationKeys.friday: 'الجمعة',
    LocalizationKeys.openNow: 'مفتوح الآن',
    LocalizationKeys.open24Hours: 'مفتوحة 24 ساعة',
    LocalizationKeys.sendPrescription: 'إرسال روشتة',
    LocalizationKeys.primaryBranch: 'الفرع الرئيسي',
    LocalizationKeys.noBranchesInPharmacy: 'لا توجد فروع مضافة حالياً',
    LocalizationKeys.retry: 'إعادة المحاولة',
  };

  @override
  String translate(String key) => _translations[key] ?? key;
}

class _MockPharmacyDetailsRepository implements BasePharmacyDetailsRepository {
  bool shouldFail = false;

  @override
  Future<PharmacyProfileResponseModel> getPharmacyProfile(
      String pharmacyId) async {
    if (shouldFail) {
      throw Exception('Server error');
    }

    return const PharmacyProfileResponseModel(
      success: true,
      code: 'PHARMACY_PROFILE_RETRIEVED',
      message: 'Pharmacy profile retrieved successfully.',
      data: PharmacyProfileModel(
        id: 'a7b0e002-6f7a-4890-b123-456789abf102',
        name: 'صيدلية سيف',
        branchName: 'فرع المعادي',
        ratingAverage: 5.0,
        totalReviews: 1,
        address: 'شارع 9، المعادي',
        distanceKm: 2.4,
        workingHoursStatus: 'مفتوح حتى ١١ مساءً',
        aboutText:
            'صيدلية سيف في المعادي توفر الأدوية اليومية ومنتجات العناية، وتستقبل الروشتات خلال مواعيد العمل.',
        governorateId: 'e3c2f001-6f7a-4890-b123-456789abd001',
        governorateName: 'القاهرة',
        areaId: 'e3c2f012-6f7a-4890-b123-456789abd012',
        areaName: 'المعادي',
        isFavorite: false,
        acceptsPatientInsurance: true,
        isOpenNow: true,
        branches: [
          PharmacyBranchModel(
            id: 'branch_1',
            branchName: 'فرع المعادي',
            address: 'شارع 9، المعادي',
            distanceKm: 2.4,
            workingHoursStatus: 'مفتوح حتى ١١ مساءً',
            isPrimary: true,
          ),
        ],
        acceptedInsuranceCompanies: [
          InsuranceCompanyModel(
            id: 'ins_1',
            nameAr: 'أكسا للتأمين',
            nameEn: 'AXA Insurance',
          ),
        ],
      ),
    );
  }
}

void main() {
  group('Pharmacy Details Models Tests', () {
    const rawJson = '''
    {
      "success": true,
      "code": "PHARMACY_PROFILE_RETRIEVED",
      "message": "Pharmacy profile retrieved successfully.",
      "data": {
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
        "aboutText": "صيدلية سيف في المعادي توفر الأدوية اليومية ومنتجات العناية.",
        "governorateId": "e3c2f001-6f7a-4890-b123-456789abd001",
        "governorateName": "القاهرة",
        "areaId": "e3c2f012-6f7a-4890-b123-456789abd012",
        "areaName": "المعادي",
        "isFavorite": false,
        "acceptsPatientInsurance": false,
        "coverUrl": null,
        "logoUrl": null,
        "branches": [
          {
            "id": "a7b0e002-6f7a-4890-b123-456789abf102",
            "branchName": "فرع المعادي",
            "address": "شارع 9، المعادي",
            "distanceKm": 2.4,
            "workingHoursStatus": "مفتوح حتى ١١ مساءً",
            "isTwentyFourHours": false,
            "isOpenNow": true,
            "governorateId": "e3c2f001-6f7a-4890-b123-456789abd001",
            "governorateName": "القاهرة",
            "areaId": "e3c2f012-6f7a-4890-b123-456789abd012",
            "areaName": "المعادي",
            "isPrimary": true
          }
        ],
        "acceptedInsuranceCompanies": [],
        "reviews": {
          "ratingAverage": 5,
          "totalReviews": 1,
          "breakdown": [
            { "rating": 5, "count": 1 }
          ],
          "items": [
            {
              "id": "a7b0e023-6f7a-4890-b123-456789abf123",
              "patientName": "ليلى سمير",
              "rating": 5,
              "comment": "استقبلوا الروشتة بسرعة.",
              "createdAt": "2026-03-01T00:00:00Z"
            }
          ],
          "page": 1,
          "pageSize": 20,
          "totalCount": 1
        }
      }
    }
    ''';

    test('PharmacyProfileResponseModel deserializes and serializes correctly', () {
      final jsonMap = jsonDecode(rawJson) as Map<String, dynamic>;
      final response = PharmacyProfileResponseModel.fromJson(jsonMap);

      expect(response.success, true);
      expect(response.code, 'PHARMACY_PROFILE_RETRIEVED');

      final pharmacy = response.data;
      expect(pharmacy.id, 'a7b0e002-6f7a-4890-b123-456789abf102');
      expect(pharmacy.name, 'صيدلية سيف');
      expect(pharmacy.branchName, 'فرع المعادي');
      expect(pharmacy.displayName, 'صيدلية سيف - فرع المعادي');
      expect(pharmacy.ratingAverage, 5.0);
      expect(pharmacy.totalReviews, 1);
      expect(pharmacy.formattedDistance, '2.4');
      expect(pharmacy.initials, 'صس');
      expect(pharmacy.branches.length, 1);
      expect(pharmacy.branches.first.branchName, 'فرع المعادي');
      expect(pharmacy.branches.first.isPrimary, true);
      expect(pharmacy.reviews?.totalCount, 1);

      final serialized = response.toJson();
      expect(serialized['success'], true);
      expect(serialized['data']['name'], 'صيدلية سيف');
    });

    test('PharmacyBranchModel getters and serialization', () {
      const branch = PharmacyBranchModel(
        id: 'b1',
        branchName: 'فرع مدينة نصر',
        address: 'شارع الطيران',
        distanceKm: 1.2,
        isPrimary: true,
      );

      expect(branch.formattedDistance, '1.2');
      final map = branch.toJson();
      expect(map['branchName'], 'فرع مدينة نصر');
      expect(map['isPrimary'], true);
    });
  });

  group('PharmacyDetailsBloc Tests', () {
    late _MockPharmacyDetailsRepository mockRepository;
    late GetPharmacyProfileUseCase useCase;
    late PharmacyDetailsBloc bloc;

    setUp(() {
      mockRepository = _MockPharmacyDetailsRepository();
      useCase = GetPharmacyProfileUseCase(mockRepository);
      bloc = PharmacyDetailsBloc(getPharmacyProfileUseCase: useCase);
    });

    tearDown(() {
      bloc.close();
    });

    test('emits loaded state when FetchPharmacyDetailsEvent succeeds', () async {
      final states = <PharmacyDetailsState>[];
      bloc.stream.listen(states.add);

      bloc.add(const FetchPharmacyDetailsEvent(pharmacyId: 'p1'));

      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0], isA<PharmacyDetailsLoadingState>());
      expect(states[1], isA<PharmacyDetailsLoadedState>());

      final loaded = states[1] as PharmacyDetailsLoadedState;
      expect(loaded.pharmacy.name, 'صيدلية سيف');
      expect(loaded.activeTab, 0);
    });

    test('emits error state when FetchPharmacyDetailsEvent fails', () async {
      mockRepository.shouldFail = true;

      final states = <PharmacyDetailsState>[];
      bloc.stream.listen(states.add);

      bloc.add(const FetchPharmacyDetailsEvent(pharmacyId: 'p1'));

      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0], isA<PharmacyDetailsLoadingState>());
      expect(states[1], isA<PharmacyDetailsErrorState>());
    });

    test('ChangePharmacyDetailsTabEvent changes active tab', () async {
      bloc.add(const FetchPharmacyDetailsEvent(pharmacyId: 'p1'));
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(const ChangePharmacyDetailsTabEvent(tabIndex: 1));
      await Future.delayed(const Duration(milliseconds: 50));

      final state = bloc.state as PharmacyDetailsLoadedState;
      expect(state.activeTab, 1);
    });

    test('TogglePharmacyFavoriteEvent toggles favorite state', () async {
      bloc.add(const FetchPharmacyDetailsEvent(pharmacyId: 'p1'));
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(const TogglePharmacyFavoriteEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      final state = bloc.state as PharmacyDetailsLoadedState;
      expect(state.isFavorite, true);
    });
  });

  group('Pharmacy Details Widgets Tests', () {
    Widget buildTestableWidget(Widget child, {bool isScreen = false}) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, _) {
          return MaterialApp(
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              _FakePharmacyDetailsLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: isScreen ? child : Scaffold(body: SingleChildScrollView(child: child)),
          );
        },
      );
    }

    const testPharmacy = PharmacyProfileModel(
      id: 'pharm_1',
      name: 'صيدليات العزبي',
      branchName: 'فرع مدينة نصر',
      ratingAverage: 4.9,
      totalReviews: 126,
      address: 'شارع الطيران',
      distanceKm: 1.2,
      workingHoursStatus: '٩ صباحًا – ١٢ منتصف الليل',
      aboutText: 'أرسل وصفتك الطبية لمعرفة التوافر والأسعار.',
      governorateName: 'القاهرة',
      areaName: 'مدينة نصر',
      acceptsPatientInsurance: true,
      isOpenNow: true,
      branches: [
        PharmacyBranchModel(
          id: 'b1',
          branchName: 'فرع مدينة نصر',
          address: 'شارع الطيران',
          distanceKm: 1.2,
          workingHoursStatus: 'مفتوح الآن',
          isPrimary: true,
        ),
      ],
      acceptedInsuranceCompanies: [
        InsuranceCompanyModel(
          id: 'i1',
          nameAr: 'أكسا',
          nameEn: 'AXA',
        ),
      ],
    );

    testWidgets('PharmacyDetailsHeaderWidget renders info and tabs',
        (tester) async {
      int selectedTab = 0;

      await tester.pumpWidget(
        buildTestableWidget(
          PharmacyDetailsHeaderWidget(
            pharmacy: testPharmacy,
            isFavorite: false,
            activeTab: 0,
            onBackTap: () {},
            onFavoriteTap: () {},
            onTabSelected: (tab) => selectedTab = tab,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('صيدليات العزبي - فرع مدينة نصر'), findsOneWidget);
      expect(find.text('4.9'), findsOneWidget);
      expect(find.text('تقبل تأمينك'), findsOneWidget);
      expect(find.text('مفتوح الآن'), findsOneWidget);
      expect(find.text('عن الصيدلية'), findsOneWidget);
      expect(find.text('العناوين'), findsOneWidget);
      expect(find.text('التأمين'), findsOneWidget);
      expect(find.text('اتصال'), findsOneWidget);
      expect(find.text('مراسلة'), findsOneWidget);

      await tester.tap(find.text('العناوين'));
      await tester.pumpAndSettle();
      expect(selectedTab, 1);
    });

    testWidgets('PharmacyAboutTabWidget renders schedule and about text',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const PharmacyAboutTabWidget(pharmacy: testPharmacy),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('عن الصيدلية'), findsOneWidget);
      expect(find.text('أرسل وصفتك الطبية لمعرفة التوافر والأسعار.'), findsOneWidget);
      expect(find.text('مواعيد العمل'), findsOneWidget);
      expect(find.text('السبت – الخميس'), findsOneWidget);
      expect(find.text('الجمعة'), findsOneWidget);
    });

    testWidgets('PharmacyBranchesTabWidget renders branch item',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          PharmacyBranchesTabWidget(branches: testPharmacy.branches),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('العناوين'), findsOneWidget);
      expect(find.text('فرع مدينة نصر'), findsOneWidget);
      expect(find.text('الفرع الرئيسي'), findsOneWidget);
      expect(find.textContaining('شارع الطيران'), findsOneWidget);
    });

    testWidgets('PharmacyInsuranceTabWidget renders insurance company',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          PharmacyInsuranceTabWidget(
            insuranceCompanies: testPharmacy.acceptedInsuranceCompanies,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('شركات التأمين المقبولة'), findsOneWidget);
      expect(find.text('أكسا'), findsOneWidget);
      expect(find.text('AXA'), findsOneWidget);
    });

    testWidgets('PharmacyDetailsScreen renders successfully', (tester) async {
      final mockRepo = _MockPharmacyDetailsRepository();

      await tester.pumpWidget(
        buildTestableWidget(
          PharmacyDetailsScreen(
            pharmacyId: 'pharm_1',
            repository: mockRepo,
          ),
          isScreen: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('صيدلية سيف - فرع المعادي'), findsOneWidget);
      expect(find.text('إرسال روشتة'), findsOneWidget);
    });
  });
}
