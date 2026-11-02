import 'package:app_health/features/login/data/datasources/login_api_manager.dart';
import 'package:app_health/features/login/data/datasources/login_local_datasources.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/login/data/models/login_send_api_model.dart';
import 'package:app_health/features/login/domain/repositories/base_login_repository.dart';

class LoginRepository implements BaseLoginRepository {
  final LoginLocaleManager loginLocaleManager;
  final LoginApiManager loginApiManager;

  LoginRepository(this.loginLocaleManager, this.loginApiManager);

  @override
  Future<LoginResponseApiModel> login(LoginSendModel login) async {
    late LoginResponseApiModel loginResponse;
    await loginApiManager.loginApi(
      login,
      (response) {
        loginResponse = response;
      },
      (errorApiModel) {
        throw errorApiModel;
      },
    );
    return loginResponse;
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
