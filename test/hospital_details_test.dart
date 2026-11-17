import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/hospital_details/data/models/hospital_profile_response_model.dart';
import 'package:app_health/features/hospital_details/domain/repositories/base_hospital_details_repository.dart';
import 'package:app_health/features/hospital_details/domain/usecases/get_hospital_profile_use_case.dart';
import 'package:app_health/features/hospital_details/presentation/bloc/hospital_details_bloc.dart';
import 'package:app_health/features/hospital_details/presentation/bloc/hospital_details_event.dart';
import 'package:app_health/features/hospital_details/presentation/bloc/hospital_details_state.dart';
import 'package:app_health/features/hospital_details/presentation/screens/hospital_details_screen.dart';
import 'package:app_health/features/hospital_details/presentation/widgets/hospital_about_tab_widget.dart';
import 'package:app_health/features/hospital_details/presentation/widgets/hospital_details_header_widget.dart';
import 'package:app_health/features/hospital_details/presentation/widgets/hospital_insurance_tab_widget.dart';
import 'package:app_health/features/hospital_details/presentation/widgets/hospital_specialties_tab_widget.dart';
import 'package:app_health/features/widgets/app_capsule_tabs_widget.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakeHospitalDetailsLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakeHospitalDetailsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      _FakeHospitalDetailsLocalizations(locale);

  @override
  bool shouldReload(_FakeHospitalDetailsLocalizationsDelegate old) => false;
}

class _FakeHospitalDetailsLocalizations extends AppLocalizations {
  _FakeHospitalDetailsLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.reviews: 'تقييم',
    LocalizationKeys.distanceKmAway: '{distance} كم',
    LocalizationKeys.acceptsInsurance: 'يقبل تأمينك',
    LocalizationKeys.specialties: 'التخصصات',
    LocalizationKeys.call: 'اتصال',
    LocalizationKeys.message: 'مراسلة',
    LocalizationKeys.aboutHospital: 'عن المستشفى',
    LocalizationKeys.aboutTheHospital: 'نبذة عن المستشفى',
    LocalizationKeys.insurance: 'التأمين',
    LocalizationKeys.availableSpecialties: 'التخصصات المتاحة',
    LocalizationKeys.searchSpecialtyHint: 'ابحث عن تخصص',
    LocalizationKeys.noSpecialtiesFound: 'لا توجد تخصصات مطابقة للبحث',
    LocalizationKeys.acceptedInsuranceCompanies: 'شركات التأمين المقبولة',
    LocalizationKeys.noAcceptedInsurance: 'لا توجد شركات تأمين مضافة حالياً',
    LocalizationKeys.workingHours: 'مواعيد العمل',
    LocalizationKeys.receptionAndEmergency: 'الاستقبال والطوارئ:',
    LocalizationKeys.clinicsHoursVaryBySpecialty:
        'تختلف مواعيد العيادات حسب التخصص.',
    LocalizationKeys.servicesAndFacilities: 'الخدمات والمرافق',
    LocalizationKeys.available24Hours: 'متاح 24 ساعة',
    LocalizationKeys.retry: 'إعادة المحاولة',
  };

  @override
  String translate(String key) => _translations[key] ?? key;
}

class _MockHospitalDetailsRepository implements BaseHospitalDetailsRepository {
  bool shouldFail = false;

  @override
  Future<HospitalProfileResponseModel> getHospitalProfile(
      String hospitalId) async {
    if (shouldFail) {
      throw Exception('Server error');
    }

    return const HospitalProfileResponseModel(
      success: true,
      code: 'HOSPITAL_PROFILE_RETRIEVED',
      message: 'Hospital profile retrieved successfully.',
      data: HospitalProfileModel(
        id: 'f1a0e002-6f7a-4890-b123-456789abe002',
        name: 'مستشفى القاهرة التخصصي',
        ratingAverage: 5.0,
        totalReviews: 1,
        address: 'شارع 9، المعادي',
        distanceKm: 3.4,
        workingHoursStatus: 'مفتوحة حتى ١٠ مساءً',
        aboutText:
            'مستشفى القاهرة التخصصي في المعادي يركز على العيادات الخارجية والمعامل والأشعة ضمن مواعيد العمل اليومية.',
        governorateId: 'e3c2f001-6f7a-4890-b123-456789abd001',
        governorateName: 'القاهرة',
        areaId: 'e3c2f012-6f7a-4890-b123-456789abd012',
        areaName: 'المعادي',
        isFavorite: false,
        acceptsPatientInsurance: true,
        specialtiesCount: 2,
        specialtiesCountLabel: 'تخصصان',
        specialties: [
          HospitalSpecialtyItemModel(
            id: 'b4e2d3c5-6f7a-4890-b123-456789abcdef',
            nameAr: 'الباطنة',
            nameEn: 'Internal Medicine',
          ),
          HospitalSpecialtyItemModel(
            id: 'c5d3e4b6-7081-4901-c234-56789abcdef0',
            nameAr: 'العظام',
            nameEn: 'Orthopedics',
          ),
        ],
        services: [
          HospitalServiceItemModel(
            id: 'f1a0e211-6f7a-4890-b123-456789abe211',
            nameAr: 'العيادات الخارجية',
            nameEn: 'Outpatient clinics',
          ),
          HospitalServiceItemModel(
            id: 'f1a0e212-6f7a-4890-b123-456789abe212',
            nameAr: 'المعامل والأشعة',
            nameEn: 'Labs and imaging',
          ),
        ],
        acceptedInsuranceCompanies: [
          InsuranceCompanyModel(
            id: 'ins-1',
            nameAr: 'أكسا',
            nameEn: 'AXA',
          ),
        ],
      ),
    );
  }
}

