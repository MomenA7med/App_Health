import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/send_prescription/domain/repositories/base_send_prescription_repository.dart';

class GetPrescriptionGovernoratesUseCase {
  final BaseSendPrescriptionRepository repository;

  GetPrescriptionGovernoratesUseCase(this.repository);

  Future<List<GovernorateModel>> call() {
    return repository.getGovernorates();
  }
}

