import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/features/doctor_list/presentation/widgets/doctor_card_widget.dart';
import 'package:app_health/features/doctor_list/presentation/widgets/doctor_search_bar_widget.dart';
import 'package:app_health/features/doctor_list/presentation/widgets/doctor_sort_bottom_sheet_widget.dart';
import 'package:app_health/features/widgets/pagination_widgets/paging_swipe_to_refresh_list_widget.dart';
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
    LocalizationKeys.doctors: 'الأطباء',
    LocalizationKeys.doctorsOf: 'أطباء',
    LocalizationKeys.doctorSingle: 'طبيب',
    LocalizationKeys.searchDoctorHint: 'ابحث باسم الطبيب',
    LocalizationKeys.filter: 'تصفية',
    LocalizationKeys.nearestToYou: 'الأقرب إليك',
    LocalizationKeys.highestRated: 'الأعلى تقييماً',
    LocalizationKeys.priceLowToHigh: 'السعر: من الأقل للأعلى',
    LocalizationKeys.priceHighToLow: 'السعر: من الأعلى للأقل',
    LocalizationKeys.reviews: 'تقييم',
    LocalizationKeys.distanceKmAway: 'على بُعد {distance} كم',
    LocalizationKeys.acceptsInsurance: 'يقبل تأمينك',
    LocalizationKeys.consultationFee: 'سعر الكشف',
    LocalizationKeys.currencyEgp: 'ج.م',
    LocalizationKeys.bookNow: 'احجز الآن',
    LocalizationKeys.sortDoctors: 'ترتيب الدكاترة',
    LocalizationKeys.applySorting: 'تطبيق الترتيب',
    LocalizationKeys.showDetails: 'عرض التفاصيل',
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
  group('Specialty Doctors Widgets Tests', () {
    final sampleDoctor = DoctorModel(
      id: 'doc-1',
      name: 'د. عمر أحمد',
      gender: 'Male',
      specializationTitle: 'استشاري الباطنة',
      ratingAverage: 4.9,
      totalReviews: 10,
      clinicName: 'المركز الطبي التخصصي',
      clinicAddress: 'شارع الطيران',
      cityLocation: 'مدينة نصر، القاهرة',
      area: 'مدينة نصر',
      distanceKm: 1.2,
      consultationFee: 350,
      nextAvailableSlot: 'اليوم، ٣:٣٠ مساءً',
      nextAvailableDate: '2026-11-01',
      imageUrl: null,
      acceptsPatientInsurance: true,
    );

    testWidgets('DoctorCardWidget renders doctor details and responds to actions', (
      WidgetTester tester,
    ) async {
      bool favTapped = false;
      bool bookTapped = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          DoctorCardWidget(
            doctor: sampleDoctor,
            isFavorite: false,
            onFavoriteTap: () {
              favTapped = true;
            },
            onBookTap: () {
              bookTapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('د. عمر أحمد'), findsOneWidget);
      expect(find.text('استشاري الباطنة'), findsOneWidget);
      expect(find.text('4.9'), findsOneWidget);
      expect(find.text('(10 تقييم)'), findsOneWidget);
      expect(find.text('المركز الطبي التخصصي'), findsOneWidget);
      expect(find.text('350'), findsOneWidget);
      expect(find.text('ج.م'), findsOneWidget);
      expect(find.text('اليوم، ٣:٣٠ مساءً'), findsOneWidget);
      expect(find.text('يقبل تأمينك'), findsOneWidget);
      expect(find.text('عرض التفاصيل'), findsOneWidget);
      expect(find.text('ع أ'), findsOneWidget); // Initials avatar

      // Tap favorite
      await tester.tap(find.byIcon(Icons.favorite_border_rounded));
      expect(favTapped, isTrue);

      // Tap book now / show details
      await tester.tap(find.text('عرض التفاصيل'));
      expect(bookTapped, isTrue);
    });

    testWidgets('DoctorSearchBarWidget text change and clear work as expected', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      String changedText = '';
      bool cleared = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          DoctorSearchBarWidget(
            controller: controller,
            onChanged: (val) {
              changedText = val;
            },
            onClear: () {
              controller.clear();
              cleared = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'عمر');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(changedText, 'عمر');
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(cleared, isTrue);
    });

    testWidgets('DoctorSearchBarWidget debounces user input by 500ms', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      int callCount = 0;
      String lastText = '';

      await tester.pumpWidget(
        wrapWithMaterial(
          DoctorSearchBarWidget(
            controller: controller,
            onChanged: (val) {
              callCount++;
              lastText = val;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'ع');
      await tester.pump(const Duration(milliseconds: 200));
      expect(callCount, 0);

      await tester.enterText(find.byType(TextField), 'عم');
      await tester.pump(const Duration(milliseconds: 200));
      expect(callCount, 0);

      await tester.enterText(find.byType(TextField), 'عمر');
      await tester.pump(const Duration(milliseconds: 200));
      expect(callCount, 0);

      await tester.pump(const Duration(milliseconds: 500));
      expect(callCount, 1);
      expect(lastText, 'عمر');
    });

    testWidgets('DoctorSortBottomSheetWidget renders sort options and applies selection', (
      WidgetTester tester,
    ) async {
      DoctorSortOption? appliedOption;

      await tester.pumpWidget(
        wrapWithMaterial(
          DoctorSortBottomSheetWidget(
            initialSort: DoctorSortOption.nearest,
            onApply: (sort) {
              appliedOption = sort;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ترتيب الدكاترة'), findsOneWidget);
      expect(find.text('الأقرب إليك'), findsOneWidget);
      expect(find.text('الأعلى تقييماً'), findsOneWidget);
      expect(find.text('السعر: من الأقل للأعلى'), findsOneWidget);
      expect(find.text('السعر: من الأعلى للأقل'), findsOneWidget);

      // Select highest rated
      await tester.tap(find.text('الأعلى تقييماً'));
      await tester.pumpAndSettle();

      // Tap Apply
      await tester.tap(find.text('تطبيق الترتيب'));
      await tester.pumpAndSettle();

      expect(appliedOption, DoctorSortOption.highestRated);
    });

    testWidgets('PagingSwipeToRefreshListWidget renders items correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          SizedBox(
            height: 600,
            child: PagingSwipeToRefreshListWidget(
              listLength: 1,
              showPagingLoader: false,
              itemClickable: false,
              swipedToRefresh: () {},
              reachedEndOfScroll: () {},
              itemWidget: (index) => DoctorCardWidget(doctor: sampleDoctor),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PagingSwipeToRefreshListWidget), findsOneWidget);
      expect(find.text('د. عمر أحمد'), findsOneWidget);
    });
  });
}

