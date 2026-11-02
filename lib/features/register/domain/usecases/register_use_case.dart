import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/register/data/models/register_send_api_model.dart';
import 'package:app_health/features/register/domain/repositories/base_register_repository.dart';

class RegisterUseCase
    extends BaseUseCase<LoginResponseApiModel, RegisterSendModel> {
  final BaseRegisterRepository registerRepository;

  RegisterUseCase(this.registerRepository);

  @override
  Future<Either<ErrorApiModel, LoginResponseApiModel>> call(
    RegisterSendModel params,
  ) async {
    late Either<ErrorApiModel, LoginResponseApiModel> state;
    await registerRepository
        .register(params)
        .then((registerResponse) {
          state = Right(registerResponse);
        })
        .catchError((onError) {
          ErrorApiModel errorApiModel = onError as ErrorApiModel;
          state = Left(errorApiModel);
        });
    return state;
  }
}
