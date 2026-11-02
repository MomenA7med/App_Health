import 'dart:convert';
import 'package:app_health/features/login/data/models/user_manager.dart';
import 'package:app_health/preferences/preferences_keys.dart';
import 'package:app_health/utils/preferences/preferences_utils.dart';

class PreferencesManager {

  Future<bool> clearData() async {
    final String? locale = await getLocale();
    await PreferencesUtils.clearData();
    if (locale != null) await setLocale(locale);

    return true;
  }
  Future<void> setSchoolYearId(int id) async {
    await PreferencesUtils.setInt(PreferencesKeys.schoolYearID.name, id);
  }

  Future<int?> getSchoolYearId() async {
    return await PreferencesUtils.getInt(PreferencesKeys.schoolYearID.name);
  }
  Future<void> setOnBoardingShown() async {
    await PreferencesUtils.setBool(PreferencesKeys.onBoardingShow.name, true);
  }

  Future<bool> isOnBoardingShown() async {
    return await PreferencesUtils.getBool(PreferencesKeys.onBoardingShow.name);
  }


  Future<bool> setLocale(String data) async {
    return await PreferencesUtils.setString(PreferencesKeys.lang.name, data);
  }

  Future<String?> getLocale() async {
    return await PreferencesUtils.getString(PreferencesKeys.lang.name);
  }

  Future<void> setLoggedIn() async {
    await PreferencesUtils.setBool(PreferencesKeys.isLoggedIn.name, true);
  }

  Future<void> setLogout() async {
    await PreferencesUtils.setBool(PreferencesKeys.isLoggedIn.name, false);
  }

  Future<bool> isLoggedIn() async {
    return await PreferencesUtils.getBool(PreferencesKeys.isLoggedIn.name);
  }

  Future<void> setIsLocaleEmarat(bool data) async {
    await PreferencesUtils.setBool(PreferencesKeys.isLocaleEmarat.name, data);
  }

  Future<bool> isLocaleEmarat() async {
    return await PreferencesUtils.getBool(PreferencesKeys.isLocaleEmarat.name);
  }

  Future<void> setAccessToken(String accessToken) async {
    await PreferencesUtils.setString(
      PreferencesKeys.accessToken.name,
      accessToken,
    );
  }

  Future<String?> getAccessToken() async {
    return await PreferencesUtils.getString(PreferencesKeys.accessToken.name);
  }

  Future<String?> getRefreshToken() async {
    return await PreferencesUtils.getString(PreferencesKeys.refreshToken.name);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await PreferencesUtils.setString(
      PreferencesKeys.refreshToken.name,
      refreshToken,
    );
  }

  Future<String?> getUserId() async {
    return await PreferencesUtils.getString(PreferencesKeys.userId.name);
  }

  Future<void> setUserId(String userId) async {
    await PreferencesUtils.setString(PreferencesKeys.userId.name, userId);
  }

