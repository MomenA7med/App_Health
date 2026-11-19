import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/send_prescription/domain/repositories/base_send_prescription_repository.dart';

class GetPrescriptionSavedAddressesUseCase {
  final BaseSendPrescriptionRepository repository;

  GetPrescriptionSavedAddressesUseCase(this.repository);

  Future<List<UserAddressModel>> call() {
    return repository.getUserAddresses();
  }
}

