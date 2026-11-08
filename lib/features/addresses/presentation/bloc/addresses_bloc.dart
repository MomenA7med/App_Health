import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/addresses/domain/usecases/create_user_address_use_case.dart';
import 'package:app_health/features/addresses/domain/usecases/get_address_governorates_use_case.dart';
import 'package:app_health/features/addresses/domain/usecases/get_user_addresses_use_case.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:app_health/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/logic/user_manager.dart';

class AddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  final GetUserAddressesUseCase getUserAddressesUseCase;
  final CreateUserAddressUseCase createUserAddressUseCase;
  final GetAddressGovernoratesUseCase getAddressGovernoratesUseCase;

  AddressesBloc({
    required this.getUserAddressesUseCase,
    required this.createUserAddressUseCase,
    required this.getAddressGovernoratesUseCase,
    AddressesState? initialState,
  }) : super(initialState ?? AddressesInitialState()) {
    on<FetchUserAddressesEvent>(_fetchUserAddressesEvent);
    on<SelectAddressEvent>(_selectAddressEvent);
    on<SelectCurrentLocationEvent>(_selectCurrentLocationEvent);
    on<CreateUserAddressEvent>(_createUserAddressEvent);
    on<FetchGovernoratesForAddressEvent>(_fetchGovernoratesForAddressEvent);
  }

  FutureOr<void> _fetchUserAddressesEvent(
    FetchUserAddressesEvent event,
    Emitter<AddressesState> emit,
  ) async {
    emit(AddressesLoadingState());

    // Fetch governorates for name resolution
    List<GovernorateModel> governorates = [];
    final govResult = await getAddressGovernoratesUseCase(NoParams());
    govResult.fold(
      (_) {},
      (response) => governorates = response.data,
    );

    final result = await getUserAddressesUseCase(NoParams());
    result.fold(
      (failure) {
        final error = failure is ErrorApiModel ? failure : null;
        emit(AddressesErrorState(
          error?.message ?? 'unknown_error',
          error?.isMessageLocalizationKey ?? true,
        ));
      },
      (response) {
        final data = response.data;
        emit(AddressesLoadedState(
          items: data.items,
          defaultAddressId: data.defaultAddressId,
          governorates: governorates,
        ));
      },
    );
  }

  FutureOr<void> _selectAddressEvent(
    SelectAddressEvent event,
    Emitter<AddressesState> emit,
  ) {
    if (state is AddressesLoadedState) {
      final current = state as AddressesLoadedState;
      emit(current.copyWith(
        selectedAddress: event.address,
        isCurrentLocationSelected: false,
      ));

      // Sync address text with UserManager
      if (GetIt.I.isRegistered<UserMangers>()) {
        GetIt.I<UserMangers>().setAddress(
          event.address.addressName.isNotEmpty
              ? event.address.addressName
              : event.address.detailedAddress,
        );
      }
    }
  }

  FutureOr<void> _selectCurrentLocationEvent(
    SelectCurrentLocationEvent event,
    Emitter<AddressesState> emit,
  ) {
    if (state is AddressesLoadedState) {
      final current = state as AddressesLoadedState;
      emit(current.copyWith(
        clearSelectedAddress: true,
        isCurrentLocationSelected: true,
      ));

      // Reset address text to default / current location
      if (GetIt.I.isRegistered<UserMangers>()) {
        GetIt.I<UserMangers>().setAddress('');
      }
    }
  }

  FutureOr<void> _createUserAddressEvent(
    CreateUserAddressEvent event,
    Emitter<AddressesState> emit,
  ) async {
    final currentState = state is AddressesLoadedState
        ? state as AddressesLoadedState
        : const AddressesLoadedState(items: []);

    emit(currentState.copyWith(isCreating: true, createError: null));

    final result = await createUserAddressUseCase(event.sendModel);
    result.fold(
      (failure) {
        final error = failure is ErrorApiModel ? failure : null;
        emit(currentState.copyWith(
          isCreating: false,
          createError: error?.message ?? 'unknown_error',
        ));
      },
      (response) {
        final newAddress = response.data;
        final updatedItems = [newAddress, ...currentState.items];
        emit(currentState.copyWith(
          items: updatedItems,
          selectedAddress: newAddress,
          isCurrentLocationSelected: false,
          isCreating: false,
          newlyCreatedAddress: newAddress,
        ));

        // Sync with UserManager
        if (GetIt.I.isRegistered<UserMangers>()) {
          GetIt.I<UserMangers>().setAddress(
            newAddress.addressName.isNotEmpty
                ? newAddress.addressName
                : newAddress.detailedAddress,
          );
        }
      },
    );
  }

  FutureOr<void> _fetchGovernoratesForAddressEvent(
    FetchGovernoratesForAddressEvent event,
    Emitter<AddressesState> emit,
  ) async {
    if (state is AddressesLoadedState) {
      final current = state as AddressesLoadedState;
      if (current.governorates.isNotEmpty) return;
    }

    final govResult = await getAddressGovernoratesUseCase(NoParams());
    govResult.fold(
      (_) {},
      (response) {
        if (state is AddressesLoadedState) {
          emit((state as AddressesLoadedState).copyWith(
            governorates: response.data,
          ));
        } else {
          emit(AddressesLoadedState(
            items: const [],
            governorates: response.data,
          ));
        }
      },
    );
  }
}
