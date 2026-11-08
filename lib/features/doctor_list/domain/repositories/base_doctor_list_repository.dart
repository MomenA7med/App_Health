import 'package:app_health/features/doctor_list/data/models/doctor_list_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_lists_api_model_successful_response.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';

abstract class BaseDoctorListRepository {
  Future<DoctorListsApiModelSuccessfulResponse> getDoctorListsApi(
      DoctorListSendModel sendModel);
  Future<InsuranceCompaniesResponseModel> getInsuranceCompaniesApi();
  Future<GovernoratesResponseModel> getGovernoratesApi();
}
