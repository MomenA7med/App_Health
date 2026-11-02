import 'package:app_health/local_storage/local_storage_utils.dart';
import 'package:app_health/local_storage/preferences_keys.dart';

class LocalStorageManager {
  Future<bool> clearData() async {
    final String? locale = await getLocale();
    await LocalStorageUtils.clearData();
    if (locale != null) await setLocale(locale);

    return true;
  }

  Future<bool> setLocale(String data) async {
    return await LocalStorageUtils.setString(PreferencesKeys.lang.name, data);
  }

  Future<String?> getLocale() async {
    return await LocalStorageUtils.getString(PreferencesKeys.lang.name);
  }

  Future<void> setLoggedIn() async {
    await LocalStorageUtils.setBool(PreferencesKeys.isLoggedIn.name, true);
  }

  Future<void> setLogout() async {
    await LocalStorageUtils.setBool(PreferencesKeys.isLoggedIn.name, false);
  }

  Future<bool> isLoggedIn() async {
    return await LocalStorageUtils.getBool(PreferencesKeys.isLoggedIn.name);
  }

  Future<void> setAccessAndRefreshToken(
    String accessToken,
    String refreshToken,
  ) async {
    await LocalStorageUtils.setString(
      PreferencesKeys.accessToken.name,
      accessToken,
    );
    await LocalStorageUtils.setString(
      PreferencesKeys.refreshToken.name,
      refreshToken,
    );
  }

  Future<String?> getAccessToken() async {
    return await LocalStorageUtils.getString(PreferencesKeys.accessToken.name);
  }

  Future<String?> getRefreshToken() async {
    return await LocalStorageUtils.getString(PreferencesKeys.refreshToken.name);
  }

  Future<String?> getUserId() async {
    return await LocalStorageUtils.getString(PreferencesKeys.userId.name);
  }

  Future<void> setUserId(String userId) async {
    await LocalStorageUtils.setString(PreferencesKeys.userId.name, userId);
  }

  Future<void> setEmail(String data) async {
    await LocalStorageUtils.setString(PreferencesKeys.email.name, data);
  }

  Future<String?> getEmail() async {
    return await LocalStorageUtils.getString(PreferencesKeys.email.name);
  }

  Future<void> setGender(String data) async {
    await LocalStorageUtils.setString(PreferencesKeys.gender.name, data);
  }

  Future<String?> getGender() async {
    return await LocalStorageUtils.getString(PreferencesKeys.gender.name);
  }

  Future<void> setProfileImage(String data) async {
    await LocalStorageUtils.setString(PreferencesKeys.profileImage.name, data);
  }

  Future<String?> getProfileImage() async {
    return await LocalStorageUtils.getString(PreferencesKeys.profileImage.name);
  }

  Future<bool> setIsAllowNotifications(bool data) async {
    return await LocalStorageUtils.setBool(
      PreferencesKeys.isAllowNotifications.name,
      data,
    );
  }

  Future<bool> getIsAllowNotifications() async {
    return await LocalStorageUtils.getBool(
      PreferencesKeys.isAllowNotifications.name,
    );
  }

  Future<String?> getPhone() async {
    return await LocalStorageUtils.getString(PreferencesKeys.phone.name);
  }

  Future<void> setPhone(String phone) async {
    await LocalStorageUtils.setString(PreferencesKeys.phone.name, phone);
  }

  Future<void> setIsGuest() async {
    await LocalStorageUtils.setBool(PreferencesKeys.isGuest.name, true);
  }

  Future<bool> isGuest() async {
    return await LocalStorageUtils.getBool(PreferencesKeys.isGuest.name);
  }

  Future<void> setUserFullNameEn(String data) async {
    await LocalStorageUtils.setString(
      PreferencesKeys.userFullNameEn.name,
      data,
    );
  }

  Future<void> setUserFullNameAr(String data) async {
    await LocalStorageUtils.setString(
      PreferencesKeys.userFullNameAr.name,
      data,
    );
  }

  Future<String?> getUserFullNameEn() async {
    return await LocalStorageUtils.getString(
      PreferencesKeys.userFullNameEn.name,
    );
  }

  Future<void> setUserPosition(String data) async {
    await LocalStorageUtils.setString(PreferencesKeys.position.name, data);
  }

  Future<String?> getUserPosition() async {
    return await LocalStorageUtils.getString(PreferencesKeys.position.name);
  }

  Future<String?> getUserFullNameAr() async {
    return await LocalStorageUtils.getString(
      PreferencesKeys.userFullNameAr.name,
    );
  }
}
