import 'package:app_health/features/core/domain/entities/meta/meta_ui_model.dart';

class SpecialtyDoctorsResponseModel {
  final bool success;
  final String code;
  final String message;
  final SpecialtyDoctorsDataModel? data;

  SpecialtyDoctorsResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory SpecialtyDoctorsResponseModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyDoctorsResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? SpecialtyDoctorsDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
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

  MetaUiModel get metaUiModel => data?.metaUiModel ?? MetaUiModel.emptyOne();
  List<DoctorModel> get doctors => data?.items ?? [];
  List<DoctorModel> get doctorList => doctors;
  bool get hasNext => data?.hasNext ?? false;
  bool get hasPrevious => data?.hasPrevious ?? false;
  int get totalPages => data?.totalPages ?? 0;
  int get currentPage => data?.page ?? 1;
  int get totalCount => data?.totalCount ?? 0;
}

class SpecialtyDoctorsDataModel {
  final List<DoctorModel> items;
  final int page;
  final int pageSize;
  final int totalCount;

  SpecialtyDoctorsDataModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  MetaUiModel get metaUiModel => MetaUiModel(
        currentPage: page,
        totalPages: totalPages,
      );

  int get totalPages =>
      pageSize > 0 ? (totalCount / pageSize).ceil() : 0;

  bool get hasNext => page < totalPages;

  bool get hasPrevious => page > 1;

  bool get isFirstPage => page <= 1;

  bool get isLastPage => !hasNext;

  factory SpecialtyDoctorsDataModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyDoctorsDataModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => DoctorModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'page': page,
      'pageSize': pageSize,
      'totalCount': totalCount,
    };
  }
}

class DoctorModel {
  final String id;
  final String name;
  final String gender;
  final String specializationTitle;
  final double ratingAverage;
  final int totalReviews;
  final String clinicName;
  final String clinicAddress;
  final String cityLocation;
  final String area;
  final double distanceKm;
  final num consultationFee;
  final String? nextAvailableSlot;
  final String? nextAvailableDate;
  final String? imageUrl;
  final bool acceptsPatientInsurance;
  final bool isFavorite;

  DoctorModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.specializationTitle,
    required this.ratingAverage,
    required this.totalReviews,
    required this.clinicName,
    required this.clinicAddress,
    required this.cityLocation,
    required this.area,
    required this.distanceKm,
    required this.consultationFee,
    this.nextAvailableSlot,
    this.nextAvailableDate,
    this.imageUrl,
    this.acceptsPatientInsurance = false,
    this.isFavorite = false,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      specializationTitle: json['specializationTitle'] as String? ?? '',
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      clinicName: json['clinicName'] as String? ?? '',
      clinicAddress: json['clinicAddress'] as String? ?? '',
      cityLocation: json['cityLocation'] as String? ?? '',
      area: json['area'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      consultationFee: (json['consultationFee'] as num?) ?? 0,
      nextAvailableSlot: json['nextAvailableSlot'] as String?,
      nextAvailableDate: json['nextAvailableDate'] as String?,
      imageUrl: json['imageUrl'] as String?,
      acceptsPatientInsurance: json['acceptsPatientInsurance'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'specializationTitle': specializationTitle,
      'ratingAverage': ratingAverage,
      'totalReviews': totalReviews,
      'clinicName': clinicName,
      'clinicAddress': clinicAddress,
      'cityLocation': cityLocation,
      'area': area,
      'distanceKm': distanceKm,
      'consultationFee': consultationFee,
      'nextAvailableSlot': nextAvailableSlot,
      'nextAvailableDate': nextAvailableDate,
      'imageUrl': imageUrl,
    };
  }

  bool get isMale => gender.trim().toLowerCase() == 'male';
  bool get isFemale => gender.trim().toLowerCase() == 'female';

  String get formattedFee {
    if (consultationFee % 1 == 0) {
      return consultationFee.toInt().toString();
    }
    return consultationFee.toString();
  }

  String get formattedDistance {
    if (distanceKm % 1 == 0) {
      return distanceKm.toInt().toString();
    }
    return distanceKm.toStringAsFixed(1);
  }

  String get initials {
    String cleaned = name
        .replaceAll(RegExp(r'^(د[\.\/]?|dr[\.\/]?)\s*', caseSensitive: false), '')
        .trim();
    if (cleaned.isEmpty) {
      cleaned = name.trim();
    }
    final parts = cleaned.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final first = parts[0].isNotEmpty ? parts[0].substring(0, 1) : '';
      final second = parts[1].isNotEmpty ? parts[1].substring(0, 1) : '';
      return '$first $second'.trim();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, 1);
    }
    return '';
  }
}

