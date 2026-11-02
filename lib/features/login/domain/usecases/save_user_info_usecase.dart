import 'package:app_health/features/login/domain/repositories/base_login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:app_health/core/failures.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';

class SaveUserInfoUseCase extends BaseUseCase<bool, LoginResponseApiModel> {
  BaseLoginRepository loginRepository;

  SaveUserInfoUseCase(this.loginRepository);

  @override
  Future<Either<Failure, bool>> call(LoginResponseApiModel params) async {
    late Either<Failure, bool> state;
    await loginRepository
        .saveUserInfo(params)
        .then((saved) {
          state = const Right(true);
        })
        .catchError((onError) {
          state = Left(CacheFailure());
        });
    return state;
  }
}
