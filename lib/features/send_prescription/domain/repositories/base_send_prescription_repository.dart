import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_lists_api_model_successful_response.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_response_model.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_send_model.dart';

abstract class BaseSendPrescriptionRepository {
  Future<SendPrescriptionResponseModel> sendPrescription(
    SendPrescriptionSendModel sendModel,
  );

  Future<List<GovernorateModel>> getGovernorates();

  Future<PharmacyListsApiModelSuccessfulResponse> getPharmacies(
    PharmacyListSendModel sendModel,
  );

  Future<List<UserAddressModel>> getUserAddresses();
}

