import 'package:app_health/features/login/domain/repositories/base_login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:app_health/core/failures.dart';
import 'package:app_health/core/usecase.dart';

class SetUserLoggedInUseCase extends BaseUseCase<bool, NoParams> {
  BaseLoginRepository loginRepository;
  SetUserLoggedInUseCase(this.loginRepository);
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    late Either<Failure, bool> state;
    await loginRepository
        .setLoginUser()
        .then((success) {
          state = const Right(true);
        })
        .catchError((onError) {
          state = Left(CacheFailure());
        });
    return state;
  }
}
