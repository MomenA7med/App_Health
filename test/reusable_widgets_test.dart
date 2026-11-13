import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';
import 'package:app_health/features/widgets/app_badge_widget.dart';
import 'package:app_health/features/widgets/app_favorite_button.dart';
import 'package:app_health/features/widgets/app_filter_dropdown_widget.dart';
import 'package:app_health/features/widgets/app_rating_widget.dart';
import 'package:app_health/features/widgets/app_search_bar_widget.dart';
import 'package:app_health/features/widgets/location_distance_widget.dart';
import 'package:app_health/features/widgets/location_filter_selector_widget.dart';
import 'package:app_health/features/widgets/medical_specialty_filter_dropdown_widget.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakeLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      _FakeLocalizations(locale);

  @override
  bool shouldReload(_FakeLocalizationsDelegate old) => false;
}

class _FakeLocalizations extends AppLocalizations {
  _FakeLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.reviews: 'تقييم',
    LocalizationKeys.distanceKmAway: '{distance} كم',
    LocalizationKeys.acceptsInsurance: 'يقبل تأمينك',
    LocalizationKeys.locationMethod: 'طريقة تحديد الموقع',
    LocalizationKeys.selectArea: 'تحديد المنطقة',
    LocalizationKeys.savedAddress: 'عنوان محفوظ',
    LocalizationKeys.governorate: 'المحافظة',
    LocalizationKeys.area: 'المنطقة',
    LocalizationKeys.chooseGovernorate: 'اختر المحافظة',
    LocalizationKeys.chooseArea: 'اختر المنطقة',
    LocalizationKeys.fromAddressesOrCurrentLocation:
        'العناوين المحفوظة أو الموقع الحالي',
    LocalizationKeys.specialty: 'التخصص',
    LocalizationKeys.allSpecialties: 'كل التخصصات',
  };

  @override
  String translate(String key) => _translations[key] ?? key;
}

