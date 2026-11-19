import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';

class HospitalProfileResponseModel extends Equatable {
  final bool success;
  final String code;
  final String message;
  final HospitalProfileModel data;

  const HospitalProfileResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory HospitalProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return HospitalProfileResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: HospitalProfileModel.fromJson(
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

class HospitalProfileModel extends Equatable {
  final String id;
  final String name;
  final double ratingAverage;
  final int totalReviews;
  final String address;
  final double distanceKm;
  final String workingHoursStatus;
  final String aboutText;
  final String governorateId;
  final String governorateName;
  final String areaId;
  final String areaName;
  final bool isFavorite;
  final bool acceptsPatientInsurance;
  final String? logoUrl;
  final String? coverUrl;
  final String? phone;
  final List<HospitalSpecialtyItemModel> specialties;
  final List<HospitalServiceItemModel> services;
  final int specialtiesCount;
  final String specialtiesCountLabel;
  final List<InsuranceCompanyModel> acceptedInsuranceCompanies;
  final DoctorReviewsDataModel? reviews;

  const HospitalProfileModel({
    required this.id,
    required this.name,
    this.ratingAverage = 0.0,
    this.totalReviews = 0,
    this.address = '',
    this.distanceKm = 0.0,
    this.workingHoursStatus = '',
    this.aboutText = '',
    this.governorateId = '',
    this.governorateName = '',
    this.areaId = '',
    this.areaName = '',
    this.isFavorite = false,
    this.acceptsPatientInsurance = false,
    this.logoUrl,
    this.coverUrl,
    this.phone,
    this.specialties = const [],
    this.services = const [],
    this.specialtiesCount = 0,
    this.specialtiesCountLabel = '',
    this.acceptedInsuranceCompanies = const [],
    this.reviews,
  });

  factory HospitalProfileModel.fromJson(Map<String, dynamic> json) {
    return HospitalProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      address: json['address'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      workingHoursStatus: json['workingHoursStatus'] as String? ?? '',
      aboutText: json['aboutText'] as String? ?? '',
      governorateId: json['governorateId'] as String? ?? '',
      governorateName: json['governorateName'] as String? ?? '',
      areaId: json['areaId'] as String? ?? '',
      areaName: json['areaName'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      acceptsPatientInsurance:
          json['acceptsPatientInsurance'] as bool? ?? false,
      logoUrl: json['logoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      phone: json['phone'] as String?,
      specialties:
          (json['specialties'] as List<dynamic>?)
              ?.map(
                (e) => HospitalSpecialtyItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      services:
          (json['services'] as List<dynamic>?)
              ?.map(
                (e) => HospitalServiceItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      specialtiesCount: (json['specialtiesCount'] as num?)?.toInt() ?? 0,
      specialtiesCountLabel: json['specialtiesCountLabel'] as String? ?? '',
      acceptedInsuranceCompanies:
          (json['acceptedInsuranceCompanies'] as List<dynamic>?)
              ?.map(
                (e) =>
                    InsuranceCompanyModel.fromJson(e as Map<String, dynamic>),
              )
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
    'ratingAverage': ratingAverage,
    'totalReviews': totalReviews,
    'address': address,
    'distanceKm': distanceKm,
    'workingHoursStatus': workingHoursStatus,
    'aboutText': aboutText,
    'governorateId': governorateId,
    'governorateName': governorateName,
    'areaId': areaId,
    'areaName': areaName,
    'isFavorite': isFavorite,
    'acceptsPatientInsurance': acceptsPatientInsurance,
    'logo_Url': logoUrl,
    'cover_url': coverUrl,
    'phone': phone,
    'specialties': specialties.map((e) => e.toJson()).toList(),
    'services': services.map((e) => e.toJson()).toList(),
    'specialtiesCount': specialtiesCount,
    'specialtiesCountLabel': specialtiesCountLabel,
    'acceptedInsuranceCompanies': acceptedInsuranceCompanies
        .map((e) => e.toJson())
        .toList(),
    'reviews': reviews?.toJson(),
  };

  HospitalProfileModel copyWith({
    String? id,
    String? name,
    double? ratingAverage,
    int? totalReviews,
    String? address,
    double? distanceKm,
    String? workingHoursStatus,
    String? aboutText,
    String? governorateId,
    String? governorateName,
    String? areaId,
    String? areaName,
    bool? isFavorite,
    bool? acceptsPatientInsurance,
    String? logoUrl,
    String? coverUrl,
    String? phone,
    List<HospitalSpecialtyItemModel>? specialties,
    List<HospitalServiceItemModel>? services,
    int? specialtiesCount,
    String? specialtiesCountLabel,
    List<InsuranceCompanyModel>? acceptedInsuranceCompanies,
    DoctorReviewsDataModel? reviews,
  }) {
    return HospitalProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      totalReviews: totalReviews ?? this.totalReviews,
      address: address ?? this.address,
      distanceKm: distanceKm ?? this.distanceKm,
      workingHoursStatus: workingHoursStatus ?? this.workingHoursStatus,
      aboutText: aboutText ?? this.aboutText,
      governorateId: governorateId ?? this.governorateId,
      governorateName: governorateName ?? this.governorateName,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      isFavorite: isFavorite ?? this.isFavorite,
      acceptsPatientInsurance:
          acceptsPatientInsurance ?? this.acceptsPatientInsurance,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      phone: phone ?? this.phone,
      specialties: specialties ?? this.specialties,
      services: services ?? this.services,
      specialtiesCount: specialtiesCount ?? this.specialtiesCount,
      specialtiesCountLabel:
          specialtiesCountLabel ?? this.specialtiesCountLabel,
      acceptedInsuranceCompanies:
          acceptedInsuranceCompanies ?? this.acceptedInsuranceCompanies,
      reviews: reviews ?? this.reviews,
    );
  }

  String get formattedDistance {
    if (distanceKm <= 0) return '';
    return distanceKm.toStringAsFixed(1).replaceAll('.0', '');
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
    ratingAverage,
    totalReviews,
    address,
    distanceKm,
    workingHoursStatus,
    aboutText,
    governorateId,
    governorateName,
    areaId,
    areaName,
    isFavorite,
    acceptsPatientInsurance,
    logoUrl,
    coverUrl,
    phone,
    specialties,
    services,
    specialtiesCount,
    specialtiesCountLabel,
    acceptedInsuranceCompanies,
    reviews,
  ];
}

class HospitalSpecialtyItemModel extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;

  const HospitalSpecialtyItemModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory HospitalSpecialtyItemModel.fromJson(Map<String, dynamic> json) {
    return HospitalSpecialtyItemModel(
      id: json['id'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nameAr': nameAr,
    'nameEn': nameEn,
  };

  String getName(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic) {
      return nameAr.isNotEmpty ? nameAr : nameEn;
    } else {
      return nameEn.isNotEmpty ? nameEn : nameAr;
    }
  }

  @override
  List<Object?> get props => [id, nameAr, nameEn];
}

class HospitalServiceItemModel extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;

  const HospitalServiceItemModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory HospitalServiceItemModel.fromJson(Map<String, dynamic> json) {
    return HospitalServiceItemModel(
      id: json['id'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nameAr': nameAr,
    'nameEn': nameEn,
  };

  String getName(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic) {
      return nameAr.isNotEmpty ? nameAr : nameEn;
    } else {
      return nameEn.isNotEmpty ? nameEn : nameAr;
    }
  }

  @override
  List<Object?> get props => [id, nameAr, nameEn];
}
