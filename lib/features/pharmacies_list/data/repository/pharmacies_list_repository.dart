import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/pharmacies_list/data/datasources/pharmacies_list_api_manager.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_lists_api_model_successful_response.dart';
import 'package:app_health/features/pharmacies_list/domain/repositories/base_pharmacies_list_repository.dart';

class PharmaciesListRepository implements BasePharmaciesListRepository {
  final PharmaciesListApiManager pharmaciesListApiManager;

  PharmaciesListRepository(this.pharmaciesListApiManager);

  @override
  Future<PharmacyListsApiModelSuccessfulResponse> getPharmaciesListsApi(
      PharmacyListSendModel sendModel) async {
    late PharmacyListsApiModelSuccessfulResponse response;

    await pharmaciesListApiManager.getPharmaciesListApi(
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
    await pharmaciesListApiManager.getInsuranceCompaniesApi(
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
    await pharmaciesListApiManager.getGovernoratesApi(
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

