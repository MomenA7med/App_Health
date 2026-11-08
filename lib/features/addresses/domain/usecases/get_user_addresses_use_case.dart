import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/failures.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/addresses/domain/repositories/base_addresses_repository.dart';

class GetUserAddressesUseCase
    extends BaseUseCase<UserAddressesResponseModel, NoParams> {
  final BaseAddressesRepository repository;

  GetUserAddressesUseCase(this.repository);

  @override
  Future<Either<Failure, UserAddressesResponseModel>> call(
    NoParams params,
  ) async {
    try {
      final response = await repository.getUserAddressesApi();
      return Right(response);
    } catch (onError) {
      final ErrorApiModel errorApiModel = onError is ErrorApiModel
          ? onError
          : ErrorApiModel.identifyError(error: onError);
      return Left(errorApiModel);
    }
  }
}

