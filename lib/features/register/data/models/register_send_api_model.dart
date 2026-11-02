class RegisterSendModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final int gender;
  final String dateOfBirth;
  final String address;
  final String password;
  final String confirmPassword;
  final bool acceptTerms;

  const RegisterSendModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.password,
    required this.confirmPassword,
    required this.acceptTerms,
  });

  Map<String, dynamic> toMap() {
    return {
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "address": address,
      "password": password,
      "confirmPassword": confirmPassword,
      "acceptTerms": acceptTerms,
    };
  }
}
