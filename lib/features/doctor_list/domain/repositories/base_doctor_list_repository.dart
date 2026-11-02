import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';

abstract class BaseDoctorListRepository {
  Future<SpecialtyDoctorsResponseModel> getSpecialtyDoctors({
    required String specialtyId,
    Map<String, dynamic>? queryParameters,
  });
}

