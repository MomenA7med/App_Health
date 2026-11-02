
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/login/data/models/login_send_api_model.dart';

abstract class BaseLoginRepository {
  Future<LoginResponseApiModel> login(LoginSendModel login);
  Future<void> setLoginUser();
  Future<void> saveUserInfo(LoginResponseApiModel loginResponseModel);
}