  Future<void> setEmail(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.email.name, data);
  }

  Future<String?> getEmail() async {
    return await PreferencesUtils.getString(PreferencesKeys.email.name);
  }

  Future<void> setProfileImage(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.profileImage.name, data);
  }

  Future<String?> getProfileImage() async {
    return await PreferencesUtils.getString(PreferencesKeys.profileImage.name);
  }

  Future<String?> getPhone() async {
    return await PreferencesUtils.getString(PreferencesKeys.phone.name);
  }

  Future<void> setPhone(String phone) async {
    await PreferencesUtils.setString(PreferencesKeys.phone.name, phone);
  }

  Future<void> setCreatedDate(String createdDate) async {
    await PreferencesUtils.setString(PreferencesKeys.createdDate.name, createdDate);
  }

  Future<String?> getCreatedDate() async {
    return await PreferencesUtils.getString(PreferencesKeys.createdDate.name);
  }

  Future<void> setIsGuest() async {
    await PreferencesUtils.setBool(PreferencesKeys.isGuest.name, true);
  }

  Future<bool> isGuest() async {
    return await PreferencesUtils.getBool(PreferencesKeys.isGuest.name);
  }

  Future<void> setUserFullNameEn(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.userFullNameEn.name, data);
  }

  Future<void> setUserFullNameAr(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.userFullNameAr.name, data);
  }

  Future<String?> getUserFullNameEn() async {
    return await PreferencesUtils.getString(
      PreferencesKeys.userFullNameEn.name,
    );
  }

  Future<void> setUserPosition(String data) async {
    await PreferencesUtils.setString(PreferencesKeys.position.name, data);
  }

  Future<String?> getUserPosition() async {
    return await PreferencesUtils.getString(PreferencesKeys.position.name);
  }

  Future<String?> getUserFullNameAr() async {
    return await PreferencesUtils.getString(
      PreferencesKeys.userFullNameAr.name,
    );
  }


  Future<void> setUserObject(UserManager user) async {
  final userJson = jsonEncode(user.toJson());
  await PreferencesUtils.setString(PreferencesKeys.userObject.name, userJson);
}

  Future<UserManager?> getUserObject() async {
    final userJsonString = await PreferencesUtils.getString(PreferencesKeys.userObject.name);
    if (userJsonString == null) return null;

    try {
      final userJson = jsonDecode(userJsonString) as Map<String, dynamic>;
      return UserManager.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  Future<void> setIdType(String idType) async {
    await PreferencesUtils.setString(PreferencesKeys.idType.name, idType);
  }

  Future<void> setUserType(String userType) async {
    await PreferencesUtils.setString(PreferencesKeys.userType.name, userType);
  }

  Future<void> setUuid(String uuid) async {
    await PreferencesUtils.setString(PreferencesKeys.uuid.name, uuid);
  }

  Future<void> setNationalityId(int nationalityId) async {
    await PreferencesUtils.setInt(PreferencesKeys.nationalityId.name, nationalityId);
  }

  Future<void> setGender(String gender) async {
    await PreferencesUtils.setString(PreferencesKeys.gender.name, gender);
  }

  Future<void> setEmiratesIdNumber(String emiratesIdNumber) async {
    await PreferencesUtils.setString(PreferencesKeys.emiratesIdNumber.name, emiratesIdNumber);
  }

  Future<void> setUaePassToken(String token) async {
    await PreferencesUtils.setString(PreferencesKeys.uaePassToken.name, token);
  }

  Future<void> setScope(String scope) async {
    await PreferencesUtils.setString(PreferencesKeys.scope.name, scope);
  }

  Future<void> setBirthDate(String birthDate) async {
    await PreferencesUtils.setString(PreferencesKeys.birthDate.name, birthDate);
  }

  Future<void> setClaims(String claims) async {
    await PreferencesUtils.setString(PreferencesKeys.claims.name, claims);
  }
  Future<String?> getIdType() async {
    return await PreferencesUtils.getString(PreferencesKeys.idType.name);
  }

  Future<String?> getUserType() async {
    return await PreferencesUtils.getString(PreferencesKeys.userType.name);
  }

  Future<String?> getUuid() async {
    return await PreferencesUtils.getString(PreferencesKeys.uuid.name);
  }

  Future<int?> getNationalityId() async {
    return await PreferencesUtils.getInt(PreferencesKeys.nationalityId.name);
  }

  Future<String?> getGender() async {
    return await PreferencesUtils.getString(PreferencesKeys.gender.name);
  }

  Future<String?> getEmiratesIdNumber() async {
    return await PreferencesUtils.getString(PreferencesKeys.emiratesIdNumber.name);
  }

  Future<String?> getUaePassToken() async {
    return await PreferencesUtils.getString(PreferencesKeys.uaePassToken.name);
  }

  Future<String?> getScope() async {
    return await PreferencesUtils.getString(PreferencesKeys.scope.name);
  }

  Future<String?> getBirthDate() async {
    return await PreferencesUtils.getString(PreferencesKeys.birthDate.name);
  }

  Future<String?> getClaims() async {
    return await PreferencesUtils.getString(PreferencesKeys.claims.name);
  }
  Future<String?> getServiceProviderUuid() async {
    return await PreferencesUtils.getString(PreferencesKeys.serviceProviderUuid.name);
  }

  Future<void> setServiceProviderUuid(String uuid) async {
    await PreferencesUtils.setString(PreferencesKeys.serviceProviderUuid.name, uuid);
  }
  Future<void> setFirstNameEn(String value) async =>
      await PreferencesUtils.setString(PreferencesKeys.firstNameEn.name, value);

  Future<void> setFirstNameAr(String value) async =>
      await PreferencesUtils.setString(PreferencesKeys.firstNameAr.name, value);

  Future<String?> getFirstNameEn() async =>
      await PreferencesUtils.getString(PreferencesKeys.firstNameEn.name);

  Future<String?> getFirstNameAr() async =>
      await PreferencesUtils.getString(PreferencesKeys.firstNameAr.name);

  Future<void> setLastNameEn(String value) async =>
      await PreferencesUtils.setString(PreferencesKeys.lastNameEn.name, value);

  Future<void> setLastNameAr(String value) async =>
      await PreferencesUtils.setString(PreferencesKeys.lastNameAr.name, value);

  Future<String?> getLastNameEn() async =>
      await PreferencesUtils.getString(PreferencesKeys.lastNameEn.name);

  Future<String?> getLastNameAr() async =>
      await PreferencesUtils.getString(PreferencesKeys.lastNameAr.name);

  Future<void> setTitleEn(String value) async =>
      await PreferencesUtils.setString(PreferencesKeys.titleEn.name, value);

  Future<void> setTitleAr(String value) async =>
      await PreferencesUtils.setString(PreferencesKeys.titleAr.name, value);

  Future<String?> getTitleEn() async =>
      await PreferencesUtils.getString(PreferencesKeys.titleEn.name);

  Future<String?> getTitleAr() async =>
      await PreferencesUtils.getString(PreferencesKeys.titleAr.name);

  Future<void> setNationalityEn(String value) async =>
      await PreferencesUtils.setString(PreferencesKeys.nationalityEn.name, value);

  Future<void> setNationalityAr(String value) async =>
      await PreferencesUtils.setString(PreferencesKeys.nationalityAr.name, value);

  Future<String?> getNationalityEn() async =>
      await PreferencesUtils.getString(PreferencesKeys.nationalityEn.name);

  Future<String?> getNationalityAr() async =>
      await PreferencesUtils.getString(PreferencesKeys.nationalityAr.name);

}
