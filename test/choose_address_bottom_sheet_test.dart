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
import 'package:app_health/features/addresses/presentation/widgets/choose_address_bottom_sheet.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/utils/locale/app_localization.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class _FakeAddressLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakeAddressLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return _FakeAddressLocalizations(locale);
  }

  @override
  bool shouldReload(_FakeAddressLocalizationsDelegate old) => false;
}

class _FakeAddressLocalizations extends AppLocalizations {
  _FakeAddressLocalizations(super.locale);

  static final Map<String, String> _translations = {
    LocalizationKeys.chooseAddress: 'اختيار عنوان',
    LocalizationKeys.chooseAddressHelper:
        'اختار من عناوينك أو استخدم موقعك الحالي.',
    LocalizationKeys.savedAddresses: 'العناوين المحفوظة',
    LocalizationKeys.useCurrentLocation: 'استخدام موقعك الحالي',
    LocalizationKeys.detectLocationAutomatically: 'تحديد موقعك تلقائيًا',
    LocalizationKeys.selectAction: 'اختيار',
    LocalizationKeys.determineAction: 'تحديد',
    LocalizationKeys.addNewAddress: 'إضافة عنوان جديد',
    LocalizationKeys.noSavedAddresses: 'لا توجد عناوين محفوظة بعد',
    LocalizationKeys.savedAddress: 'عنوان محفوظ',
  };

  @override
  String translate(String key) {
    return _translations[key] ?? key;
  }
}

class _MockAddressesRepository implements BaseAddressesRepository {
  List<UserAddressModel> items = [];
  List<GovernorateModel> governorates = [];

  @override
  Future<UserAddressesResponseModel> getUserAddressesApi() async {
    return UserAddressesResponseModel(
      success: true,
      code: 'USER_ADDRESSES_RETRIEVED',
      message: 'Success',
      data: UserAddressesDataModel(
        items: items,
        totalCount: items.length,
      ),
    );
  }

  @override
  Future<CreateAddressResponseModel> createUserAddressApi(
      CreateAddressSendModel sendModel) async {
    return CreateAddressResponseModel(
      success: true,
      code: 'USER_ADDRESS_CREATED',
      message: 'Success',
      data: UserAddressModel(
        id: 'new_id',
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
  late _MockAddressesRepository mockRepository;
  late AddressesBloc addressesBloc;

  setUp(() {
    mockRepository = _MockAddressesRepository();

    mockRepository.items = const [
      UserAddressModel(
        id: 'addr_1',
        addressName: 'المنزل',
        governorate: 'gov_1',
        area: 'area_1',
        detailedAddress: 'شارع النصر',
        isCurrentLocation: true,
      ),
      UserAddressModel(
        id: 'addr_2',
        addressName: 'العمل',
        governorate: 'gov_1',
        area: 'area_2',
        detailedAddress: 'التجمع الخامس',
        isCurrentLocation: false,
      ),
    ];

    mockRepository.governorates = const [
      GovernorateModel(
        id: 'gov_1',
        name: 'القاهرة',
        areas: [
          AreaModel(id: 'area_1', governorateId: 'gov_1', name: 'مدينة نصر'),
          AreaModel(id: 'area_2', governorateId: 'gov_1', name: 'التجمع الخامس'),
        ],
      ),
    ];

    addressesBloc = AddressesBloc(
      getUserAddressesUseCase: GetUserAddressesUseCase(mockRepository),
      createUserAddressUseCase: CreateUserAddressUseCase(mockRepository),
      getAddressGovernoratesUseCase:
          GetAddressGovernoratesUseCase(mockRepository),
      initialState: AddressesLoadedState(
        items: mockRepository.items,
        governorates: mockRepository.governorates,
      ),
    );
  });

  tearDown(() {
    addressesBloc.close();
  });

  Widget buildTestableWidget({
    ValueChanged<UserAddressModel>? onSelectAddress,
    VoidCallback? onSelectCurrentLocation,
  }) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, child) => MaterialApp(
        localizationsDelegates: const [
          _FakeAddressLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', '')],
        locale: const Locale('ar', ''),
        home: Scaffold(
          body: BlocProvider.value(
            value: addressesBloc,
            child: ChooseAddressBottomSheet(
              onSelectAddress: onSelectAddress,
              onSelectCurrentLocation: onSelectCurrentLocation,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders all bottom sheet components and saved addresses correctly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    expect(find.text('اختيار عنوان'), findsOneWidget);
    expect(find.text('اختار من عناوينك أو استخدم موقعك الحالي.'), findsOneWidget);
    expect(find.text('العناوين المحفوظة'), findsOneWidget);
    expect(find.text('المنزل'), findsOneWidget);
    expect(find.text('العمل'), findsOneWidget);
    expect(find.text('مدينة نصر، القاهرة'), findsOneWidget);
    expect(find.text('التجمع الخامس، القاهرة'), findsOneWidget);
    expect(find.text('إضافة عنوان جديد'), findsOneWidget);
    expect(find.text('استخدام موقعك الحالي'), findsOneWidget);
    expect(find.text('تحديد موقعك تلقائيًا'), findsOneWidget);
  });

  testWidgets('selecting an address triggers onSelectAddress callback',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    UserAddressModel? selectedAddress;

    await tester.pumpWidget(
      buildTestableWidget(
        onSelectAddress: (addr) => selectedAddress = addr,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('المنزل'));
    await tester.pump();

    expect(selectedAddress?.id, 'addr_1');
    expect(selectedAddress?.addressName, 'المنزل');
  });

  testWidgets('tapping current location triggers onSelectCurrentLocation callback',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool currentLocationSelected = false;

    await tester.pumpWidget(
      buildTestableWidget(
        onSelectCurrentLocation: () => currentLocationSelected = true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('استخدام موقعك الحالي'));
    await tester.pump();

    expect(currentLocationSelected, true);
  });
}
