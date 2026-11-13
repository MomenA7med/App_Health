import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/hospital_list/data/datasources/hospital_list_api_manager.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_list_send_model.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_lists_api_model_successful_response.dart';
import 'package:app_health/features/hospital_list/domain/repositories/base_hospital_list_repository.dart';

class HospitalListRepository implements BaseHospitalListRepository {
  final HospitalListApiManager hospitalListApiManager;

  HospitalListRepository(this.hospitalListApiManager);

  @override
  Future<HospitalListsApiModelSuccessfulResponse> getHospitalListsApi(
      HospitalListSendModel sendModel) async {
    late HospitalListsApiModelSuccessfulResponse response;

    await hospitalListApiManager.getHospitalListsApi(
      sendModel,
      (successResponse) async {
        response = successResponse;
      },
      (errorApiModel) {
        throw (errorApiModel);
      },
    );
    return response;
  }

  @override
  Future<InsuranceCompaniesResponseModel> getInsuranceCompaniesApi() async {
    late InsuranceCompaniesResponseModel response;
    await hospitalListApiManager.getInsuranceCompaniesApi(
      (data) async {
        response = data;
      },
      (errorApiModel) {
        throw (errorApiModel);
      },
    );
    return response;
  }

  @override
  Future<GovernoratesResponseModel> getGovernoratesApi() async {
    late GovernoratesResponseModel response;
    await hospitalListApiManager.getGovernoratesApi(
      (data) async {
        response = data;
      },
      (errorApiModel) {
        throw (errorApiModel);
      },
    );
    return response;
  }
}

