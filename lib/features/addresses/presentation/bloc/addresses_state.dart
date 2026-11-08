import 'package:equatable/equatable.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';

abstract class AddressesState extends Equatable {
  const AddressesState();

  @override
  List<Object?> get props => [];
}

class AddressesInitialState extends AddressesState {}

class AddressesLoadingState extends AddressesState {}

class AddressesLoadedState extends AddressesState {
  final List<UserAddressModel> items;
  final UserAddressModel? selectedAddress;
  final bool isCurrentLocationSelected;
  final String? defaultAddressId;
  final List<GovernorateModel> governorates;
  final bool isCreating;
  final String? createError;
  final UserAddressModel? newlyCreatedAddress;

  const AddressesLoadedState({
    required this.items,
    this.selectedAddress,
    this.isCurrentLocationSelected = false,
    this.defaultAddressId,
    this.governorates = const [],
    this.isCreating = false,
    this.createError,
    this.newlyCreatedAddress,
  });

  AddressesLoadedState copyWith({
    List<UserAddressModel>? items,
    UserAddressModel? selectedAddress,
    bool? isCurrentLocationSelected,
    String? defaultAddressId,
    List<GovernorateModel>? governorates,
    bool? isCreating,
    String? createError,
    UserAddressModel? newlyCreatedAddress,
    bool clearSelectedAddress = false,
  }) {
    return AddressesLoadedState(
      items: items ?? this.items,
      selectedAddress: clearSelectedAddress
          ? null
          : (selectedAddress ?? this.selectedAddress),
      isCurrentLocationSelected:
          isCurrentLocationSelected ?? this.isCurrentLocationSelected,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
      governorates: governorates ?? this.governorates,
      isCreating: isCreating ?? this.isCreating,
      createError: createError,
      newlyCreatedAddress: newlyCreatedAddress,
    );
  }

  @override
  List<Object?> get props => [
        items,
        selectedAddress,
        isCurrentLocationSelected,
        defaultAddressId,
        governorates,
        isCreating,
        createError,
        newlyCreatedAddress,
      ];
}

class AddressesErrorState extends AddressesState {
  final String errorMessage;
  final bool isLocalizationKey;

  const AddressesErrorState(this.errorMessage, this.isLocalizationKey);

  @override
  List<Object?> get props => [errorMessage, isLocalizationKey];
}

