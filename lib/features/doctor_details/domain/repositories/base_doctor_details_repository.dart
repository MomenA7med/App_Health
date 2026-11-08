import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';

abstract class BaseDoctorDetailsRepository {
  Future<DoctorProfileResponseModel> getDoctorProfileApi(String doctorId);
  Future<DoctorReviewsResponseModel> getDoctorReviewsApi(String doctorId);
}

