import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/apis/api_urls.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_list_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_lists_api_model_successful_response.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';

class DoctorListApiManager {
  final DioApiManager dioApiManager;

  DoctorListApiManager(this.dioApiManager);

  Future<void> getDoctorListsApi(
      DoctorListSendModel sendModel,
      Future<void> Function(DoctorListsApiModelSuccessfulResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(
          ApiUrls.specialtyDoctors(sendModel.specialtyId),
          queryParameters: sendModel.toMap(),
        )
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      DoctorListsApiModelSuccessfulResponse wrapper =
          DoctorListsApiModelSuccessfulResponse.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error));
    });
  }

  Future<void> getInsuranceCompaniesApi(
    Future<void> Function(InsuranceCompaniesResponseModel) success,
    void Function(ErrorApiModel) fail,
  ) async {
    await dioApiManager.dio
        .get(ApiUrls.insuranceCompanies)
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      InsuranceCompaniesResponseModel wrapper =
          InsuranceCompaniesResponseModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error));
    });
  }

  Future<void> getGovernoratesApi(
    Future<void> Function(GovernoratesResponseModel) success,
    void Function(ErrorApiModel) fail,
  ) async {
    await dioApiManager.dio
        .get(ApiUrls.governorates)
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      GovernoratesResponseModel wrapper =
          GovernoratesResponseModel.fromJson(extractedData);
      await success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error));
    });
  }
}
