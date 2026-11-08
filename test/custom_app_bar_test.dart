import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/core/presentation/widgets/custom_app_bar.dart';

Widget wrapWithMaterial(Widget child, {TextDirection textDirection = TextDirection.rtl}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, _) => MaterialApp(
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          appBar: child is PreferredSizeWidget ? child : null,
          body: child is! PreferredSizeWidget ? child : const SizedBox.shrink(),
        ),
      ),
    ),
  );
}

void main() {
  group('CustomAppBar Tests', () {
    testWidgets('renders screenTitle and back button when showLocation is false', (
      WidgetTester tester,
    ) async {
      bool backTapped = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          CustomAppBar(
            screenTitle: 'تصفية النتائج',
            showLocation: false,
            onBackTap: () {
              backTapped = true;
            },
          ),
        ),
      );

      // Verify title is rendered
      expect(find.text('تصفية النتائج'), findsOneWidget);

      // Verify location widget is NOT rendered
      expect(find.byType(SvgPicture), findsNothing);

      // Tap back button
      final backButton = find.byType(InkWell).first;
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(backTapped, isTrue);
    });

    testWidgets('renders location pill and back button when showLocation is true', (
      WidgetTester tester,
    ) async {
      bool locationTapped = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          CustomAppBar(
            showLocation: true,
            locationText: 'مدينة نصر، القاهرة',
            onLocationTap: () {
              locationTapped = true;
            },
          ),
        ),
      );

      // Verify location elements are rendered
      expect(find.text('مدينة نصر، القاهرة'), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

      // Tap location pill
      final locationInkWell = find.ancestor(
        of: find.text('مدينة نصر، القاهرة'),
        matching: find.byType(InkWell),
      );
      await tester.tap(locationInkWell);
      await tester.pumpAndSettle();

      expect(locationTapped, isTrue);
    });
  });
}
