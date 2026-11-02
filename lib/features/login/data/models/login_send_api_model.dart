class LoginSendModel {
  final String userName;
  final String password;

  LoginSendModel({required this.userName, required this.password});
  Map<String, dynamic> toMap() {
    return {"email": userName, "password": password};
  }
}
