import 'package:app_health/apis/api_urls.dart';
import 'package:app_health/flavor_config/app_config_utils.dart';
import 'package:app_health/local_storage/local_storage_manager.dart';
import 'package:app_health/utils/extensions/extension_string.dart';
import 'package:app_health/utils/locale/locale_cubit.dart';

class UserMangers {
  final LocalStorageManager localStorageManager;

  UserMangers(this.localStorageManager);

  bool _isGustUser = true;
  String _nameEn = '';
  String _nameAr = '';
  String _profileImageUrl = '';
  String _email = '';
  String _gender = '';
  String _position = '';
  String _phoneNumber = '';
  String? token;
  String? refreshToken;
  String _userId = '';
  String _token = '';
  LocaleApp _localeApp = LocaleApp.en;

  bool isGustUser() {
    return _isGustUser;
  }

  bool isLoggedIn() {
    return !_isGustUser;
  }

  String getUserName(bool isEnglish) {
    return isEnglish ? _nameEn : _nameAr;
  }

  void setUserName({required String userNameEn, required String userNameAr}) {
    _nameEn = userNameEn;
    _nameAr = userNameAr;
  }

  void setProfileImageUrl(String profileImageUrl) {
    _profileImageUrl = profileImageUrl;
  }

  String get profileImageUrl {
    if (_profileImageUrl.isNotNullOrNotEmpty) {
      return "${AppConfigUtils.baseUrl}${ApiUrls.downloadFile}/$_profileImageUrl";
    }
    return _profileImageUrl;
  }

  String getUserId() {
    return _userId;
  }

  void setUserId(String userId) {
    _userId = userId;
  }

  void setEmail(String email) {
    _email = email;
  }

  String getEmail() {
    return _email;
  }

  void setGender(String gender) {
    _gender = gender;
  }

  String getGender() {
    return _gender;
  }

  void setPosition(String position) {
    _position = position;
  }

  String getPosition() {
    return _position;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  String getPhoneNumber() {
    return _phoneNumber;
  }

  void setLoggedInUser() {
    _isGustUser = false;
  }

  void setAsGuestUser() {
    _isGustUser = true;
  }

  String getToken() {
    return _token;
  }

  void setToken(String token) {
    _token = token;
  }

  void setLocaleApp(LocaleApp localeApp) {
    _localeApp = localeApp;
  }

  LocaleApp getLocaleApp() {
    return _localeApp;
  }

  Future<void> fetchUserInfoFromLocal() async {
    _isGustUser = !await localStorageManager.isLoggedIn();
    _nameEn = await localStorageManager.getUserFullNameEn() ?? '';
    _nameAr = await localStorageManager.getUserFullNameAr() ?? '';
    _phoneNumber = await localStorageManager.getPhone() ?? '';
    _email = await localStorageManager.getEmail() ?? '';
    _gender = await localStorageManager.getGender() ?? '';
    _profileImageUrl = await localStorageManager.getProfileImage() ?? '';
    _userId = await localStorageManager.getUserId() ?? '';
  }

  Future<void> signOut() async {
    _isGustUser = true;
    _nameEn = '';
    _nameAr = '';
    _phoneNumber = '';
    _email = '';
    _gender = '';
    _profileImageUrl = '';
    token = "";
    refreshToken = "";
    _userId = "";

    localStorageManager.clearData();
    localStorageManager.setLogout();
    //TODO
    // AppRouter.mainNavigatorKey.currentContext?.go(LoginScreen.routeName);
  }
}
