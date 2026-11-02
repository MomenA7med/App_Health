import 'package:dartz/dartz.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/login/data/models/login_send_api_model.dart';
import 'package:app_health/features/login/data/repository/login_repository.dart';

class LoginUseCase extends BaseUseCase<LoginResponseApiModel, LoginSendModel> {
  LoginRepository loginRepository;

  LoginUseCase(this.loginRepository);

  @override
  Future<Either<ErrorApiModel, LoginResponseApiModel>> call(
    LoginSendModel params,
  ) async {
    late Either<ErrorApiModel, LoginResponseApiModel> state;
    await loginRepository
        .login(params)
        .then((loginResponse) {
          state = Right(loginResponse);
        })
        .catchError((onError) {
          ErrorApiModel errorApiModel = onError as ErrorApiModel;
          state = Left(errorApiModel);
        });
    return state;
  }
}
