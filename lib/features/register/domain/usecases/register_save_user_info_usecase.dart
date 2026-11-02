import 'package:dartz/dartz.dart';
import 'package:app_health/core/failures.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/register/domain/repositories/base_register_repository.dart';

class RegisterSaveUserInfoUseCase
    extends BaseUseCase<bool, LoginResponseApiModel> {
  final BaseRegisterRepository registerRepository;

  RegisterSaveUserInfoUseCase(this.registerRepository);

  @override
  Future<Either<Failure, bool>> call(LoginResponseApiModel params) async {
    late Either<Failure, bool> state;
    await registerRepository
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
