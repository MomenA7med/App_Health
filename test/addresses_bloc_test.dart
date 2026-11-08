import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/addresses/data/models/create_address_send_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/addresses/domain/repositories/base_addresses_repository.dart';
import 'package:app_health/features/addresses/domain/usecases/create_user_address_use_case.dart';
import 'package:app_health/features/addresses/domain/usecases/get_address_governorates_use_case.dart';
import 'package:app_health/features/addresses/domain/usecases/get_user_addresses_use_case.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';

class FakeAddressesRepository implements BaseAddressesRepository {
  bool shouldFailAddresses = false;
  bool shouldFailCreate = false;
  bool shouldFailGovernorates = false;

  List<UserAddressModel> addresses = [];
  List<GovernorateModel> governorates = [];

  @override
  Future<UserAddressesResponseModel> getUserAddressesApi() async {
    if (shouldFailAddresses) {
      throw ErrorApiModel(
        isMessageLocalizationKey: false,
        message: 'Failed to load addresses',
        code: 500,
      );
    }
    return UserAddressesResponseModel(
      success: true,
      code: 'USER_ADDRESSES_RETRIEVED',
      message: 'Success',
      data: UserAddressesDataModel(
        items: addresses,
        totalCount: addresses.length,
      ),
    );
  }

  @override
  Future<CreateAddressResponseModel> createUserAddressApi(
      CreateAddressSendModel sendModel) async {
    if (shouldFailCreate) {
      throw ErrorApiModel(
        isMessageLocalizationKey: false,
        message: 'Failed to create address',
        code: 400,
      );
    }
    final newAddress = UserAddressModel(
      id: 'new_id_123',
      addressName: sendModel.addressName,
      governorate: sendModel.governorate,
      area: sendModel.area,
      detailedAddress: sendModel.detailedAddress,
      isCurrentLocation: sendModel.isCurrentLocation,
    );
    addresses.insert(0, newAddress);
    return CreateAddressResponseModel(
      success: true,
      code: 'USER_ADDRESS_CREATED',
      message: 'Created',
      data: newAddress,
    );
  }

  @override
  Future<GovernoratesResponseModel> getGovernoratesApi() async {
    if (shouldFailGovernorates) {
      throw ErrorApiModel(
        isMessageLocalizationKey: false,
        message: 'Failed to load governorates',
        code: 500,
      );
    }
    return GovernoratesResponseModel(
      success: true,
      code: 'GOVERNORATES_RETRIEVED',
      message: 'Success',
      data: governorates,
    );
  }
}

