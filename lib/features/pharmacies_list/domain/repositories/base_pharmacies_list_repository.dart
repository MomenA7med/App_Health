import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_lists_api_model_successful_response.dart';

abstract class BasePharmaciesListRepository {
  Future<PharmacyListsApiModelSuccessfulResponse> getPharmaciesListsApi(
      PharmacyListSendModel sendModel);
  Future<InsuranceCompaniesResponseModel> getInsuranceCompaniesApi();
  Future<GovernoratesResponseModel> getGovernoratesApi();
}

