import 'package:equatable/equatable.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';
import 'package:app_health/features/pharmacy_details/data/models/pharmacy_branch_model.dart';

class PharmacyProfileResponseModel extends Equatable {
  final bool success;
  final String code;
  final String message;
  final PharmacyProfileModel data;

  const PharmacyProfileResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory PharmacyProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return PharmacyProfileResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: PharmacyProfileModel.fromJson(
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

  @override
  List<Object?> get props => [success, code, message, data];
}

class PharmacyProfileModel extends Equatable {
  final String id;
  final String name;
  final String? branchName;
  final double ratingAverage;
  final int totalReviews;
  final String address;
  final double distanceKm;
  final String workingHoursStatus;
  final bool isTwentyFourHours;
  final bool isOpenNow;
  final String aboutText;
  final String governorateId;
  final String governorateName;
  final String areaId;
  final String areaName;
  final bool isFavorite;
  final bool acceptsPatientInsurance;
  final String? coverUrl;
  final String? logoUrl;
  final String? phone;
  final List<PharmacyBranchModel> branches;
  final List<InsuranceCompanyModel> acceptedInsuranceCompanies;
  final DoctorReviewsDataModel? reviews;

  const PharmacyProfileModel({
    required this.id,
    required this.name,
    this.branchName,
    this.ratingAverage = 0.0,
    this.totalReviews = 0,
    this.address = '',
    this.distanceKm = 0.0,
    this.workingHoursStatus = '',
    this.isTwentyFourHours = false,
    this.isOpenNow = false,
    this.aboutText = '',
    this.governorateId = '',
    this.governorateName = '',
    this.areaId = '',
    this.areaName = '',
    this.isFavorite = false,
    this.acceptsPatientInsurance = false,
    this.coverUrl,
    this.logoUrl,
    this.phone,
    this.branches = const [],
    this.acceptedInsuranceCompanies = const [],
    this.reviews,
  });

  factory PharmacyProfileModel.fromJson(Map<String, dynamic> json) {
    return PharmacyProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      branchName: json['branchName'] as String?,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      address: json['address'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      workingHoursStatus: json['workingHoursStatus'] as String? ?? '',
      isTwentyFourHours: json['isTwentyFourHours'] as bool? ?? false,
      isOpenNow: json['isOpenNow'] as bool? ?? false,
      aboutText: json['aboutText'] as String? ?? '',
      governorateId: json['governorateId'] as String? ?? '',
      governorateName: json['governorateName'] as String? ?? '',
      areaId: json['areaId'] as String? ?? '',
      areaName: json['areaName'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      acceptsPatientInsurance:
          json['acceptsPatientInsurance'] as bool? ?? false,
      coverUrl: (json['coverUrl'] ?? json['cover_url']) as String?,
      logoUrl: (json['logoUrl'] ?? json['logo_Url']) as String?,
      phone: json['phone'] as String?,
      branches: (json['branches'] as List<dynamic>?)
              ?.map(
                  (item) => PharmacyBranchModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
      acceptedInsuranceCompanies:
          (json['acceptedInsuranceCompanies'] as List<dynamic>?)
                  ?.map((item) =>
                      InsuranceCompanyModel.fromJson(item as Map<String, dynamic>))
                  .toList() ??
              const [],
      reviews: json['reviews'] != null
          ? DoctorReviewsDataModel.fromJson(
              json['reviews'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'branchName': branchName,
        'ratingAverage': ratingAverage,
        'totalReviews': totalReviews,
        'address': address,
        'distanceKm': distanceKm,
        'workingHoursStatus': workingHoursStatus,
        'isTwentyFourHours': isTwentyFourHours,
        'isOpenNow': isOpenNow,
        'aboutText': aboutText,
        'governorateId': governorateId,
        'governorateName': governorateName,
        'areaId': areaId,
        'areaName': areaName,
        'isFavorite': isFavorite,
        'acceptsPatientInsurance': acceptsPatientInsurance,
        'coverUrl': coverUrl,
        'logoUrl': logoUrl,
        'phone': phone,
        'branches': branches.map((b) => b.toJson()).toList(),
        'acceptedInsuranceCompanies':
            acceptedInsuranceCompanies.map((c) => c.toJson()).toList(),
        'reviews': reviews?.toJson(),
      };

  PharmacyProfileModel copyWith({
    String? id,
    String? name,
    String? branchName,
    double? ratingAverage,
    int? totalReviews,
    String? address,
    double? distanceKm,
    String? workingHoursStatus,
    bool? isTwentyFourHours,
    bool? isOpenNow,
    String? aboutText,
    String? governorateId,
    String? governorateName,
    String? areaId,
    String? areaName,
    bool? isFavorite,
    bool? acceptsPatientInsurance,
    String? coverUrl,
    String? logoUrl,
    String? phone,
    List<PharmacyBranchModel>? branches,
    List<InsuranceCompanyModel>? acceptedInsuranceCompanies,
    DoctorReviewsDataModel? reviews,
  }) {
    return PharmacyProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      branchName: branchName ?? this.branchName,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      totalReviews: totalReviews ?? this.totalReviews,
      address: address ?? this.address,
      distanceKm: distanceKm ?? this.distanceKm,
      workingHoursStatus: workingHoursStatus ?? this.workingHoursStatus,
      isTwentyFourHours: isTwentyFourHours ?? this.isTwentyFourHours,
      isOpenNow: isOpenNow ?? this.isOpenNow,
      aboutText: aboutText ?? this.aboutText,
      governorateId: governorateId ?? this.governorateId,
      governorateName: governorateName ?? this.governorateName,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      isFavorite: isFavorite ?? this.isFavorite,
      acceptsPatientInsurance:
          acceptsPatientInsurance ?? this.acceptsPatientInsurance,
      coverUrl: coverUrl ?? this.coverUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      phone: phone ?? this.phone,
      branches: branches ?? this.branches,
      acceptedInsuranceCompanies:
          acceptedInsuranceCompanies ?? this.acceptedInsuranceCompanies,
      reviews: reviews ?? this.reviews,
    );
  }

  String get formattedDistance {
    if (distanceKm <= 0) return '';
    return distanceKm.toStringAsFixed(1).replaceAll('.0', '');
  }

  String get displayName {
    if (branchName != null && branchName!.trim().isNotEmpty) {
      return '$name - $branchName';
    }
    return name;
  }

  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';
    final words = trimmed.split(RegExp(r'\s+'));
    if (words.length >= 2) {
      final firstChar = words[0].isNotEmpty ? words[0][0] : '';
      final secondChar = words[1].isNotEmpty ? words[1][0] : '';
      return '$firstChar$secondChar';
    }
    return trimmed.length >= 2 ? trimmed.substring(0, 2) : trimmed;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        branchName,
        ratingAverage,
        totalReviews,
        address,
        distanceKm,
        workingHoursStatus,
        isTwentyFourHours,
        isOpenNow,
        aboutText,
        governorateId,
        governorateName,
        areaId,
        areaName,
        isFavorite,
        acceptsPatientInsurance,
        coverUrl,
        logoUrl,
        phone,
        branches,
        acceptedInsuranceCompanies,
        reviews,
      ];
}