void main() {
  late FakeAddressesRepository fakeRepo;
  late GetUserAddressesUseCase getUserAddressesUseCase;
  late CreateUserAddressUseCase createUserAddressUseCase;
  late GetAddressGovernoratesUseCase getAddressGovernoratesUseCase;
  late AddressesBloc bloc;

  setUp(() {
    fakeRepo = FakeAddressesRepository();
    getUserAddressesUseCase = GetUserAddressesUseCase(fakeRepo);
    createUserAddressUseCase = CreateUserAddressUseCase(fakeRepo);
    getAddressGovernoratesUseCase = GetAddressGovernoratesUseCase(fakeRepo);

    bloc = AddressesBloc(
      getUserAddressesUseCase: getUserAddressesUseCase,
      createUserAddressUseCase: createUserAddressUseCase,
      getAddressGovernoratesUseCase: getAddressGovernoratesUseCase,
    );

    fakeRepo.addresses = [
      const UserAddressModel(
        id: 'addr_1',
        addressName: 'Home',
        governorate: 'gov_1',
        area: 'area_1',
        detailedAddress: 'Nasr City',
        isCurrentLocation: true,
      ),
    ];

    fakeRepo.governorates = const [
      GovernorateModel(
        id: 'gov_1',
        name: 'Cairo',
        areas: [
          AreaModel(id: 'area_1', governorateId: 'gov_1', name: 'Nasr City'),
        ],
      ),
    ];
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is AddressesInitialState', () {
    expect(bloc.state, isA<AddressesInitialState>());
  });

  test('FetchUserAddressesEvent emits loading then loaded state', () async {
    final expectedStates = [
      isA<AddressesLoadingState>(),
      isA<AddressesLoadedState>().having(
        (s) => s.items.length,
        'items.length',
        1,
      ),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));
    bloc.add(const FetchUserAddressesEvent());
  });

  test('FetchUserAddressesEvent emits error state when repository fails', () async {
    fakeRepo.shouldFailAddresses = true;

    final expectedStates = [
      isA<AddressesLoadingState>(),
      isA<AddressesErrorState>().having(
        (s) => s.errorMessage,
        'errorMessage',
        'Failed to load addresses',
      ),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));
    bloc.add(const FetchUserAddressesEvent());
  });

  test('SelectAddressEvent updates selectedAddress in loaded state', () async {
    final loadedBloc = AddressesBloc(
      getUserAddressesUseCase: getUserAddressesUseCase,
      createUserAddressUseCase: createUserAddressUseCase,
      getAddressGovernoratesUseCase: getAddressGovernoratesUseCase,
      initialState: AddressesLoadedState(
        items: fakeRepo.addresses,
        governorates: fakeRepo.governorates,
      ),
    );

    const selected = UserAddressModel(
      id: 'addr_1',
      addressName: 'Home',
      governorate: 'gov_1',
      area: 'area_1',
      detailedAddress: 'Nasr City',
      isCurrentLocation: true,
    );

    final future = expectLater(
      loadedBloc.stream,
      emits(
        isA<AddressesLoadedState>().having(
          (s) => s.selectedAddress?.id,
          'selectedAddress.id',
          'addr_1',
        ),
      ),
    );

    loadedBloc.add(const SelectAddressEvent(selected));
    await future;
    await loadedBloc.close();
  });

  test('SelectCurrentLocationEvent resets selected address and sets current location', () async {
    final loadedBloc = AddressesBloc(
      getUserAddressesUseCase: getUserAddressesUseCase,
      createUserAddressUseCase: createUserAddressUseCase,
      getAddressGovernoratesUseCase: getAddressGovernoratesUseCase,
      initialState: AddressesLoadedState(
        items: fakeRepo.addresses,
        governorates: fakeRepo.governorates,
      ),
    );

    final future = expectLater(
      loadedBloc.stream,
      emits(
        isA<AddressesLoadedState>().having(
          (s) => s.isCurrentLocationSelected,
          'isCurrentLocationSelected',
          true,
        ),
      ),
    );

    loadedBloc.add(const SelectCurrentLocationEvent());
    await future;
    await loadedBloc.close();
  });

  test('CreateUserAddressEvent successfully creates and selects new address', () async {
    final loadedBloc = AddressesBloc(
      getUserAddressesUseCase: getUserAddressesUseCase,
      createUserAddressUseCase: createUserAddressUseCase,
      getAddressGovernoratesUseCase: getAddressGovernoratesUseCase,
      initialState: AddressesLoadedState(
        items: fakeRepo.addresses,
        governorates: fakeRepo.governorates,
      ),
    );

    const sendModel = CreateAddressSendModel(
      addressName: 'Work',
      governorate: 'gov_1',
      area: 'area_1',
      detailedAddress: 'Office Building',
      isCurrentLocation: false,
    );

    final future = expectLater(
      loadedBloc.stream,
      emitsInOrder([
        isA<AddressesLoadedState>().having((s) => s.isCreating, 'isCreating', true),
        isA<AddressesLoadedState>().having(
          (s) => s.newlyCreatedAddress?.addressName,
          'addressName',
          'Work',
        ),
      ]),
    );

    loadedBloc.add(const CreateUserAddressEvent(sendModel));
    await future;

    expect(loadedBloc.state, isA<AddressesLoadedState>());
    final state = loadedBloc.state as AddressesLoadedState;
    expect(state.newlyCreatedAddress?.addressName, 'Work');
    expect(state.items.first.addressName, 'Work');
    expect(state.selectedAddress?.addressName, 'Work');
    expect(state.isCreating, false);
    await loadedBloc.close();
  });
}
