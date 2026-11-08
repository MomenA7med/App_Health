import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/addresses/data/models/create_address_send_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/addresses/domain/repositories/base_addresses_repository.dart';
import 'package:app_health/features/addresses/domain/usecases/create_user_address_use_case.dart';
import 'package:app_health/features/addresses/domain/usecases/get_address_governorates_use_case.dart';
import 'package:app_health/features/addresses/domain/usecases/get_user_addresses_use_case.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:app_health/features/addresses/presentation/screens/add_address_screen.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakeAddAddressLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakeAddAddressLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return _FakeAddAddressLocalizations(locale);
  }

  @override
  bool shouldReload(_FakeAddAddressLocalizationsDelegate old) => false;
}

class _FakeAddAddressLocalizations extends AppLocalizations {
  _FakeAddAddressLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.addNewAddress: 'إضافة عنوان جديد',
    LocalizationKeys.addAddressHelper:
        'احفظ العنوان باسم واضح عشان تختاره بسهولة بعد كده.',
    LocalizationKeys.addressName: 'اسم العنوان',
    LocalizationKeys.addressNameHint: 'مثال: المنزل أو العمل',
    LocalizationKeys.governorate: 'المحافظة',
    LocalizationKeys.chooseGovernorate: 'اختر المحافظة',
    LocalizationKeys.area: 'المنطقة',
    LocalizationKeys.chooseArea: 'اختر المنطقة',
    LocalizationKeys.detailedAddress: 'العنوان بالتفصيل',
    LocalizationKeys.detailedAddressHint: 'اسم الشارع ورقم المبنى',
    LocalizationKeys.saveAndUseAddress: 'حفظ العنوان واستخدامه',
    LocalizationKeys.pleaseEnterAddressName: 'يرجى إدخال اسم العنوان',
    LocalizationKeys.pleaseChooseGovernorate: 'يرجى اختيار المحافظة',
    LocalizationKeys.pleaseChooseArea: 'يرجى اختيار المنطقة',
    LocalizationKeys.pleaseEnterDetailedAddress: 'يرجى إدخال العنوان بالتفصيل',
    LocalizationKeys.addressSavedSuccessfully: 'تم حفظ العنوان بنجاح',
  };

  @override
  String translate(String key) {
    return _translations[key] ?? key;
  }
}

class _FakeAddressesRepo implements BaseAddressesRepository {
  List<GovernorateModel> governorates = [];
  CreateAddressSendModel? lastCreatedModel;

  @override
  Future<UserAddressesResponseModel> getUserAddressesApi() async {
    return const UserAddressesResponseModel(
      success: true,
      code: 'USER_ADDRESSES_RETRIEVED',
      message: 'Success',
      data: UserAddressesDataModel(items: [], totalCount: 0),
    );
  }

  @override
  Future<CreateAddressResponseModel> createUserAddressApi(
      CreateAddressSendModel sendModel) async {
    lastCreatedModel = sendModel;
    return CreateAddressResponseModel(
      success: true,
      code: 'USER_ADDRESS_CREATED',
      message: 'Created',
      data: UserAddressModel(
        id: 'new_created_123',
        addressName: sendModel.addressName,
        governorate: sendModel.governorate,
        area: sendModel.area,
        detailedAddress: sendModel.detailedAddress,
        isCurrentLocation: sendModel.isCurrentLocation,
      ),
    );
  }

  @override
  Future<GovernoratesResponseModel> getGovernoratesApi() async {
    return GovernoratesResponseModel(
      success: true,
      code: 'GOVERNORATES_RETRIEVED',
      message: 'Success',
      data: governorates,
    );
  }
}

