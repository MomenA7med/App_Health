import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_about_tab_widget.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_booking_bottom_bar_widget.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_details_clinic_card_widget.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_details_header_widget.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_details_tabs_widget.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_reviews_tab_widget.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakeAppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakeAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return _FakeAppLocalizations(locale);
  }

  @override
  bool shouldReload(_FakeAppLocalizationsDelegate old) => false;
}

class _FakeAppLocalizations extends AppLocalizations {
  _FakeAppLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.aboutDoctor: 'عن الدكتور',
    LocalizationKeys.aboutTheDoctor: 'نبذة عن الدكتور',
    LocalizationKeys.qualificationsAndExperience: 'المؤهلات والخبرة',
    LocalizationKeys.clinicWorkingHours: 'مواعيد عمل العيادة',
    LocalizationKeys.callClinic: 'اتصال بالعيادة',
    LocalizationKeys.message: 'مراسلة',
    LocalizationKeys.patientReviews: 'آراء المرضى',
    LocalizationKeys.basedOnReviews: 'بناءً على {count} تقييم',
    LocalizationKeys.proceedToBooking: 'متابعة الحجز',
    LocalizationKeys.noReviewsFound: 'لا توجد تقييمات حتى الآن',
    LocalizationKeys.topRated: 'الأعلى تقييماً',
    LocalizationKeys.acceptsInsurance: 'يقبل تأمينك',
    LocalizationKeys.consultationFee: 'سعر الكشف',
    LocalizationKeys.currencyEgp: 'ج.م',
    LocalizationKeys.reviews: 'التقييمات',
  };

  @override
  String? translate(String key) => _translations[key] ?? key;
}

Widget wrapWithMaterial(Widget child, {Locale locale = const Locale('ar')}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, _) => MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        _FakeAppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('DoctorDetails Widgets Tests', () {
    final sampleDoctor = DoctorProfileModel(
      id: 'doc-1',
      specialtyId: 'spec-1',
      name: 'د. عمر أحمد',
      specializationTitle: 'استشاري الباطنة',
      ratingAverage: 4.9,
      totalReviews: 10,
      clinicName: 'المركز الطبي التخصصي',
      clinicAddress: 'شارع الطيران',
      cityLocation: 'مدينة نصر، القاهرة',
      distanceKm: 1.2,
      phoneNumber: '+201012345671',
      aboutText: 'استشاري الباطنة، متخصص في تشخيص ومتابعة الأمراض المزمنة.',
      qualifications: const [
        'دكتوراه أمراض الباطنة',
        '12 عاماً من الخبرة في طب الباطنة'
      ],
      workingHours: 'السبت إلى الخميس: من 3 إلى 9 مساءً',
      isFavorite: false,
      acceptsPatientInsurance: true,
    );

    final sampleReviews = DoctorReviewsDataModel(
      ratingAverage: 4.9,
      totalReviews: 10,
      breakdown: const [
        ReviewBreakdownModel(rating: 5, count: 9),
        ReviewBreakdownModel(rating: 4, count: 1),
      ],
      items: const [
        DoctorReviewModel(
          id: 'rev-1',
          patientName: 'أحمد م.',
          rating: 5,
          comment: 'الدكتور شرح الحالة بوضوح، والتعامل في العيادة كان منظم.',
          createdAt: '2026-10-24T12:00:00Z',
        ),
      ],
    );

    testWidgets('DoctorDetailsHeaderWidget renders doctor info and handles taps',
        (WidgetTester tester) async {
      bool favTapped = false;
      bool backTapped = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          DoctorDetailsHeaderWidget(
            doctor: sampleDoctor,
            isFavorite: false,
            onFavoriteTap: () => favTapped = true,
            onBackTap: () => backTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('د. عمر أحمد'), findsOneWidget);
      expect(find.text('استشاري الباطنة'), findsOneWidget);
      expect(find.textContaining('4.9'), findsOneWidget);

      // Tap favorite
      await tester.tap(find.byIcon(Icons.favorite_border_rounded));
      expect(favTapped, isTrue);

      // Tap back
      await tester.tap(find.byType(InkWell).first);
      expect(backTapped, isTrue);
    });

    testWidgets('DoctorDetailsClinicCardWidget renders badges and clinic details',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          DoctorDetailsClinicCardWidget(doctor: sampleDoctor),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الأعلى تقييماً'), findsOneWidget);
      expect(find.text('يقبل تأمينك'), findsOneWidget);
      expect(find.text('المركز الطبي التخصصي'), findsOneWidget);
      expect(find.text('اتصال بالعيادة'), findsOneWidget);
      expect(find.text('مراسلة'), findsOneWidget);
    });

    testWidgets('DoctorDetailsTabsWidget contains only 2 tabs',
        (WidgetTester tester) async {
      int activeTab = 0;

      await tester.pumpWidget(
        wrapWithMaterial(
          StatefulBuilder(
            builder: (context, setState) => DoctorDetailsTabsWidget(
              activeTab: activeTab,
              onTabChanged: (val) {
                setState(() => activeTab = val);
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('عن الدكتور'), findsOneWidget);
      expect(find.text('التقييمات'), findsOneWidget);
      // Ensure "الحجز" (booking) tab does NOT exist
      expect(find.text('الحجز'), findsNothing);

      // Tap reviews tab
      await tester.tap(find.text('التقييمات'));
      await tester.pumpAndSettle();

      expect(activeTab, 1);
    });

    testWidgets('DoctorAboutTabWidget renders about details and qualifications',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          SingleChildScrollView(
            child: DoctorAboutTabWidget(doctor: sampleDoctor),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('نبذة عن الدكتور'), findsOneWidget);
      expect(
        find.text('استشاري الباطنة، متخصص في تشخيص ومتابعة الأمراض المزمنة.'),
        findsOneWidget,
      );
      expect(find.text('المؤهلات والخبرة'), findsOneWidget);
      expect(find.text('دكتوراه أمراض الباطنة'), findsOneWidget);
      expect(find.text('12 عاماً من الخبرة في طب الباطنة'), findsOneWidget);
      expect(find.text('مواعيد عمل العيادة'), findsOneWidget);
      expect(
        find.text('السبت إلى الخميس: من 3 إلى 9 مساءً'),
        findsOneWidget,
      );
    });

    testWidgets('DoctorReviewsTabWidget renders rating summary and reviews',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          SingleChildScrollView(
            child: DoctorReviewsTabWidget(reviews: sampleReviews),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('4.9'), findsOneWidget);
      expect(find.text('بناءً على 10 تقييم'), findsOneWidget);
      expect(find.text('آراء المرضى'), findsOneWidget);
      expect(find.text('أحمد م.'), findsOneWidget);
      expect(
        find.text('الدكتور شرح الحالة بوضوح، والتعامل في العيادة كان منظم.'),
        findsOneWidget,
      );
    });

    testWidgets('DoctorBookingBottomBarWidget renders fee and proceed button',
        (WidgetTester tester) async {
      bool proceedTapped = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          DoctorBookingBottomBarWidget(
            consultationFee: 350,
            onProceedTap: () => proceedTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سعر الكشف'), findsOneWidget);
      expect(find.text('350'), findsOneWidget);
      expect(find.text('ج.م'), findsOneWidget);
      expect(find.text('متابعة الحجز'), findsOneWidget);

      await tester.tap(find.text('متابعة الحجز'));
      expect(proceedTapped, isTrue);
    });
  });
}
