import 'dart:convert';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/preferences/preferences_keys.dart';
import 'package:app_health/utils/preferences/preferences_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/logic/user_manager.dart';
import 'package:app_health/preferences/preferences_manager.dart';

class LoginLocaleManager {
  final PreferencesManager preferencesManager;

  LoginLocaleManager(this.preferencesManager);

  final UserMangers userMangers = GetIt.I<UserMangers>();

  Future<void> setUserLogin() async {
    await preferencesManager.setLoggedIn();
    userMangers.setLoggedInUser();
  }

  Future<void> saveUserInfo(LoginResponseApiModel loginResponseModel) async {
    final data = loginResponseModel.data;
    if (data == null) return;

    // Save token
    await preferencesManager.setAccessToken(data.accessToken);

    // Save user ID
    final String userId = data.userId.isNotEmpty
        ? data.userId
        : (data.profile?.userId ?? '');
    if (userId.isNotEmpty) {
      await preferencesManager.setUserId(userId);
      userMangers.setUserId(userId);
    }

    final profile = data.profile;
    if (profile != null) {
      // Save full name
      if (profile.fullName.isNotEmpty) {
        await preferencesManager.setUserFullNameEn(profile.fullName);
        await preferencesManager.setUserFullNameAr(profile.fullName);
        userMangers.setUserName(
          userNameEn: profile.fullName,
          userNameAr: profile.fullName,
        );
      }

      // Save email
      if (profile.email.isNotEmpty) {
        await preferencesManager.setEmail(profile.email);
        userMangers.setEmail(profile.email);
      }

      // Save phone
      if (profile.phoneNumber != null && profile.phoneNumber!.isNotEmpty) {
        await preferencesManager.setPhone(profile.phoneNumber!);
        userMangers.setPhoneNumber(profile.phoneNumber!);
      }

      // Save profile image
      if (profile.profilePhotoUrl != null &&
          profile.profilePhotoUrl!.isNotEmpty) {
        await preferencesManager.setProfileImage(profile.profilePhotoUrl!);
        userMangers.setProfileImageUrl(profile.profilePhotoUrl!);
      }

      // Save profile JSON
      await PreferencesUtils.setString(
        PreferencesKeys.userObject.name,
        jsonEncode(profile.toJson()),
      );
    }
  }
}
