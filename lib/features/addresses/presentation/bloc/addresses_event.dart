import 'package:equatable/equatable.dart';
import 'package:app_health/features/addresses/data/models/create_address_send_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';

abstract class AddressesEvent extends Equatable {
  const AddressesEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserAddressesEvent extends AddressesEvent {
  const FetchUserAddressesEvent();
}

class SelectAddressEvent extends AddressesEvent {
  final UserAddressModel address;

  const SelectAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class SelectCurrentLocationEvent extends AddressesEvent {
  const SelectCurrentLocationEvent();
}

class CreateUserAddressEvent extends AddressesEvent {
  final CreateAddressSendModel sendModel;

  const CreateUserAddressEvent(this.sendModel);

  @override
  List<Object?> get props => [sendModel];
}

class FetchGovernoratesForAddressEvent extends AddressesEvent {
  const FetchGovernoratesForAddressEvent();
}

