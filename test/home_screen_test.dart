import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/home/presentation/screens/home_screen.dart';
import 'package:app_health/features/home/presentation/widgets/home_category_card_widget.dart';
import 'package:app_health/features/home/presentation/widgets/home_header_widget.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakeHomeLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakeHomeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return _FakeHomeLocalizations(locale);
  }

  @override
  bool shouldReload(_FakeHomeLocalizationsDelegate old) => false;
}

class _FakeHomeLocalizations extends AppLocalizations {
  _FakeHomeLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.home: 'الرئيسية',
    LocalizationKeys.welcomeBack: 'مرحباً بك',
    LocalizationKeys.healthServices: 'الخدمات الطبية',
    LocalizationKeys.howCanWeHelp: 'كيف يمكننا مساعدتك اليوم؟',
    LocalizationKeys.medicalSpecialties: 'التخصصات',
    LocalizationKeys.medicalSpecialtiesDesc:
        'احجز مع نخبة من الأطباء في كافة التخصصات الطبية',
    LocalizationKeys.hospitals: 'المستشفيات',
    LocalizationKeys.hospitalsDesc:
        'ابحث عن أقرب المستشفيات والمراكز الطبية المعتمدة',
    LocalizationKeys.pharmacies: 'الصيدليات',
    LocalizationKeys.pharmaciesDesc:
        'اطلب أدويتك وأرسل الروشتة لأقرب صيدلية بسهولة',
    LocalizationKeys.doctors: 'أطباء',
    LocalizationKeys.logout: 'تسجيل الخروج',
  };

  @override
  String translate(String key) => _translations[key] ?? key;
}

Widget wrapWithMaterial(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        _FakeHomeLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('Home Feature Tests', () {
    testWidgets('HomeCategoryCardWidget renders info and responds to tap',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          HomeCategoryCardWidget(
            title: 'التخصصات الطبية',
            description: 'احجز مع نخبة من الأطباء',
            badge: 'أطباء',
            icon: const Icon(Icons.medical_services_rounded),
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('التخصصات الطبية'), findsOneWidget);
      expect(find.text('احجز مع نخبة من الأطباء'), findsOneWidget);
      expect(find.text('أطباء'), findsOneWidget);
      expect(find.byIcon(Icons.medical_services_rounded), findsOneWidget);

      await tester.tap(find.text('التخصصات الطبية'));
      expect(tapped, isTrue);
    });

    testWidgets('HomeHeaderWidget renders greeting and triggers logout tap',
        (tester) async {
      bool logoutTapped = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          HomeHeaderWidget(
            onLogoutTap: () => logoutTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('مرحباً بك'), findsOneWidget);
      expect(find.text('كيف يمكننا مساعدتك اليوم؟'), findsWidgets);
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.logout_rounded));
      expect(logoutTapped, isTrue);
    });

    testWidgets('HomeScreen renders header and all 3 categories',
        (tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Check header
      expect(find.byType(HomeHeaderWidget), findsOneWidget);

      // Check 3 category cards exist
      expect(find.byType(HomeCategoryCardWidget), findsNWidgets(3));

      // Category 1: Medical Specialties
      expect(find.text('التخصصات'), findsOneWidget);
      expect(
        find.text('احجز مع نخبة من الأطباء في كافة التخصصات الطبية'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.medical_services_rounded), findsOneWidget);

      // Category 2: Hospitals
      expect(find.text('المستشفيات'), findsWidgets);
      expect(
        find.text('ابحث عن أقرب المستشفيات والمراكز الطبية المعتمدة'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.apartment_rounded), findsOneWidget);

      // Category 3: Pharmacies
      expect(find.text('الصيدليات'), findsWidgets);
      expect(
        find.text('اطلب أدويتك وأرسل الروشتة لأقرب صيدلية بسهولة'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.medication_rounded), findsOneWidget);
    });
  });
}

