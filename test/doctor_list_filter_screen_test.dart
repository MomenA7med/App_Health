import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_list_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_lists_api_model_successful_response.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/doctor_list/domain/repositories/base_doctor_list_repository.dart';
import 'package:app_health/features/doctor_list/presentation/screens/doctor_list_filter_screen.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakeFilterLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakeFilterLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return _FakeFilterLocalizations(locale);
  }

  @override
  bool shouldReload(_FakeFilterLocalizationsDelegate old) => false;
}

class _FakeFilterLocalizations extends AppLocalizations {
  _FakeFilterLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.filterResults: 'تصفية النتائج',
    LocalizationKeys.chooseWhatSuitsYou: 'اختار اللي يناسبك',
    LocalizationKeys.clearAll: 'مسح الكل',
    LocalizationKeys.searchLocation: 'موقع البحث',
    LocalizationKeys.locationMethod: 'طريقة تحديد الموقع',
    LocalizationKeys.savedAddress: 'عنوان محفوظ',
    LocalizationKeys.selectArea: 'تحديد المنطقة',
    LocalizationKeys.noInsurance: 'بدون تأمين',
    LocalizationKeys.governorate: 'المحافظة',
    LocalizationKeys.area: 'المنطقة',
    LocalizationKeys.chooseAddress: 'اختيار عنوان',
    LocalizationKeys.fromAddressesOrCurrentLocation:
        'من عناوينك أو موقعك الحالي',
    LocalizationKeys.choose: 'اختيار',
    LocalizationKeys.doctorGender: 'نوع الطبيب',
    LocalizationKeys.all: 'الكل',
    LocalizationKeys.maleDoctor: 'طبيب',
    LocalizationKeys.femaleDoctor: 'طبيبة',
    LocalizationKeys.consultationDate: 'تاريخ الكشف',
    LocalizationKeys.anyDay: 'أي يوم',
    LocalizationKeys.today: 'اليوم',
    LocalizationKeys.tomorrow: 'غداً',
    LocalizationKeys.healthInsurance: 'التأمين الصحي',
    LocalizationKeys.chooseInsuranceCompany: 'اختر شركة التأمين',
    LocalizationKeys.showResults: 'عرض النتائج',
    LocalizationKeys.fromPrice: 'من {price} ج.م',
    LocalizationKeys.toPrice: 'إلى {price} ج.م',
    LocalizationKeys.currencyEgp: 'ج.م',
  };

  @override
  String? translate(String key) => _translations[key] ?? key;
}

class _MockDoctorListRepository implements BaseDoctorListRepository {
  @override
  Future<DoctorListsApiModelSuccessfulResponse> getDoctorListsApi(
      DoctorListSendModel sendModel) async {
    throw UnimplementedError();
  }

