import 'package:app_health/features/medical_specialties/data/datasources/medical_specialties_api_manager.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';
import 'package:app_health/features/medical_specialties/domain/repositories/base_medical_specialties_repository.dart';

class MedicalSpecialtiesRepository implements BaseMedicalSpecialtiesRepository {
  final MedicalSpecialtiesApiManager apiManager;

  MedicalSpecialtiesRepository(this.apiManager);

  @override
  Future<MedicalSpecialtiesResponseModel> getMedicalSpecialties() async {
    late MedicalSpecialtiesResponseModel responseModel;
    await apiManager.getMedicalSpecialties(
      success: (response) {
        responseModel = response;
      },
      fail: (errorApiModel) {
        throw errorApiModel;
      },
    );
    return responseModel;
  }
}
