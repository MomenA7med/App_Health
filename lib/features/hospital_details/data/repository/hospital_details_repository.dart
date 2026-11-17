import 'package:app_health/features/hospital_details/data/datasources/hospital_details_api_manager.dart';
import 'package:app_health/features/hospital_details/data/models/hospital_profile_response_model.dart';
import 'package:app_health/features/hospital_details/domain/repositories/base_hospital_details_repository.dart';

class HospitalDetailsRepository implements BaseHospitalDetailsRepository {
  final HospitalDetailsApiManager hospitalDetailsApiManager;

  HospitalDetailsRepository(this.hospitalDetailsApiManager);

  @override
  Future<HospitalProfileResponseModel> getHospitalProfile(
      String hospitalId) async {
    late HospitalProfileResponseModel response;
    await hospitalDetailsApiManager.getHospitalProfile(
      hospitalId: hospitalId,
      success: (data) async {
        response = data;
      },
      fail: (error) {
        throw error;
      },
    );
    return response;
  }
}

