import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_lists_api_model_successful_response.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_response_model.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_send_model.dart';
import 'package:app_health/features/send_prescription/domain/repositories/base_send_prescription_repository.dart';
import 'package:app_health/features/send_prescription/domain/usecases/get_prescription_governorates_use_case.dart';
import 'package:app_health/features/send_prescription/domain/usecases/get_prescription_pharmacies_use_case.dart';
import 'package:app_health/features/send_prescription/domain/usecases/get_prescription_saved_addresses_use_case.dart';
import 'package:app_health/features/send_prescription/domain/usecases/send_prescription_use_case.dart';
import 'package:app_health/features/send_prescription/presentation/bloc/send_prescription_bloc.dart';
import 'package:app_health/features/send_prescription/presentation/bloc/send_prescription_event.dart';
import 'package:app_health/features/send_prescription/presentation/bloc/send_prescription_state.dart';
import 'package:app_health/features/send_prescription/presentation/screens/capture_prescription_screen.dart';
import 'package:app_health/features/send_prescription/presentation/screens/prescription_sent_screen.dart';
import 'package:app_health/features/send_prescription/presentation/screens/review_prescription_screen.dart';
import 'package:app_health/features/send_prescription/presentation/widgets/prescription_attachment_card_widget.dart';
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
    LocalizationKeys.capturePrescription: 'تصوير الوصفة الطبية',
    LocalizationKeys.prescriptionCaptureHint:
        'ضع الوصفة الطبية كاملةً وبوضوح داخل الإطار',
    LocalizationKeys.takePrescriptionPhoto: 'التقاط صورة الوصفة',
    LocalizationKeys.continueWithoutPrescription: 'المتابعة دون وصفة طبية',
    LocalizationKeys.reviewPrescription: 'مراجعة الوصفة الطبية',
    LocalizationKeys.ensurePrescriptionClarity:
        'تأكد من وضوح تفاصيل الوصفة الطبية',
    LocalizationKeys.attachedPrescription: 'الوصفة الطبية المرفقة',
    LocalizationKeys.oneImageAttached: 'صورة واحدة مرفقة',
    LocalizationKeys.twoImagesAttached: 'صورتان مرفقتان',
    LocalizationKeys.imagesAttachedCount: '{count} صور مرفقة',
    LocalizationKeys.readyToSend: 'جاهزة للإرسال',
    LocalizationKeys.retakePhoto: 'إعادة التصوير',
    LocalizationKeys.addPhoto: 'إضافة صورة',
    LocalizationKeys.continueAction: 'متابعة',
    LocalizationKeys.orderDetailsTitle: 'تفاصيل الطلب',
    LocalizationKeys.locationStrategyTitle: 'طريقة تحديد الموقع',
    LocalizationKeys.savedAddress: 'عنوان محفوظ',
    LocalizationKeys.selectArea: 'تحديد المنطقة',
    LocalizationKeys.sendTo: 'إرسال إلى',
    LocalizationKeys.sendPrescription: 'إرسال روشتة',
    LocalizationKeys.sendToTwoPharmacies: 'إرسال إلى صيدليتين',
    LocalizationKeys.sendToPharmacies: 'إرسال إلى {count} صيدليات',
    LocalizationKeys.sendOrder: 'إرسال الطلب',
    LocalizationKeys.orderSentSuccessfully: 'تم إرسال طلبك بنجاح',
    LocalizationKeys.waitingPharmaciesResponse:
        'في انتظار رد الصيدليات بتوافر المطلوب والأسعار.',
    LocalizationKeys.sentToTwoPharmaciesSummary: 'تم الإرسال إلى صيدليتين',
    LocalizationKeys.sentToOnePharmacySummary: 'تم الإرسال إلى صيدلية واحدة',
    LocalizationKeys.sentToPharmaciesSummary:
        'تم الإرسال إلى {count} صيدليات',
    LocalizationKeys.waitingForReply: 'في انتظار الرد',
    LocalizationKeys.orderNumberLabel: 'رقم الطلب',
    LocalizationKeys.backToPharmacies: 'العودة للصيدليات',
  };

  @override
  String translate(String key) => _translations[key] ?? key;
}

