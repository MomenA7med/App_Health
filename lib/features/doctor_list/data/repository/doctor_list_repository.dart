import 'package:app_health/features/doctor_list/data/datasources/doctor_list_api_manager.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/features/doctor_list/domain/repositories/base_doctor_list_repository.dart';

class DoctorListRepository implements BaseDoctorListRepository {
  final DoctorListApiManager apiManager;

  DoctorListRepository(this.apiManager);

  @override
  Future<SpecialtyDoctorsResponseModel> getSpecialtyDoctors({
    required String specialtyId,
    Map<String, dynamic>? queryParameters,
  }) async {
    late SpecialtyDoctorsResponseModel responseModel;
    await apiManager.getSpecialtyDoctors(
      specialtyId: specialtyId,
      queryParameters: queryParameters,
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

