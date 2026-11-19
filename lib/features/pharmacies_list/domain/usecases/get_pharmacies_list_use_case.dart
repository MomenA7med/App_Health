import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/domain/entities/pharmacy_lists_ui_response.dart';
import 'package:app_health/features/pharmacies_list/domain/repositories/base_pharmacies_list_repository.dart';

class GetPharmaciesListUseCase
    extends BaseUseCase<PharmacyListsUiResponse, PharmacyListSendModel> {
  final BasePharmaciesListRepository pharmaciesListRepository;

  GetPharmaciesListUseCase(this.pharmaciesListRepository);

  @override
  Future<Either<ErrorApiModel, PharmacyListsUiResponse>> call(
      PharmacyListSendModel params) async {
    late Either<ErrorApiModel, PharmacyListsUiResponse> state;

    await pharmaciesListRepository
        .getPharmaciesListsApi(params)
        .then((response) {
      PharmacyListsUiResponse uiResponse =
          PharmacyListsUiResponse.fromApiModel(response);

      state = Right(uiResponse);
    }).catchError((onError) {
      ErrorApiModel errorApiModel = onError is ErrorApiModel
          ? onError
          : ErrorApiModel.identifyError(error: onError);
      state = Left(errorApiModel);
    });

    return state;
  }
}

