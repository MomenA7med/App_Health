class DoctorProfileResponseModel {
  final bool success;
  final String code;
  final String message;
  final DoctorProfileModel data;

  const DoctorProfileResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory DoctorProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: DoctorProfileModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'code': code,
        'message': message,
        'data': data.toJson(),
      };
}

class DoctorProfileModel {
  final String id;
  final String specialtyId;
  final String name;
  final String specializationTitle;
  final double ratingAverage;
  final int totalReviews;
  final String clinicName;
  final String clinicAddress;
  final String? locationType;
  final String? cityLocation;
  final String? area;
  final String? areaId;
  final String? governorateId;
  final double? distanceKm;
  final String? phoneNumber;
  final String? aboutText;
  final List<String> qualifications;
  final String? workingHours;
  final String? imageUrl;
  final bool isFavorite;
  final bool acceptsPatientInsurance;
  final List<String> acceptedInsuranceCompanies;

  const DoctorProfileModel({
    required this.id,
    required this.specialtyId,
    required this.name,
    required this.specializationTitle,
    required this.ratingAverage,
    required this.totalReviews,
    required this.clinicName,
    required this.clinicAddress,
    this.locationType,
    this.cityLocation,
    this.area,
    this.areaId,
    this.governorateId,
    this.distanceKm,
    this.phoneNumber,
    this.aboutText,
    this.qualifications = const [],
    this.workingHours,
    this.imageUrl,
    this.isFavorite = false,
    this.acceptsPatientInsurance = false,
    this.acceptedInsuranceCompanies = const [],
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
      id: json['id'] as String? ?? '',
      specialtyId: json['specialtyId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      specializationTitle: json['specializationTitle'] as String? ?? '',
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      clinicName: json['clinicName'] as String? ?? '',
      clinicAddress: json['clinicAddress'] as String? ?? '',
      locationType: json['locationType'] as String?,
      cityLocation: json['cityLocation'] as String?,
      area: json['area'] as String?,
      areaId: json['areaId'] as String?,
      governorateId: json['governorateId'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      phoneNumber: json['phoneNumber'] as String?,
      aboutText: json['aboutText'] as String?,
      qualifications: (json['qualifications'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      workingHours: json['workingHours'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      acceptsPatientInsurance:
          json['acceptsPatientInsurance'] as bool? ?? false,
      acceptedInsuranceCompanies:
          (json['acceptedInsuranceCompanies'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'specialtyId': specialtyId,
        'name': name,
        'specializationTitle': specializationTitle,
        'ratingAverage': ratingAverage,
        'totalReviews': totalReviews,
        'clinicName': clinicName,
        'clinicAddress': clinicAddress,
        'locationType': locationType,
        'cityLocation': cityLocation,
        'area': area,
        'areaId': areaId,
        'governorateId': governorateId,
        'distanceKm': distanceKm,
        'phoneNumber': phoneNumber,
        'aboutText': aboutText,
        'qualifications': qualifications,
        'workingHours': workingHours,
        'imageUrl': imageUrl,
        'isFavorite': isFavorite,
        'acceptsPatientInsurance': acceptsPatientInsurance,
        'acceptedInsuranceCompanies': acceptedInsuranceCompanies,
      };

  DoctorProfileModel copyWith({
    String? id,
    String? specialtyId,
    String? name,
    String? specializationTitle,
    double? ratingAverage,
    int? totalReviews,
    String? clinicName,
    String? clinicAddress,
    String? locationType,
    String? cityLocation,
    String? area,
    String? areaId,
    String? governorateId,
    double? distanceKm,
    String? phoneNumber,
    String? aboutText,
    List<String>? qualifications,
    String? workingHours,
    String? imageUrl,
    bool? isFavorite,
    bool? acceptsPatientInsurance,
    List<String>? acceptedInsuranceCompanies,
  }) {
    return DoctorProfileModel(
      id: id ?? this.id,
      specialtyId: specialtyId ?? this.specialtyId,
      name: name ?? this.name,
      specializationTitle: specializationTitle ?? this.specializationTitle,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      totalReviews: totalReviews ?? this.totalReviews,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      locationType: locationType ?? this.locationType,
      cityLocation: cityLocation ?? this.cityLocation,
      area: area ?? this.area,
      areaId: areaId ?? this.areaId,
      governorateId: governorateId ?? this.governorateId,
      distanceKm: distanceKm ?? this.distanceKm,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      aboutText: aboutText ?? this.aboutText,
      qualifications: qualifications ?? this.qualifications,
      workingHours: workingHours ?? this.workingHours,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      acceptsPatientInsurance:
          acceptsPatientInsurance ?? this.acceptsPatientInsurance,
      acceptedInsuranceCompanies:
          acceptedInsuranceCompanies ?? this.acceptedInsuranceCompanies,
    );
  }
}

