import 'package:app_health/features/addresses/data/datasources/addresses_api_manager.dart';
import 'package:app_health/features/addresses/data/models/create_address_send_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/addresses/domain/repositories/base_addresses_repository.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';

class AddressesRepository implements BaseAddressesRepository {
  final AddressesApiManager addressesApiManager;

  AddressesRepository(this.addressesApiManager);

  @override
  Future<UserAddressesResponseModel> getUserAddressesApi() async {
    late UserAddressesResponseModel response;
    await addressesApiManager.getUserAddressesApi(
      (data) async {
        response = data;
      },
      (errorApiModel) {
        throw (errorApiModel);
      },
    );
    return response;
  }

  @override
  Future<CreateAddressResponseModel> createUserAddressApi(
      CreateAddressSendModel sendModel) async {
    late CreateAddressResponseModel response;
    await addressesApiManager.createUserAddressApi(
      sendModel,
      (data) async {
        response = data;
      },
      (errorApiModel) {
        throw (errorApiModel);
      },
    );
    return response;
  }

  @override
  Future<GovernoratesResponseModel> getGovernoratesApi() async {
    late GovernoratesResponseModel response;
    await addressesApiManager.getGovernoratesApi(
      (data) async {
        response = data;
      },
      (errorApiModel) {
        throw (errorApiModel);
      },
    );
    return response;
  }
}

