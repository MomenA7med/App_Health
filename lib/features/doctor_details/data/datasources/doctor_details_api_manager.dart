import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/apis/api_urls.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';

class DoctorDetailsApiManager {
  final DioApiManager dioApiManager;

  DoctorDetailsApiManager(this.dioApiManager);

  Future<void> getDoctorProfileApi(
    String doctorId,
    Future<void> Function(DoctorProfileResponseModel) success,
    void Function(ErrorApiModel) fail,
  ) async {
    await dioApiManager.dio
        .get(ApiUrls.doctorProfile(doctorId))
        .then((response) async {
      final Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      final DoctorProfileResponseModel wrapper =
          DoctorProfileResponseModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error));
    });
  }

  Future<void> getDoctorReviewsApi(
    String doctorId,
    Future<void> Function(DoctorReviewsResponseModel) success,
    void Function(ErrorApiModel) fail,
  ) async {
    await dioApiManager.dio
        .get(ApiUrls.doctorReviews(doctorId))
        .then((response) async {
      final Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      final DoctorReviewsResponseModel wrapper =
          DoctorReviewsResponseModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error));
    });
  }
}

