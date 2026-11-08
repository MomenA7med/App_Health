import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/features/doctor_details/domain/repositories/base_doctor_details_repository.dart';

class GetDoctorProfileUseCase
    extends BaseUseCase<DoctorProfileResponseModel, String> {
  final BaseDoctorDetailsRepository repository;

  GetDoctorProfileUseCase(this.repository);

  @override
  Future<Either<ErrorApiModel, DoctorProfileResponseModel>> call(
    String params,
  ) async {
    late Either<ErrorApiModel, DoctorProfileResponseModel> state;
    await repository.getDoctorProfileApi(params).then((profile) {
      state = Right(profile);
    }).catchError((onError) {
      final ErrorApiModel errorApiModel = onError is ErrorApiModel
          ? onError
          : ErrorApiModel.identifyError(error: onError);
      state = Left(errorApiModel);
    });
    return state;
  }
}

