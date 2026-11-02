import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/register/data/models/register_send_api_model.dart';

abstract class BaseRegisterRepository {
  Future<LoginResponseApiModel> register(RegisterSendModel register);
  Future<void> setLoginUser();
  Future<void> saveUserInfo(LoginResponseApiModel loginResponseModel);
}
