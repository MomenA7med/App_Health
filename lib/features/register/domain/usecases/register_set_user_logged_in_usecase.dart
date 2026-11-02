import 'package:dartz/dartz.dart';
import 'package:app_health/core/failures.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/register/domain/repositories/base_register_repository.dart';

class RegisterSetUserLoggedInUseCase extends BaseUseCase<bool, NoParams> {
  final BaseRegisterRepository registerRepository;

  RegisterSetUserLoggedInUseCase(this.registerRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    late Either<Failure, bool> state;
    await registerRepository
        .setLoginUser()
        .then((saved) {
          state = const Right(true);
        })
        .catchError((onError) {
          state = Left(CacheFailure());
        });
    return state;
  }
}
