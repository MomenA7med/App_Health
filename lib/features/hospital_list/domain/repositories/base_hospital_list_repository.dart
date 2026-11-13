import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_list_send_model.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_lists_api_model_successful_response.dart';

abstract class BaseHospitalListRepository {
  Future<HospitalListsApiModelSuccessfulResponse> getHospitalListsApi(
      HospitalListSendModel sendModel);
  Future<InsuranceCompaniesResponseModel> getInsuranceCompaniesApi();
  Future<GovernoratesResponseModel> getGovernoratesApi();
}

