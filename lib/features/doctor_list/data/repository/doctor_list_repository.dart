import 'package:app_health/features/doctor_list/data/datasources/doctor_list_api_manager.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_list_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_lists_api_model_successful_response.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/doctor_list/domain/repositories/base_doctor_list_repository.dart';

class DoctorListRepository implements BaseDoctorListRepository {
  final DoctorListApiManager doctorListApiManager;

  DoctorListRepository(this.doctorListApiManager);

  @override
  Future<DoctorListsApiModelSuccessfulResponse> getDoctorListsApi(
      DoctorListSendModel sendModel) async {
    late DoctorListsApiModelSuccessfulResponse
        doctorListApiModelSuccessfulResponse;

    await doctorListApiManager.getDoctorListsApi(
      sendModel,
      (doctorListResponse) async {
        doctorListApiModelSuccessfulResponse = doctorListResponse;
      },
      (errorApiModel) {
        throw (errorApiModel);
      },
    );
    return doctorListApiModelSuccessfulResponse;
  }

  @override
  Future<InsuranceCompaniesResponseModel> getInsuranceCompaniesApi() async {
    late InsuranceCompaniesResponseModel response;
    await doctorListApiManager.getInsuranceCompaniesApi(
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
    await doctorListApiManager.getGovernoratesApi(
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
