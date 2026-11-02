import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';
import 'package:app_health/features/medical_specialties/presentation/widgets/medical_specialties_header_widget.dart';
import 'package:app_health/features/medical_specialties/presentation/widgets/medical_specialties_search_bar_widget.dart';
import 'package:app_health/features/medical_specialties/presentation/widgets/medical_specialty_card_widget.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakeAppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakeAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final loc = _FakeAppLocalizations(locale);
    return loc;
  }

  @override
  bool shouldReload(_FakeAppLocalizationsDelegate old) => false;
}

class _FakeAppLocalizations extends AppLocalizations {
  _FakeAppLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.medicalSpecialties: 'التخصصات',
    LocalizationKeys.chooseSpecialtyTitle: 'اختار التخصص المناسب',
    LocalizationKeys.chooseSpecialtySubtitle:
        'ابدأ بتخصصك، وشوف الدكاترة الأقرب ليك.',
    LocalizationKeys.searchSpecialtyHint: 'ابحث عن تخصص',
    LocalizationKeys.viewDoctors: 'عرض الأطباء',
    LocalizationKeys.noSpecialtiesFound: 'لا توجد تخصصات مطابقة للبحث',
    LocalizationKeys.retry: 'إعادة المحاولة',
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
  group('Medical Specialties Widgets Tests', () {
    testWidgets('MedicalSpecialtyCardWidget renders data correctly and responds to tap', (
      WidgetTester tester,
    ) async {
      bool tapped = false;
      final specialty = MedicalSpecialtyModel(
        id: '1',
        nameAr: 'الأسنان',
        nameEn: 'Dentistry',
        descriptionAr: 'تشخيص وعلاج أمراض الأسنان',
        descriptionEn: 'Dental care',
        imageUrl: '',
        displayOrder: 1,
      );

      await tester.pumpWidget(
        wrapWithMaterial(
          MedicalSpecialtyCardWidget(
            specialty: specialty,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الأسنان'), findsOneWidget);
      expect(find.text('عرض الأطباء'), findsOneWidget);

      await tester.tap(find.byType(MedicalSpecialtyCardWidget));
      expect(tapped, isTrue);
    });

    testWidgets('MedicalSpecialtiesHeaderWidget displays title and subtitle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithMaterial(const MedicalSpecialtiesHeaderWidget()),
      );
      await tester.pumpAndSettle();

      expect(find.text('اختار التخصص المناسب'), findsOneWidget);
      expect(
        find.text('ابدأ بتخصصك، وشوف الدكاترة الأقرب ليك.'),
        findsOneWidget,
      );
    });

    testWidgets('MedicalSpecialtiesSearchBarWidget handles text changes and clear', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      String changedText = '';
      bool cleared = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          MedicalSpecialtiesSearchBarWidget(
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

      expect(find.text('ابحث عن تخصص'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'أطفال');
      await tester.pumpAndSettle();

      expect(changedText, 'أطفال');
      expect(find.byIcon(Icons.close), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(cleared, isTrue);
    });
  });
}

