import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/apis/api_urls.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/hospital_details/data/models/hospital_profile_response_model.dart';

class HospitalDetailsApiManager {
  final DioApiManager dioApiManager;

  HospitalDetailsApiManager(this.dioApiManager);

  Future<void> getHospitalProfile({
    required String hospitalId,
    required Future<void> Function(HospitalProfileResponseModel) success,
    required void Function(ErrorApiModel) fail,
  }) async {
    await dioApiManager.dio
        .get(ApiUrls.hospitalProfile(hospitalId))
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      HospitalProfileResponseModel wrapper =
          HospitalProfileResponseModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error));
    });
  }
}

