import 'package:app_health/features/doctor_details/data/datasources/doctor_details_api_manager.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';
import 'package:app_health/features/doctor_details/domain/repositories/base_doctor_details_repository.dart';

class DoctorDetailsRepository implements BaseDoctorDetailsRepository {
  final DoctorDetailsApiManager doctorDetailsApiManager;

  DoctorDetailsRepository(this.doctorDetailsApiManager);

  @override
  Future<DoctorProfileResponseModel> getDoctorProfileApi(
    String doctorId,
  ) async {
    late DoctorProfileResponseModel profileResponse;
    await doctorDetailsApiManager.getDoctorProfileApi(
      doctorId,
      (response) async {
        profileResponse = response;
      },
      (error) {
        throw error;
      },
    );
    return profileResponse;
  }

  @override
  Future<DoctorReviewsResponseModel> getDoctorReviewsApi(
    String doctorId,
  ) async {
    late DoctorReviewsResponseModel reviewsResponse;
    await doctorDetailsApiManager.getDoctorReviewsApi(
      doctorId,
      (response) async {
        reviewsResponse = response;
      },
      (error) {
        throw error;
      },
    );
    return reviewsResponse;
  }
}

