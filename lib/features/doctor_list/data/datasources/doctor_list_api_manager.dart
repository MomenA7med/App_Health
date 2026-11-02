import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/apis/api_urls.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';

class DoctorListApiManager {
  final DioApiManager dioApiManager;

  DoctorListApiManager(this.dioApiManager);

  Future<void> getSpecialtyDoctors({
    required String specialtyId,
    Map<String, dynamic>? queryParameters,
    required void Function(SpecialtyDoctorsResponseModel) success,
    required void Function(ErrorApiModel) fail,
  }) async {
    await dioApiManager.dio
        .get(
          ApiUrls.specialtyDoctors(specialtyId),
          queryParameters: queryParameters,
        )
        .then((response) {
          Map<String, dynamic> extractedData =
              response.data as Map<String, dynamic>;
          SpecialtyDoctorsResponseModel wrapper =
              SpecialtyDoctorsResponseModel.fromJson(extractedData);
          success(wrapper);
        })
        .catchError((error) {
          fail(ErrorApiModel.identifyError(error: error));
        });
  }
}

