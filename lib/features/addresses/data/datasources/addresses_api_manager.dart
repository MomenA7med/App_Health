import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/apis/api_urls.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/addresses/data/models/create_address_send_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';

class AddressesApiManager {
  final DioApiManager dioApiManager;

  AddressesApiManager(this.dioApiManager);

  Future<void> getUserAddressesApi(
    Future<void> Function(UserAddressesResponseModel) success,
    void Function(ErrorApiModel) fail,
  ) async {
    await dioApiManager.dio
        .get(ApiUrls.userAddresses)
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UserAddressesResponseModel wrapper =
          UserAddressesResponseModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error));
    });
  }

  Future<void> createUserAddressApi(
    CreateAddressSendModel sendModel,
    Future<void> Function(CreateAddressResponseModel) success,
    void Function(ErrorApiModel) fail,
  ) async {
    await dioApiManager.dio
        .post(
          ApiUrls.userAddresses,
          data: sendModel.toJson(),
        )
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      CreateAddressResponseModel wrapper =
          CreateAddressResponseModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error));
    });
  }

  Future<void> getGovernoratesApi(
    Future<void> Function(GovernoratesResponseModel) success,
    void Function(ErrorApiModel) fail,
  ) async {
    await dioApiManager.dio
        .get(ApiUrls.governorates)
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      GovernoratesResponseModel wrapper =
          GovernoratesResponseModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error));
    });
  }
}