class _MockSendPrescriptionRepository
    implements BaseSendPrescriptionRepository {
  bool shouldFail = false;

  final List<GovernorateModel> mockGovernorates = const [
    GovernorateModel(
      id: 'gov_1',
      name: 'القاهرة',
      areas: [
        AreaModel(
          id: 'area_1',
          governorateId: 'gov_1',
          name: 'مدينة نصر',
        ),
        AreaModel(
          id: 'area_2',
          governorateId: 'gov_1',
          name: 'المعادي',
        ),
      ],
    ),
  ];

  final List<UserAddressModel> mockAddresses = const [
    UserAddressModel(
      id: 'addr_1',
      addressName: 'المنزل',
      governorate: 'القاهرة',
      area: 'مدينة نصر',
      detailedAddress: 'شارع الطيران',
      isCurrentLocation: false,
    ),
  ];

  final List<PharmacyModel> mockPharmacies = const [
    PharmacyModel(
      id: 'pharm_1',
      name: 'صيدليات العزبي',
      branchName: 'فرع مدينة نصر',
      ratingAverage: 4.9,
      totalReviews: 126,
      address: 'شارع الطيران',
      distanceKm: 1.2,
      workingHoursStatus: '٢٤ ساعة',
      isTwentyFourHours: true,
      isOpenNow: true,
      governorateId: 'gov_1',
      governorateName: 'القاهرة',
      areaId: 'area_1',
      areaName: 'مدينة نصر',
    ),
    PharmacyModel(
      id: 'pharm_2',
      name: 'صيدلية سيف',
      branchName: 'فرع المعادي',
      ratingAverage: 4.8,
      totalReviews: 45,
      address: 'شارع 9',
      distanceKm: 2.5,
      workingHoursStatus: 'مفتوح الآن',
      isOpenNow: true,
      governorateId: 'gov_1',
      governorateName: 'القاهرة',
      areaId: 'area_2',
      areaName: 'المعادي',
    ),
  ];

  @override
  Future<SendPrescriptionResponseModel> sendPrescription(
    SendPrescriptionSendModel sendModel,
  ) async {
    if (shouldFail) {
      throw Exception('Server error');
    }

    return const SendPrescriptionResponseModel(
      success: true,
      code: 'PRESCRIPTION_ORDER_SENT',
      message: 'Prescription sent. The selected pharmacies have it as pending.',
      data: PrescriptionOrderModel(
        id: 'order_123',
        orderNumber: 'RX-41178',
        imageName: 'prescription.png',
        locationStrategy: 1,
        savedAddressId: 'addr_1',
        createdAt: '2026-11-18T09:41:35Z',
        pharmacies: [
          PrescriptionOrderPharmacyModel(
            pharmacyId: 'pharm_1',
            name: 'صيدليات العزبي',
            branchName: 'فرع مدينة نصر',
            status: 'Pending',
          ),
        ],
      ),
    );
  }

  @override
  Future<List<GovernorateModel>> getGovernorates() async => mockGovernorates;

  @override
  Future<List<UserAddressModel>> getUserAddresses() async => mockAddresses;

  @override
  Future<PharmacyListsApiModelSuccessfulResponse> getPharmacies(
    PharmacyListSendModel sendModel,
  ) async {
    return PharmacyListsApiModelSuccessfulResponse(
      success: true,
      code: 'PHARMACIES_RETRIEVED',
      message: 'Success',
      data: PharmacyListsDataModel(
        items: mockPharmacies,
        page: 1,
        pageSize: 20,
        totalCount: mockPharmacies.length,
      ),
    );
  }
}