void main() {
  Widget buildTestable(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) {
        return MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            _FakeLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(body: Center(child: child)),
        );
      },
    );
  }

  group('Reusable Widgets Tests', () {
    testWidgets('AppRatingWidget renders score and reviews', (tester) async {
      await tester.pumpWidget(buildTestable(
        const AppRatingWidget(
          ratingAverage: 4.8,
          totalReviews: 25,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('4.8'), findsOneWidget);
      expect(find.text('(25 تقييم)'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    });

    testWidgets('AppFavoriteButton toggles favorite icon and triggers onTap',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(buildTestable(
        AppFavoriteButton(
          isFavorite: false,
          onTap: () => tapped = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

      await tester.tap(find.byType(AppFavoriteButton));
      expect(tapped, true);

      // Now with isFavorite = true
      await tester.pumpWidget(buildTestable(
        AppFavoriteButton(
          isFavorite: true,
          onTap: () {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    });

    testWidgets('LocationDistanceWidget renders address and formatted distance',
        (tester) async {
      await tester.pumpWidget(buildTestable(
        const LocationDistanceWidget(
          address: 'شارع 9، المعادي',
          formattedDistance: '3.4',
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('شارع 9، المعادي · 3.4 كم'), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('AppBadgeWidget renders badges correctly', (tester) async {
      await tester.pumpWidget(buildTestable(
        Builder(builder: (context) {
          return Column(
            children: [
              AppBadgeWidget.insurance(context: context),
              AppBadgeWidget.workingHours(status: 'مفتوحة 24 ساعة'),
              const AppBadgeWidget(text: '12 تخصص'),
            ],
          );
        }),
      ));
      await tester.pumpAndSettle();

      expect(find.text('يقبل تأمينك'), findsOneWidget);
      expect(find.text('مفتوحة 24 ساعة'), findsOneWidget);
      expect(find.text('12 تخصص'), findsOneWidget);
    });

    testWidgets('AppSearchBarWidget handles text input and debounce',
        (tester) async {
      final controller = TextEditingController();
      String? changed;

      await tester.pumpWidget(buildTestable(
        AppSearchBarWidget(
          controller: controller,
          hintText: 'ابحث...',
          debounceDuration: const Duration(milliseconds: 50),
          onChanged: (val) => changed = val,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ابحث...'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'دكتور');
      await tester.pump(const Duration(milliseconds: 100));

      expect(changed, 'دكتور');
    });

    testWidgets('LocationFilterSelectorWidget renders tabs and switches mode',
        (tester) async {
      String currentMode = 'area';
      final governorates = [
        const GovernorateModel(
          id: 'gov-1',
          name: 'القاهرة',
          areas: [
            AreaModel(id: 'area-1', name: 'مدينة نصر', governorateId: 'gov-1'),
            AreaModel(id: 'area-2', name: 'المعادي', governorateId: 'gov-1'),
          ],
        ),
      ];

      await tester.pumpWidget(buildTestable(
        StatefulBuilder(
          builder: (context, setState) {
            return LocationFilterSelectorWidget(
              locationMode: currentMode,
              onLocationModeChanged: (mode) {
                setState(() {
                  currentMode = mode;
                });
              },
              governorates: governorates,
              selectedGovernorateId: 'gov-1',
              selectedGovernorateName: 'القاهرة',
              selectedAreaId: 'area-1',
              selectedAreaName: 'مدينة نصر',
              onGovernorateChanged: (id, name) {},
              onAreaChanged: (id, name) {},
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('طريقة تحديد الموقع'), findsOneWidget);
      expect(find.text('تحديد المنطقة'), findsOneWidget);
      expect(find.text('عنوان محفوظ'), findsOneWidget);
      expect(find.text('المحافظة'), findsOneWidget);
      expect(find.text('المنطقة'), findsOneWidget);
      expect(find.text('القاهرة'), findsOneWidget);
      expect(find.text('مدينة نصر'), findsOneWidget);

      // Switch to saved address mode
      await tester.tap(find.text('عنوان محفوظ'));
      await tester.pumpAndSettle();

      expect(currentMode, 'saved');
      expect(find.text('العناوين المحفوظة أو الموقع الحالي'), findsOneWidget);
    });

    testWidgets('AppFilterDropdownWidget renders title, hint and items',
        (tester) async {
      String? selectedVal;

      await tester.pumpWidget(buildTestable(
        StatefulBuilder(
          builder: (context, setState) {
            return AppFilterDropdownWidget<String>(
              title: 'التخصص',
              value: selectedVal,
              hintText: 'كل التخصصات',
              items: const [
                DropdownMenuItem(value: '1', child: Text('قلب')),
                DropdownMenuItem(value: '2', child: Text('باطنة')),
              ],
              onChanged: (val) {
                setState(() {
                  selectedVal = val;
                });
              },
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('التخصص'), findsOneWidget);
      expect(find.text('كل التخصصات'), findsOneWidget);
    });

    testWidgets('MedicalSpecialtyFilterDropdownWidget renders specialties correctly',
        (tester) async {
      String? selectedId;
      String? selectedName;

      final specialties = [
        MedicalSpecialtyModel(
          id: 'spec_1',
          nameAr: 'قلب وأوعية دموية',
          nameEn: 'Cardiology',
          descriptionAr: '',
          descriptionEn: '',
          imageUrl: '',
          displayOrder: 1,
        ),
      ];

      await tester.pumpWidget(buildTestable(
        StatefulBuilder(
          builder: (context, setState) {
            return MedicalSpecialtyFilterDropdownWidget(
              specialties: specialties,
              selectedSpecialtyId: selectedId,
              onSpecialtyChanged: (id, name) {
                setState(() {
                  selectedId = id;
                  selectedName = name;
                });
              },
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('التخصص'), findsOneWidget);
      expect(find.text('كل التخصصات'), findsWidgets);
    });
  });
}

