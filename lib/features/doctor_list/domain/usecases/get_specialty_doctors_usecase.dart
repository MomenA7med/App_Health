import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/features/doctor_list/domain/repositories/base_doctor_list_repository.dart';

class GetSpecialtyDoctorsParams extends Equatable {
  final String specialtyId;
  final Map<String, dynamic>? queryParameters;

  const GetSpecialtyDoctorsParams({
    required this.specialtyId,
    this.queryParameters,
  });

  @override
  List<Object?> get props => [specialtyId, queryParameters];
}

class GetSpecialtyDoctorsUseCase
    extends BaseUseCase<SpecialtyDoctorsResponseModel, GetSpecialtyDoctorsParams> {
  final BaseDoctorListRepository repository;

  GetSpecialtyDoctorsUseCase(this.repository);

  @override
  Future<Either<ErrorApiModel, SpecialtyDoctorsResponseModel>> call(
    GetSpecialtyDoctorsParams params,
  ) async {
    late Either<ErrorApiModel, SpecialtyDoctorsResponseModel> result;
    await repository
        .getSpecialtyDoctors(
          specialtyId: params.specialtyId,
          queryParameters: params.queryParameters,
        )
        .then((response) {
          result = Right(response);
        })
        .catchError((error) {
          final ErrorApiModel errorApiModel = error is ErrorApiModel
              ? error
              : ErrorApiModel.identifyError(error: error);
          result = Left(errorApiModel);
        });
    return result;
  }
}

