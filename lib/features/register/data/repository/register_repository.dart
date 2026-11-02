import 'package:app_health/features/login/data/datasources/login_local_datasources.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/register/data/datasources/register_api_manager.dart';
import 'package:app_health/features/register/data/models/register_send_api_model.dart';
import 'package:app_health/features/register/domain/repositories/base_register_repository.dart';

class RegisterRepository implements BaseRegisterRepository {
  final LoginLocaleManager loginLocaleManager;
  final RegisterApiManager registerApiManager;

  RegisterRepository(this.loginLocaleManager, this.registerApiManager);

  @override
  Future<LoginResponseApiModel> register(RegisterSendModel register) async {
    late LoginResponseApiModel registerResponse;
    await registerApiManager.registerApi(
      register,
      (response) {
        registerResponse = response;
      },
      (errorApiModel) {
        throw errorApiModel;
      },
    );
    return registerResponse;
  }

  @override
  Future<void> setLoginUser() async {
    await loginLocaleManager.setUserLogin();
  }

  @override
  Future<void> saveUserInfo(LoginResponseApiModel loginResponseModel) async {
    await loginLocaleManager.saveUserInfo(loginResponseModel);
  }
}
