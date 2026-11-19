import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/pharmacy_details/data/models/pharmacy_profile_response_model.dart';
import 'package:app_health/features/pharmacy_details/domain/repositories/base_pharmacy_details_repository.dart';

class GetPharmacyProfileUseCase
    extends BaseUseCase<PharmacyProfileResponseModel, String> {
  final BasePharmacyDetailsRepository repository;

  GetPharmacyProfileUseCase(this.repository);

  @override
  Future<Either<ErrorApiModel, PharmacyProfileResponseModel>> call(
    String params,
  ) async {
    late Either<ErrorApiModel, PharmacyProfileResponseModel> state;
    await repository.getPharmacyProfile(params).then((profile) {
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

