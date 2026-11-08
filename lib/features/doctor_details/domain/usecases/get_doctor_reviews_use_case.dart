import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';
import 'package:app_health/features/doctor_details/domain/repositories/base_doctor_details_repository.dart';

class GetDoctorReviewsUseCase
    extends BaseUseCase<DoctorReviewsResponseModel, String> {
  final BaseDoctorDetailsRepository repository;

  GetDoctorReviewsUseCase(this.repository);

  @override
  Future<Either<ErrorApiModel, DoctorReviewsResponseModel>> call(
    String params,
  ) async {
    late Either<ErrorApiModel, DoctorReviewsResponseModel> state;
    await repository.getDoctorReviewsApi(params).then((reviews) {
      state = Right(reviews);
    }).catchError((onError) {
      final ErrorApiModel errorApiModel = onError is ErrorApiModel
          ? onError
          : ErrorApiModel.identifyError(error: onError);
      state = Left(errorApiModel);
    });
    return state;
  }
}

