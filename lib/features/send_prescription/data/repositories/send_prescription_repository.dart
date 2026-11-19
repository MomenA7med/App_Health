import 'dart:async';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_lists_api_model_successful_response.dart';
import 'package:app_health/features/send_prescription/data/datasources/send_prescription_api_manager.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_response_model.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_send_model.dart';
import 'package:app_health/features/send_prescription/domain/repositories/base_send_prescription_repository.dart';

class SendPrescriptionRepository implements BaseSendPrescriptionRepository {
  final SendPrescriptionApiManager apiManager;

  SendPrescriptionRepository(this.apiManager);

  @override
  Future<SendPrescriptionResponseModel> sendPrescription(
    SendPrescriptionSendModel sendModel,
  ) {
    final completer = Completer<SendPrescriptionResponseModel>();

    apiManager.sendPrescriptionApi(
      sendModel: sendModel,
      success: (response) async {
        completer.complete(response);
      },
      fail: (ErrorApiModel error) {
        completer.completeError(error);
      },
    );

    return completer.future;
  }

  @override
  Future<List<GovernorateModel>> getGovernorates() {
    final completer = Completer<List<GovernorateModel>>();

    apiManager.getGovernoratesApi(
      success: (list) async {
        completer.complete(list);
      },
      fail: (ErrorApiModel error) {
        completer.completeError(error);
      },
    );

    return completer.future;
  }

  @override
  Future<PharmacyListsApiModelSuccessfulResponse> getPharmacies(
    PharmacyListSendModel sendModel,
  ) {
    final completer = Completer<PharmacyListsApiModelSuccessfulResponse>();

    apiManager.getPharmaciesApi(
      sendModel: sendModel,
      success: (response) async {
        completer.complete(response);
      },
      fail: (ErrorApiModel error) {
        completer.completeError(error);
      },
    );

    return completer.future;
  }

  @override
  Future<List<UserAddressModel>> getUserAddresses() {
    final completer = Completer<List<UserAddressModel>>();

    apiManager.getUserAddressesApi(
      success: (addresses) async {
        completer.complete(addresses);
      },
      fail: (ErrorApiModel error) {
        completer.completeError(error);
      },
    );

    return completer.future;
  }
}

