import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_list_send_model.dart';
import 'package:app_health/features/hospital_list/domain/entities/hospital_lists_ui_response.dart';
import 'package:app_health/features/hospital_list/domain/repositories/base_hospital_list_repository.dart';

class GetHospitalListsUseCase
    extends BaseUseCase<HospitalListsUiResponse, HospitalListSendModel> {
  final BaseHospitalListRepository hospitalListRepository;

  GetHospitalListsUseCase(this.hospitalListRepository);

  @override
  Future<Either<ErrorApiModel, HospitalListsUiResponse>> call(
      HospitalListSendModel params) async {
    late Either<ErrorApiModel, HospitalListsUiResponse> state;

    await hospitalListRepository
        .getHospitalListsApi(params)
        .then((hospitalList) {
      HospitalListsUiResponse hospitalListResponse =
          HospitalListsUiResponse.fromApiModel(hospitalList);

      state = Right(hospitalListResponse);
    }).catchError((onError) {
      ErrorApiModel errorApiModel = onError is ErrorApiModel
          ? onError
          : ErrorApiModel.identifyError(error: onError);
      state = Left(errorApiModel);
    });

    return state;
  }
}

