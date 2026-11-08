import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/failures.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/addresses/domain/repositories/base_addresses_repository.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';

class GetAddressGovernoratesUseCase
    extends BaseUseCase<GovernoratesResponseModel, NoParams> {
  final BaseAddressesRepository repository;

  GetAddressGovernoratesUseCase(this.repository);

  @override
  Future<Either<Failure, GovernoratesResponseModel>> call(
    NoParams params,
  ) async {
    try {
      final response = await repository.getGovernoratesApi();
      return Right(response);
    } catch (onError) {
      final ErrorApiModel errorApiModel = onError is ErrorApiModel
          ? onError
          : ErrorApiModel.identifyError(error: onError);
      return Left(errorApiModel);
    }
  }
}