void main() {
  group('SendPrescription Models Tests', () {
    test('SendPrescriptionSendModel toFormData creates expected fields', () async {
      final model = SendPrescriptionSendModel(
        locationStrategy: 1,
        savedAddressId: 'addr_123',
        pharmacyIds: ['p1', 'p2'],
        orderDetails: 'Need Panadol',
        imageBytes: [1, 2, 3],
        imageName: 'rx.jpg',
      );

      final formData = await model.toFormData();
      expect(formData.fields.any((f) => f.key == 'LocationStrategy' && f.value == '1'), isTrue);
      expect(formData.fields.any((f) => f.key == 'SavedAddressId' && f.value == 'addr_123'), isTrue);
      expect(formData.fields.any((f) => f.key == 'OrderDetails' && f.value == 'Need Panadol'), isTrue);
      expect(formData.fields.where((f) => f.key == 'PharmacyIds').length, 2);
      expect(formData.files.any((f) => f.key == 'PrescriptionImages'), isTrue);
    });

    test('SendPrescriptionSendModel with multiple images adds multiple PrescriptionImages files', () async {
      final model = SendPrescriptionSendModel(
        locationStrategy: 0,
        governorateId: 'gov_1',
        areaId: 'area_1',
        prescriptionImagesBytes: [
          [1, 2, 3],
          [4, 5, 6],
        ],
        prescriptionImagesNames: ['rx1.jpg', 'rx2.jpg'],
      );

      final formData = await model.toFormData();
      expect(formData.fields.any((f) => f.key == 'LocationStrategy' && f.value == '0'), isTrue);
      expect(formData.fields.any((f) => f.key == 'GovernorateId' && f.value == 'gov_1'), isTrue);
      expect(formData.fields.any((f) => f.key == 'AreaId' && f.value == 'area_1'), isTrue);
      final prescriptionFiles = formData.files.where((f) => f.key == 'PrescriptionImages').toList();
      expect(prescriptionFiles.length, 2);
      expect(prescriptionFiles[0].value.filename, 'rx1.jpg');
      expect(prescriptionFiles[1].value.filename, 'rx2.jpg');
    });

    test('SendPrescriptionResponseModel serialization', () {
      final json = {
        'success': true,
        'code': 'PRESCRIPTION_ORDER_SENT',
        'message': 'Success',
        'data': {
          'id': '74afe27d',
          'orderNumber': 'RX-41178',
          'locationStrategy': 1,
          'pharmacies': [
            {
              'pharmacyId': 'p1',
              'name': 'العزبي',
              'branchName': 'مدينة نصر',
              'status': 'Pending',
            }
          ]
        }
      };

      final response = SendPrescriptionResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.data.orderNumber, 'RX-41178');
      expect(response.data.pharmacies.length, 1);
      expect(response.data.pharmacies.first.displayName, 'العزبي - مدينة نصر');

      final serialized = response.toJson();
      expect(serialized['data']['orderNumber'], 'RX-41178');
    });
  });

  group('SendPrescriptionBloc Tests', () {
    late _MockSendPrescriptionRepository repo;
    late SendPrescriptionBloc bloc;

    setUp(() {
      repo = _MockSendPrescriptionRepository();
      bloc = SendPrescriptionBloc(
        sendPrescriptionUseCase: SendPrescriptionUseCase(repo),
        getGovernoratesUseCase: GetPrescriptionGovernoratesUseCase(repo),
        getPharmaciesUseCase: GetPrescriptionPharmaciesUseCase(repo),
        getSavedAddressesUseCase: GetPrescriptionSavedAddressesUseCase(repo),
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('InitSendPrescriptionEvent loads lookups and handles preselected pharmacy', () async {
      final states = <SendPrescriptionState>[];
      bloc.stream.listen(states.add);

      bloc.add(const InitSendPrescriptionEvent(
        imagePath: '/tmp/rx.jpg',
        preselectedPharmacyId: 'pharm_1',
      ));

      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.isNotEmpty, isTrue);
      final last = states.last;
      expect(last.status, SendPrescriptionStatus.loaded);
      expect(last.governorates.length, 1);
      expect(last.savedAddresses.length, 1);
      expect(last.availablePharmacies.length, 2);
      expect(last.selectedPharmacies.length, 1);
      expect(last.selectedPharmacies.first.id, 'pharm_1');
      expect(last.canSubmit, isTrue);
    });

    test('ToggleSelectPharmacyEvent and RemovePharmacyEvent modify selected pharmacies', () async {
      bloc.add(const ToggleSelectPharmacyEvent(
        PharmacyModel(
          id: 'p1',
          name: 'Pharm 1',
          governorateId: 'gov_1',
          governorateName: 'القاهرة',
          areaId: 'area_1',
          areaName: 'مدينة نصر',
        ),
      ));
      await Future.delayed(const Duration(milliseconds: 30));

      expect(bloc.state.selectedPharmacies.length, 1);

      bloc.add(const RemovePharmacyEvent('p1'));
      await Future.delayed(const Duration(milliseconds: 30));

      expect(bloc.state.selectedPharmacies.isEmpty, isTrue);
    });

    test('SubmitPrescriptionOrderEvent success flow', () async {
      final states = <SendPrescriptionState>[];
      bloc.stream.listen(states.add);

      bloc.add(const InitSendPrescriptionEvent(
        preselectedPharmacyId: 'pharm_1',
      ));
      await Future.delayed(const Duration(milliseconds: 50));

      bloc.add(const SubmitPrescriptionOrderEvent());
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.any((s) => s.status == SendPrescriptionStatus.submitting), isTrue);
      expect(states.any((s) => s.status == SendPrescriptionStatus.success), isTrue);
      expect(bloc.state.submittedOrder?.orderNumber, 'RX-41178');
    });

    test('SubmitPrescriptionOrderEvent fails when error occurs', () async {
      repo.shouldFail = true;
      bloc.add(const InitSendPrescriptionEvent(
        preselectedPharmacyId: 'pharm_1',
      ));
      await Future.delayed(const Duration(milliseconds: 50));

      bloc.add(const SubmitPrescriptionOrderEvent());
      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.state.status, SendPrescriptionStatus.error);
    });
  });

  group('SendPrescription Widgets Tests', () {
    Widget buildTestableWidget(Widget child) {
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
            home: child,
          );
        },
      );
    }

    testWidgets('CapturePrescriptionScreen renders title and hints', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const CapturePrescriptionScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('تصوير الوصفة الطبية'), findsOneWidget);
      expect(find.text('ضع الوصفة الطبية كاملةً وبوضوح داخل الإطار'), findsOneWidget);
      expect(find.text('المتابعة دون وصفة طبية'), findsOneWidget);
    });

    testWidgets('ReviewPrescriptionScreen renders clarity message and buttons', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ReviewPrescriptionScreen(imagePath: 'demo.png'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('مراجعة الوصفة الطبية'), findsOneWidget);
      expect(find.text('تأكد من وضوح تفاصيل الوصفة الطبية'), findsOneWidget);
      expect(find.text('صورة واحدة مرفقة'), findsOneWidget);
      expect(find.text('إعادة التصوير'), findsOneWidget);
      expect(find.text('إضافة صورة'), findsOneWidget);
      expect(find.text('متابعة'), findsOneWidget);
    });

    testWidgets('ReviewPrescriptionScreen renders plural text for 3 attached images', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const ReviewPrescriptionScreen(
            imagePath: 'demo1.png',
            imagePaths: ['demo1.png', 'demo2.png', 'demo3.png'],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3 صور مرفقة'), findsOneWidget);
    });

    testWidgets('PrescriptionAttachmentCardWidget triggers remove', (tester) async {
      bool removed = false;
      await tester.pumpWidget(
        buildTestableWidget(
          Scaffold(
            body: PrescriptionAttachmentCardWidget(
              imagePath: 'demo.png',
              onRemove: () => removed = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الوصفة الطبية المرفقة'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(removed, isTrue);
    });

    testWidgets('PrescriptionSentScreen renders order number and pharmacies', (tester) async {
      const order = PrescriptionOrderModel(
        id: 'ord_1',
        orderNumber: 'RX-41178',
        pharmacies: [
          PrescriptionOrderPharmacyModel(
            pharmacyId: 'p1',
            name: 'صيدليات العزبي',
            branchName: 'فرع مدينة نصر',
            status: 'Pending',
          ),
          PrescriptionOrderPharmacyModel(
            pharmacyId: 'p2',
            name: 'صيدلية سيف',
            status: 'Pending',
          ),
        ],
      );

      await tester.pumpWidget(
        buildTestableWidget(const PrescriptionSentScreen(order: order)),
      );
      await tester.pumpAndSettle();

      expect(find.text('تم إرسال طلبك بنجاح'), findsOneWidget);
      expect(find.text('في انتظار رد الصيدليات بتوافر المطلوب والأسعار.'), findsOneWidget);
      expect(find.text('تم الإرسال إلى صيدليتين'), findsOneWidget);
      expect(find.text('صيدليات العزبي - فرع مدينة نصر'), findsOneWidget);
      expect(find.text('صيدلية سيف'), findsOneWidget);
      expect(find.text('RX-41178'), findsOneWidget);
      expect(find.text('العودة للصيدليات'), findsOneWidget);
    });
  });
}

