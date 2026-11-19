import 'package:app_health/features/pharmacy_details/data/datasources/pharmacy_details_api_manager.dart';
import 'package:app_health/features/pharmacy_details/data/models/pharmacy_profile_response_model.dart';
import 'package:app_health/features/pharmacy_details/domain/repositories/base_pharmacy_details_repository.dart';

class PharmacyDetailsRepository implements BasePharmacyDetailsRepository {
  final PharmacyDetailsApiManager pharmacyDetailsApiManager;

  PharmacyDetailsRepository(this.pharmacyDetailsApiManager);

  @override
  Future<PharmacyProfileResponseModel> getPharmacyProfile(
      String pharmacyId) async {
    late PharmacyProfileResponseModel response;
    await pharmacyDetailsApiManager.getPharmacyProfile(
      pharmacyId: pharmacyId,
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

