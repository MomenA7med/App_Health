import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/hospital_details/data/models/hospital_profile_response_model.dart';
import 'package:app_health/features/hospital_details/domain/repositories/base_hospital_details_repository.dart';

class GetHospitalProfileUseCase
    extends BaseUseCase<HospitalProfileResponseModel, String> {
  final BaseHospitalDetailsRepository repository;

  GetHospitalProfileUseCase(this.repository);

  @override
  Future<Either<ErrorApiModel, HospitalProfileResponseModel>> call(
    String params,
  ) async {
    late Either<ErrorApiModel, HospitalProfileResponseModel> state;
    await repository.getHospitalProfile(params).then((profile) {
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

