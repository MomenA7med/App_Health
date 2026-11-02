class LoginResponseApiModel {
  final bool success;
  final String code;
  final String message;
  final LoginDataModel? data;

  LoginResponseApiModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory LoginResponseApiModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseApiModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? LoginDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'message': message,
      'data': data?.toJson(),
    };
  }

  // Convenience getters
  String get token => data?.accessToken ?? '';
  DateTime? get expires => data?.expiresAt;
}

class LoginDataModel {
  final String accessToken;
  final DateTime? expiresAt;
  final String userId;
  final int role;
  final bool requiresProfileCompletion;
  final List<String> missingFields;
  final UserProfileModel? profile;

  LoginDataModel({
    required this.accessToken,
    this.expiresAt,
    required this.userId,
    required this.role,
    required this.requiresProfileCompletion,
    required this.missingFields,
    this.profile,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      accessToken: json['accessToken'] as String? ?? '',
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
      userId: json['userId'] as String? ?? '',
      role: (json['role'] as num?)?.toInt() ?? 0,
      requiresProfileCompletion:
          json['requiresProfileCompletion'] as bool? ?? false,
      missingFields: (json['missingFields'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      profile: json['profile'] != null
          ? UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiresAt': expiresAt?.toIso8601String(),
      'userId': userId,
      'role': role,
      'requiresProfileCompletion': requiresProfileCompletion,
      'missingFields': missingFields,
      'profile': profile?.toJson(),
    };
  }
}

class UserProfileModel {
  final String userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final int? gender;
  final String? dateOfBirth;
  final String? address;
  final String? profilePhotoUrl;

  UserProfileModel({
    required this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.profilePhotoUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      dateOfBirth: json['dateOfBirth'] as String?,
      address: json['address'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'address': address,
      'profilePhotoUrl': profilePhotoUrl,
    };
  }
}

typedef LoginData = LoginDataModel;
typedef UserProfile = UserProfileModel;
