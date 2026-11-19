import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_lists_api_model_successful_response.dart';
import 'package:app_health/features/send_prescription/domain/repositories/base_send_prescription_repository.dart';

class GetPrescriptionPharmaciesUseCase {
  final BaseSendPrescriptionRepository repository;

  GetPrescriptionPharmaciesUseCase(this.repository);

  Future<PharmacyListsApiModelSuccessfulResponse> call(
    PharmacyListSendModel sendModel,
  ) {
    return repository.getPharmacies(sendModel);
  }
}

