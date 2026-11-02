import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';

abstract class BaseMedicalSpecialtiesRepository {
  Future<MedicalSpecialtiesResponseModel> getMedicalSpecialties();
}