void main() {
  late _FakeAddressesRepo fakeRepo;
  late AddressesBloc bloc;

  setUp(() {
    fakeRepo = _FakeAddressesRepo();
    fakeRepo.governorates = const [
      GovernorateModel(
        id: 'gov_cairo',
        name: 'القاهرة',
        areas: [
          AreaModel(id: 'area_nasr', governorateId: 'gov_cairo', name: 'مدينة نصر'),
          AreaModel(id: 'area_maadi', governorateId: 'gov_cairo', name: 'المعادي'),
        ],
      ),
      GovernorateModel(
        id: 'gov_giza',
        name: 'الجيزة',
        areas: [
          AreaModel(id: 'area_dokki', governorateId: 'gov_giza', name: 'الدقي'),
        ],
      ),
    ];

    bloc = AddressesBloc(
      getUserAddressesUseCase: GetUserAddressesUseCase(fakeRepo),
      createUserAddressUseCase: CreateUserAddressUseCase(fakeRepo),
      getAddressGovernoratesUseCase: GetAddressGovernoratesUseCase(fakeRepo),
      initialState: AddressesLoadedState(
        items: const [],
        governorates: fakeRepo.governorates,
      ),
    );
  });

  tearDown(() {
    bloc.close();
  });

  Widget buildTestableWidget() {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, child) => MaterialApp(
        localizationsDelegates: const [
          _FakeAddAddressLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', '')],
        locale: const Locale('ar', ''),
        home: BlocProvider.value(
          value: bloc,
          child: const AddAddressScreen(),
        ),
      ),
    );
  }

  testWidgets('renders all fields and labels in AddAddressScreen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    expect(find.text('إضافة عنوان جديد'), findsOneWidget);
    expect(find.text('احفظ العنوان باسم واضح عشان تختاره بسهولة بعد كده.'),
        findsOneWidget);
    expect(find.text('اسم العنوان'), findsOneWidget);
    expect(find.text('مثال: المنزل أو العمل'), findsOneWidget);
    expect(find.text('المحافظة'), findsOneWidget);
    expect(find.text('اختر المحافظة'), findsOneWidget);
    expect(find.text('المنطقة'), findsOneWidget);
    expect(find.text('اختر المنطقة'), findsOneWidget);
    expect(find.text('العنوان بالتفصيل'), findsOneWidget);
    expect(find.text('اسم الشارع ورقم المبنى'), findsOneWidget);
    expect(find.text('حفظ العنوان واستخدامه'), findsOneWidget);
  });

  testWidgets('shows validation snackbar if address name is missing',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('حفظ العنوان واستخدامه'));
    await tester.pump();

    expect(find.text('يرجى إدخال اسم العنوان'), findsOneWidget);
  });

  testWidgets('allows filling form and saving address successfully',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Enter name
    await tester.enterText(
      find.widgetWithText(TextField, 'مثال: المنزل أو العمل'),
      'المنزل الجديد',
    );
    await tester.pumpAndSettle();

    // Select Governorate
    final govDropdownFinder = find.byType(DropdownButton<GovernorateModel>);
    await tester.ensureVisible(govDropdownFinder);
    await tester.tap(govDropdownFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('القاهرة').last);
    await tester.pumpAndSettle();

    // Select Area
    final areaDropdownFinder = find.byType(DropdownButton<AreaModel>);
    await tester.tap(areaDropdownFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('مدينة نصر').last);
    await tester.pumpAndSettle();

    // Enter Detailed Address
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -100));
    await tester.pumpAndSettle();

    final detailedFinder =
        find.widgetWithText(TextField, 'اسم الشارع ورقم المبنى');
    await tester.enterText(
      detailedFinder,
      'شارع عباس العقاد عمارة 15',
    );
    await tester.pumpAndSettle();

    // Tap Save
    final saveFinder = find.text('حفظ العنوان واستخدامه');
    await tester.ensureVisible(saveFinder);
    await tester.tap(saveFinder);
    await tester.pump();

    expect(fakeRepo.lastCreatedModel?.addressName, 'المنزل الجديد');
    expect(fakeRepo.lastCreatedModel?.governorate, 'gov_cairo');
    expect(fakeRepo.lastCreatedModel?.area, 'area_nasr');
    expect(fakeRepo.lastCreatedModel?.detailedAddress,
        'شارع عباس العقاد عمارة 15');
  });
}
