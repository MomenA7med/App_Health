import 'package:app_health/features/send_prescription/data/models/send_prescription_response_model.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_send_model.dart';
import 'package:app_health/features/send_prescription/domain/repositories/base_send_prescription_repository.dart';

class SendPrescriptionUseCase {
  final BaseSendPrescriptionRepository repository;

  SendPrescriptionUseCase(this.repository);

  Future<SendPrescriptionResponseModel> call(
    SendPrescriptionSendModel sendModel,
  ) {
    return repository.sendPrescription(sendModel);
  }
}

