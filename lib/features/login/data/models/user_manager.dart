
class UserManager {
  final String scope;
  final dynamic ownerId;
  final String fullName;
  final String arabicFullName;
  final dynamic photoPath;
  final DateTime lastLoginDate;
  final DateTime createdDate;
  final String createdBy;
  final DateTime updatedDate;
  final dynamic updatedBy;
  final bool isActive;
  final bool isAdUser;
  final int id;
  final String userName;
  final String email;
  final bool emailConfirmed;
  final String phoneNumber;


  UserManager({
    required this.scope,
    required this.ownerId,
    required this.fullName,
    required this.arabicFullName,
    required this.photoPath,
    required this.lastLoginDate,
    required this.createdDate,
    required this.createdBy,
    required this.updatedDate,
    required this.updatedBy,
    required this.isActive,
    required this.isAdUser,
    required this.id,
    required this.userName,
    required this.email,
    required this.emailConfirmed,
    required this.phoneNumber,

  });

  // Builds a User from the UAEPASS auth result, which omits most user fields
  // (dates, roles, photo, etc.). Those are filled with safe defaults.
  
  factory UserManager.fromJson(Map<String, dynamic> json) {
    return UserManager(
      scope: json['scope'] as String,
      ownerId: json['ownerId'],
      fullName: json['fullName'] as String,
      arabicFullName: json['arabicFullName'] as String,
      photoPath: json['photoPath'],
      lastLoginDate: DateTime.parse(json['lastLoginDate']),
      createdDate: DateTime.parse(json['createdDate']),
      createdBy: json['createdBy'] as String,
      updatedDate: DateTime.parse(json['updatedDate']),
      updatedBy: json['updatedBy'],
      isActive: json['isActive'] as bool,
      isAdUser: json['isADUser'] as bool,
      id: json['id'] as int,
      userName: json['userName'] as String,
      email: json['email'] as String,
      emailConfirmed: json['emailConfirmed'] as bool,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scope': scope,
      'ownerId': ownerId,
      'fullName': fullName,
      'arabicFullName': arabicFullName,
      'photoPath': photoPath,
      'lastLoginDate': lastLoginDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'createdBy': createdBy,
      'updatedDate': updatedDate.toIso8601String(),
      'updatedBy': updatedBy,
      'isActive': isActive,
      'isADUser': isAdUser,
      'id': id,
      'userName': userName,
      'email': email,
      'emailConfirmed': emailConfirmed,
      'phoneNumber': phoneNumber,
    };
  }
}
