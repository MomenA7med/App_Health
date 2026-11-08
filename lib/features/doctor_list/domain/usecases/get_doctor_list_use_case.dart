import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_list_send_model.dart';
import 'package:app_health/features/doctor_list/domain/entities/doctor_lists_ui_response.dart';
import 'package:app_health/features/doctor_list/domain/repositories/base_doctor_list_repository.dart';

class GetDoctorListsUseCase
    extends BaseUseCase<DoctorListsUiResponse, DoctorListSendModel> {
  final BaseDoctorListRepository doctorListRepository;

  GetDoctorListsUseCase(this.doctorListRepository);

  @override
  Future<Either<ErrorApiModel, DoctorListsUiResponse>> call(
      DoctorListSendModel params) async {
    late Either<ErrorApiModel, DoctorListsUiResponse> state;

    await doctorListRepository.getDoctorListsApi(params).then((doctorList) {
      DoctorListsUiResponse doctorListResponse =
          DoctorListsUiResponse.fromApiModel(doctorList);

      state = Right(doctorListResponse);
    }).catchError((onError) {
      ErrorApiModel errorApiModel = onError is ErrorApiModel
          ? onError
          : ErrorApiModel.identifyError(error: onError);
      state = Left(errorApiModel);
    });

    return state;
  }
}