  @override
  Future<GovernoratesResponseModel> getGovernoratesApi() async {
    return const GovernoratesResponseModel(
      success: true,
      code: 'GOVERNORATES_RETRIEVED',
      message: 'Governorates retrieved successfully.',
      data: [
        GovernorateModel(
          id: 'e3c2f002-6f7a-4890-b123-456789abd002',
          name: 'الجيزة',
          areas: [
            AreaModel(
              id: 'e3c2f013-6f7a-4890-b123-456789abd013',
              governorateId: 'e3c2f002-6f7a-4890-b123-456789abd002',
              name: 'المهندسين',
            ),
          ],
        ),
        GovernorateModel(
          id: 'e3c2f001-6f7a-4890-b123-456789abd001',
          name: 'القاهرة',
          areas: [
            AreaModel(
              id: 'e3c2f012-6f7a-4890-b123-456789abd012',
              governorateId: 'e3c2f001-6f7a-4890-b123-456789abd001',
              name: 'المعادي',
            ),
            AreaModel(
              id: 'e3c2f011-6f7a-4890-b123-456789abd011',
              governorateId: 'e3c2f001-6f7a-4890-b123-456789abd001',
              name: 'مدينة نصر',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<InsuranceCompaniesResponseModel> getInsuranceCompaniesApi() async {
    return const InsuranceCompaniesResponseModel(
      success: true,
      code: 'INSURANCE_COMPANIES_RETRIEVED',
      message: 'Insurance companies retrieved successfully.',
      data: [
        InsuranceCompanyModel(
          id: '79799fc6-a987-47f2-95f9-8d03fbb767c8',
          nameAr: 'Company1',
          nameEn: 'شركه ١',
        ),
      ],
    );
  }
}

Widget wrapWithMaterial(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        _FakeFilterLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ),
  );
}

void main() {
  testWidgets('DoctorListFilterScreen renders with Figma components and applies filter',
      (tester) async {
    tester.view.physicalSize = const Size(375 * 3, 812 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    DoctorFilterModel? appliedFilter;

    await tester.pumpWidget(
      wrapWithMaterial(
        DoctorListFilterScreen(
          currentFilter: DoctorFilterModel.initial,
          repository: _MockDoctorListRepository(),
          onApply: (filter) {
            appliedFilter = filter;
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title & Header
    expect(find.text('تصفية النتائج'), findsOneWidget);
    expect(find.text('اختار اللي يناسبك'), findsOneWidget);
    expect(find.text('مسح الكل'), findsOneWidget);

    // Verify Location Mode Tabs
    expect(find.text('تحديد المنطقة'), findsOneWidget);
    expect(find.text('عنوان محفوظ'), findsOneWidget);

    // Verify Gender choices
    expect(find.text('الكل'), findsWidgets);
    expect(find.text('طبيب'), findsOneWidget);
    expect(find.text('طبيبة'), findsOneWidget);

    // Verify Date choices
    expect(find.text('أي يوم'), findsOneWidget);
    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('غداً'), findsOneWidget);

    // Verify Apply button
    expect(find.text('عرض النتائج'), findsOneWidget);

    // Tap on 'عنوان محفوظ' tab
    await tester.tap(find.text('عنوان محفوظ'));
    await tester.pumpAndSettle();

    // Check saved address card appears
    expect(find.text('اختيار عنوان'), findsOneWidget);

    // Tap back on 'تحديد المنطقة'
    await tester.tap(find.text('تحديد المنطقة'));
    await tester.pumpAndSettle();

    // Select Male doctor
    await tester.tap(find.text('طبيب'));
    await tester.pumpAndSettle();

    // Scroll until 'اليوم' is visible and tap
    await tester.scrollUntilVisible(
      find.text('اليوم'),
      50,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('اليوم'));
    await tester.pumpAndSettle();

    // Tap Show Results
    await tester.tap(find.text('عرض النتائج'));
    await tester.pumpAndSettle();

    expect(appliedFilter, isNotNull);
    expect(appliedFilter!.gender, 1);
    expect(appliedFilter!.consultationDate, 'today');
    expect(appliedFilter!.locationMode, 'area');
    expect(appliedFilter!.governorate, isNull);
    expect(appliedFilter!.area, isNull);
    expect(appliedFilter!.minPrice, 0);
    expect(appliedFilter!.maxPrice, 1000);
  });

  testWidgets('Clear all resets filters to defaults (null location & 0-1000 price)',
      (tester) async {
    tester.view.physicalSize = const Size(375 * 3, 812 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    DoctorFilterModel? appliedFilter;

    await tester.pumpWidget(
      wrapWithMaterial(
        DoctorListFilterScreen(
          currentFilter: const DoctorFilterModel(
            governorate: 'الجيزة',
            governorateId: 'e3c2f002-6f7a-4890-b123-456789abd002',
            area: 'المهندسين',
            areaId: 'e3c2f013-6f7a-4890-b123-456789abd013',
            gender: 2,
            minPrice: 300,
            maxPrice: 700,
            consultationDate: 'tomorrow',
            locationMode: 'saved',
          ),
          repository: _MockDoctorListRepository(),
          onApply: (filter) {
            appliedFilter = filter;
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap Clear All ("مسح الكل")
    await tester.tap(find.text('مسح الكل'));
    await tester.pumpAndSettle();

    // Tap Apply
    await tester.tap(find.text('عرض النتائج'));
    await tester.pumpAndSettle();

    expect(appliedFilter, isNotNull);
    expect(appliedFilter!.gender, 0);
    expect(appliedFilter!.consultationDate, 'any');
    expect(appliedFilter!.locationMode, 'area');
    expect(appliedFilter!.governorate, isNull);
    expect(appliedFilter!.governorateId, isNull);
    expect(appliedFilter!.area, isNull);
    expect(appliedFilter!.areaId, isNull);
    expect(appliedFilter!.minPrice, 0);
    expect(appliedFilter!.maxPrice, 1000);
  });

  testWidgets('Restores previously selected governorate and area when reopening',
      (tester) async {
    tester.view.physicalSize = const Size(375 * 3, 812 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    DoctorFilterModel? appliedFilter;

    await tester.pumpWidget(
      wrapWithMaterial(
        DoctorListFilterScreen(
          currentFilter: const DoctorFilterModel(
            governorate: 'الجيزة',
            governorateId: 'e3c2f002-6f7a-4890-b123-456789abd002',
            area: 'المهندسين',
            areaId: 'e3c2f013-6f7a-4890-b123-456789abd013',
            gender: 1,
            minPrice: 0,
            maxPrice: 1000,
            locationMode: 'area',
          ),
          repository: _MockDoctorListRepository(),
          onApply: (filter) {
            appliedFilter = filter;
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap Apply without changing location
    await tester.tap(find.text('عرض النتائج'));
    await tester.pumpAndSettle();

    expect(appliedFilter, isNotNull);
    expect(appliedFilter!.governorate, 'الجيزة');
    expect(appliedFilter!.governorateId, 'e3c2f002-6f7a-4890-b123-456789abd002');
    expect(appliedFilter!.area, 'المهندسين');
    expect(appliedFilter!.areaId, 'e3c2f013-6f7a-4890-b123-456789abd013');
  });

  testWidgets('Selecting an insurance company from dropdown updates filter',
      (tester) async {
    tester.view.physicalSize = const Size(375 * 3, 812 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    DoctorFilterModel? appliedFilter;

    await tester.pumpWidget(
      wrapWithMaterial(
        DoctorListFilterScreen(
          currentFilter: DoctorFilterModel.initial,
          repository: _MockDoctorListRepository(),
          onApply: (filter) {
            appliedFilter = filter;
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Drag so the insurance dropdown is comfortably in view
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -200));
    await tester.pumpAndSettle();

    final insuranceDropdown = find.byType(DropdownButton<String?>);
    expect(insuranceDropdown, findsOneWidget);

    // Tap dropdown to open it
    await tester.tap(insuranceDropdown);
    await tester.pumpAndSettle();

    // Tap on Company1 in the dropdown items
    await tester.tap(find.text('Company1').last);
    await tester.pumpAndSettle();

    // Tap Apply
    await tester.tap(find.text('عرض النتائج'));
    await tester.pumpAndSettle();

    expect(appliedFilter, isNotNull);
    expect(appliedFilter!.insuranceCompany, 'Company1');
    expect(appliedFilter!.insuranceCompanyId,
        '79799fc6-a987-47f2-95f9-8d03fbb767c8');
  });
}
