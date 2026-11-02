import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/apis/api_urls.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';

class MedicalSpecialtiesApiManager {
  final DioApiManager dioApiManager;

  MedicalSpecialtiesApiManager(this.dioApiManager);

  Future<void> getMedicalSpecialties({
    required void Function(MedicalSpecialtiesResponseModel) success,
    required void Function(ErrorApiModel) fail,
  }) async {
    await dioApiManager.dio
        .get(ApiUrls.medicalSpecialties)
        .then((response) {
          Map<String, dynamic> extractedData =
              response.data as Map<String, dynamic>;
          MedicalSpecialtiesResponseModel wrapper =
              MedicalSpecialtiesResponseModel.fromJson(extractedData);
          success(wrapper);
        })
        .catchError((error) {
          fail(ErrorApiModel.identifyError(error: error));
        });
  }
}