void main() {
  const sampleJson = '''
  {
    "success": true,
    "code": "HOSPITAL_PROFILE_RETRIEVED",
    "message": "Hospital profile retrieved successfully.",
    "data": {
      "id": "f1a0e002-6f7a-4890-b123-456789abe002",
      "name": "مستشفى القاهرة التخصصي",
      "ratingAverage": 5,
      "totalReviews": 1,
      "address": "شارع 9، المعادي",
      "distanceKm": 3.4,
      "workingHoursStatus": "مفتوحة حتى ١٠ مساءً",
      "aboutText": "مستشفى القاهرة التخصصي في المعادي يركز على العيادات الخارجية والمعامل والأشعة ضمن مواعيد العمل اليومية.",
      "governorateId": "e3c2f001-6f7a-4890-b123-456789abd001",
      "governorateName": "القاهرة",
      "areaId": "e3c2f012-6f7a-4890-b123-456789abd012",
      "areaName": "المعادي",
      "isFavorite": false,
      "acceptsPatientInsurance": false,
      "specialties": [
        {
          "id": "b4e2d3c5-6f7a-4890-b123-456789abcdef",
          "nameAr": "الباطنة",
          "nameEn": "Internal Medicine"
        },
        {
          "id": "c5d3e4b6-7081-4901-c234-56789abcdef0",
          "nameAr": "العظام",
          "nameEn": "Orthopedics"
        }
      ],
      "services": [
        {
          "id": "f1a0e211-6f7a-4890-b123-456789abe211",
          "nameAr": "العيادات الخارجية",
          "nameEn": "Outpatient clinics"
        },
        {
          "id": "f1a0e212-6f7a-4890-b123-456789abe212",
          "nameAr": "المعامل والأشعة",
          "nameEn": "Labs and imaging"
        }
      ],
      "specialtiesCount": 2,
      "specialtiesCountLabel": "تخصصان",
      "acceptedInsuranceCompanies": [],
      "reviews": {
        "ratingAverage": 5,
        "totalReviews": 1,
        "breakdown": [
          {
            "rating": 5,
            "count": 1
          }
        ],
        "items": [
          {
            "id": "f1a0e103-6f7a-4890-b123-456789abe103",
            "patientName": "منى س.",
            "rating": 5,
            "comment": "طاقم لطيف وتنظيم واضح.",
            "createdAt": "2026-10-08T00:00:00Z"
          }
        ],
        "page": 1,
        "pageSize": 20,
        "totalCount": 1
      }
    }
  }
  ''';

  group('Hospital Profile Models Tests', () {
    test('parses json correctly and preserves fields', () {
      final jsonMap = jsonDecode(sampleJson) as Map<String, dynamic>;
      final response = HospitalProfileResponseModel.fromJson(jsonMap);

      expect(response.success, true);
      expect(response.code, 'HOSPITAL_PROFILE_RETRIEVED');

      final hospital = response.data;
      expect(hospital.id, 'f1a0e002-6f7a-4890-b123-456789abe002');
      expect(hospital.name, 'مستشفى القاهرة التخصصي');
      expect(hospital.ratingAverage, 5.0);
      expect(hospital.totalReviews, 1);
      expect(hospital.address, 'شارع 9، المعادي');
      expect(hospital.distanceKm, 3.4);
      expect(hospital.workingHoursStatus, 'مفتوحة حتى ١٠ مساءً');
      expect(hospital.specialties.length, 2);
      expect(hospital.specialties[0].nameAr, 'الباطنة');
      expect(hospital.services.length, 2);
      expect(hospital.services[0].nameAr, 'العيادات الخارجية');
      expect(hospital.reviews?.items.length, 1);
      expect(hospital.reviews?.items.first.patientName, 'منى س.');
      expect(hospital.formattedDistance, '3.4');
      expect(hospital.initials, 'ما');

      final serialized = response.toJson();
      expect(serialized['success'], true);
      expect(serialized['data']['name'], 'مستشفى القاهرة التخصصي');
    });
  });

  group('HospitalDetailsBloc Tests', () {
    test('emits loaded state when profile fetch succeeds', () async {
      final repo = _MockHospitalDetailsRepository();
      final useCase = GetHospitalProfileUseCase(repo);
      final bloc = HospitalDetailsBloc(getHospitalProfileUseCase: useCase);

      expect(bloc.state, isA<HospitalDetailsInitial>());

      bloc.add(const FetchHospitalDetailsEvent(hospitalId: 'hosp-1'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HospitalDetailsLoadingState>(),
          isA<HospitalDetailsLoadedState>().having(
            (s) => s.hospital.name,
            'hospital name',
            'مستشفى القاهرة التخصصي',
          ),
        ]),
      );

      // Change tab
      bloc.add(const ChangeHospitalDetailsTabEvent(tabIndex: 1));
      await expectLater(
        bloc.stream,
        emits(isA<HospitalDetailsLoadedState>().having(
          (s) => s.activeTab,
          'activeTab',
          1,
        )),
      );

      // Toggle favorite
      bloc.add(const ToggleHospitalFavoriteEvent());
      await expectLater(
        bloc.stream,
        emits(isA<HospitalDetailsLoadedState>().having(
          (s) => s.isFavorite,
          'isFavorite',
          true,
        )),
      );

      await bloc.close();
    });

    test('emits error state when profile fetch fails', () async {
      final repo = _MockHospitalDetailsRepository()..shouldFail = true;
      final useCase = GetHospitalProfileUseCase(repo);
      final bloc = HospitalDetailsBloc(getHospitalProfileUseCase: useCase);

      bloc.add(const FetchHospitalDetailsEvent(hospitalId: 'hosp-1'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HospitalDetailsLoadingState>(),
          isA<HospitalDetailsErrorState>(),
        ]),
      );

      await bloc.close();
    });
  });

  group('HospitalDetails Widgets Tests', () {
    Widget buildTestable(Widget child) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, _) {
          return MaterialApp(
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              _FakeHospitalDetailsLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(body: child),
          );
        },
      );
    }

    testWidgets('AppCapsuleTabsWidget renders and triggers onTabSelected',
        (tester) async {
      int selected = 0;

      await tester.pumpWidget(buildTestable(
        StatefulBuilder(
          builder: (context, setState) {
            return AppCapsuleTabsWidget(
              tabs: const ['التخصصات', 'التأمين', 'عن المستشفى'],
              selectedIndex: selected,
              onTabSelected: (idx) {
                setState(() {
                  selected = idx;
                });
              },
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('التخصصات'), findsOneWidget);
      expect(find.text('التأمين'), findsOneWidget);
      expect(find.text('عن المستشفى'), findsOneWidget);

      await tester.tap(find.text('التأمين'));
      await tester.pumpAndSettle();

      expect(selected, 1);
    });

    testWidgets('HospitalDetailsScreen renders successfully with all tabs',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repo = _MockHospitalDetailsRepository();

      await tester.pumpWidget(buildTestable(
        HospitalDetailsScreen(
          hospitalId: 'hosp-1',
          repository: repo,
        ),
      ));
      await tester.pumpAndSettle();

      // Verify Header Info
      expect(find.text('مستشفى القاهرة التخصصي'), findsOneWidget);
      expect(find.text('شارع 9، المعادي · 3.4 كم'), findsOneWidget);
      expect(find.text('مفتوحة حتى ١٠ مساءً'), findsOneWidget);
      expect(find.text('تخصصان'), findsOneWidget);
      expect(find.text('يقبل تأمينك'), findsOneWidget);
      expect(find.text('اتصال'), findsOneWidget);
      expect(find.text('مراسلة'), findsOneWidget);

      // Verify Specialties Tab Content (Default activeTab = 0)
      expect(find.text('التخصصات المتاحة'), findsOneWidget);
      expect(find.text('الباطنة'), findsOneWidget);
      expect(find.text('العظام'), findsOneWidget);

      // Switch to Insurance Tab (Tab 1)
      await tester.tap(find.text('التأمين'));
      await tester.pumpAndSettle();

      expect(find.text('شركات التأمين المقبولة'), findsOneWidget);
      expect(find.text('أكسا'), findsOneWidget);

      // Switch to About Hospital Tab (Tab 2)
      await tester.tap(find.text('عن المستشفى'));
      await tester.pumpAndSettle();

      expect(find.text('نبذة عن المستشفى'), findsOneWidget);
      expect(find.text('مواعيد العمل'), findsOneWidget);
      expect(find.text('الاستقبال والطوارئ:'), findsOneWidget);
      expect(find.text('الخدمات والمرافق'), findsOneWidget);
      expect(find.text('العيادات الخارجية'), findsOneWidget);
      expect(find.text('المعامل والأشعة'), findsOneWidget);
    });
  });
}
