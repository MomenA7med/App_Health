import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/apis/api_urls.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/pharmacy_details/data/models/pharmacy_profile_response_model.dart';

class PharmacyDetailsApiManager {
  final DioApiManager dioApiManager;

  PharmacyDetailsApiManager(this.dioApiManager);

  Future<void> getPharmacyProfile({
    required String pharmacyId,
    required Future<void> Function(PharmacyProfileResponseModel) success,
    required void Function(ErrorApiModel) fail,
  }) async {
    await dioApiManager.dio
        .get(ApiUrls.pharmacyProfile(pharmacyId))
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      PharmacyProfileResponseModel wrapper =
          PharmacyProfileResponseModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error));
    });
  }
}

