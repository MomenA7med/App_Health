import 'package:app_health/features/pharmacy_details/data/models/pharmacy_profile_response_model.dart';

abstract class BasePharmacyDetailsRepository {
  Future<PharmacyProfileResponseModel> getPharmacyProfile(String pharmacyId);
}

