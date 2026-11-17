import 'package:app_health/features/hospital_details/data/models/hospital_profile_response_model.dart';

abstract class BaseHospitalDetailsRepository {
  Future<HospitalProfileResponseModel> getHospitalProfile(String hospitalId);
}

