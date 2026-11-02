import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/apis/api_urls.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/register/data/models/register_send_api_model.dart';

class RegisterApiManager {
  final DioApiManager dioApiManager;

  RegisterApiManager(this.dioApiManager);

  Future<void> registerApi(
    RegisterSendModel sendModel,
    void Function(LoginResponseApiModel) success,
    void Function(ErrorApiModel) fail,
  ) async {
    await dioApiManager.dioUnauthorized
        .post(ApiUrls.register, data: sendModel.toMap())
        .then((response) {
          Map<String, dynamic> extractedData =
              response.data as Map<String, dynamic>;
          LoginResponseApiModel wrapper = LoginResponseApiModel.fromJson(
            extractedData,
          );
          success(wrapper);
        })
        .catchError((error) {
          fail(ErrorApiModel.identifyError(error: error));
        });
  }
}
