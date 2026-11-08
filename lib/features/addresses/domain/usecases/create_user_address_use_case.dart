import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/failures.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/addresses/data/models/create_address_send_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/addresses/domain/repositories/base_addresses_repository.dart';

class CreateUserAddressUseCase
    extends BaseUseCase<CreateAddressResponseModel, CreateAddressSendModel> {
  final BaseAddressesRepository repository;

  CreateUserAddressUseCase(this.repository);

  @override
  Future<Either<Failure, CreateAddressResponseModel>> call(
    CreateAddressSendModel params,
  ) async {
    try {
      final response = await repository.createUserAddressApi(params);
      return Right(response);
    } catch (onError) {
      final ErrorApiModel errorApiModel = onError is ErrorApiModel
          ? onError
          : ErrorApiModel.identifyError(error: onError);
      return Left(errorApiModel);
    }
  }
}

