import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/apis/api_urls.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_lists_api_model_successful_response.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_response_model.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_send_model.dart';

class SendPrescriptionApiManager {
  final DioApiManager dioApiManager;

  SendPrescriptionApiManager(this.dioApiManager);

  Future<void> sendPrescriptionApi({
    required SendPrescriptionSendModel sendModel,
    required Future<void> Function(SendPrescriptionResponseModel) success,
    required void Function(ErrorApiModel) fail,
  }) async {
    try {
      final formData = await sendModel.toFormData();
      final response = await dioApiManager.dio.post(
        ApiUrls.sendPrescription,
        data: formData,
      );

      final extractedData = response.data as Map<String, dynamic>;
      final result = SendPrescriptionResponseModel.fromJson(extractedData);
      await success(result);
    } catch (error) {
      fail(ErrorApiModel.identifyError(error: error));
    }
  }

  Future<void> getGovernoratesApi({
    required Future<void> Function(List<GovernorateModel>) success,
    required void Function(ErrorApiModel) fail,
  }) async {
    try {
      final response = await dioApiManager.dio.get(ApiUrls.governorates);
      final extractedData = response.data as Map<String, dynamic>;
      final result = GovernoratesResponseModel.fromJson(extractedData);
      await success(result.data);
    } catch (error) {
      fail(ErrorApiModel.identifyError(error: error));
    }
  }

  Future<void> getPharmaciesApi({
    required PharmacyListSendModel sendModel,
    required Future<void> Function(PharmacyListsApiModelSuccessfulResponse) success,
    required void Function(ErrorApiModel) fail,
  }) async {
    try {
      final response = await dioApiManager.dio.get(
        ApiUrls.pharmaciesFilter,
        queryParameters: sendModel.toMap(),
      );
      final extractedData = response.data as Map<String, dynamic>;
      final result =
          PharmacyListsApiModelSuccessfulResponse.fromJson(extractedData);
      await success(result);
    } catch (error) {
      fail(ErrorApiModel.identifyError(error: error));
    }
  }

  Future<void> getUserAddressesApi({
    required Future<void> Function(List<UserAddressModel>) success,
    required void Function(ErrorApiModel) fail,
  }) async {
    try {
      final response = await dioApiManager.dio.get(ApiUrls.userAddresses);
      final extractedData = response.data as Map<String, dynamic>;
      final dataJson = extractedData['data'];
      if (dataJson is Map<String, dynamic>) {
        final addressData = UserAddressesDataModel.fromJson(dataJson);
        await success(addressData.items);
      } else if (dataJson is List<dynamic>) {
        final items = dataJson
            .map((item) => UserAddressModel.fromJson(item as Map<String, dynamic>))
            .toList();
        await success(items);
      } else {
        await success([]);
      }
    } catch (error) {
      fail(ErrorApiModel.identifyError(error: error));
    }
  }
}

