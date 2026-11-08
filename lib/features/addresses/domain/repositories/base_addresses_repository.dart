import 'package:app_health/features/addresses/data/models/create_address_send_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';

abstract class BaseAddressesRepository {
  Future<UserAddressesResponseModel> getUserAddressesApi();
  Future<CreateAddressResponseModel> createUserAddressApi(
      CreateAddressSendModel sendModel);
  Future<GovernoratesResponseModel> getGovernoratesApi();
}

