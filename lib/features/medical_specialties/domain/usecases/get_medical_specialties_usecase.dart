import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';
import 'package:app_health/features/medical_specialties/domain/repositories/base_medical_specialties_repository.dart';

class GetMedicalSpecialtiesUseCase
    extends BaseUseCase<MedicalSpecialtiesResponseModel, NoParams> {
  final BaseMedicalSpecialtiesRepository repository;

  GetMedicalSpecialtiesUseCase(this.repository);

  @override
  Future<Either<ErrorApiModel, MedicalSpecialtiesResponseModel>> call(
    NoParams params,
  ) async {
    late Either<ErrorApiModel, MedicalSpecialtiesResponseModel> result;
    await repository
        .getMedicalSpecialties()
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

