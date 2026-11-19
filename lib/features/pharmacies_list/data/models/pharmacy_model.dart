import 'package:equatable/equatable.dart';

class PharmacyModel extends Equatable {
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
  final String governorateId;
  final String governorateName;
  final String areaId;
  final String areaName;
  final bool isFavorite;
  final bool acceptsPatientInsurance;
  final String? coverUrl;
  final String? logoUrl;

  const PharmacyModel({
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
    this.governorateId = '',
    this.governorateName = '',
    this.areaId = '',
    this.areaName = '',
    this.isFavorite = false,
    this.acceptsPatientInsurance = false,
    this.coverUrl,
    this.logoUrl,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      branchName: json['branchName'] as String?,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      address: json['address'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      workingHoursStatus: json['workingHoursStatus'] as String? ?? '',
      isTwentyFourHours: json['isTwentyFourHours'] as bool? ?? false,
      isOpenNow: json['isOpenNow'] as bool? ?? false,
      governorateId: json['governorateId'] as String? ?? '',
      governorateName: json['governorateName'] as String? ?? '',
      areaId: json['areaId'] as String? ?? '',
      areaName: json['areaName'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      acceptsPatientInsurance:
          json['acceptsPatientInsurance'] as bool? ?? false,
      coverUrl: (json['cover_url'] ?? json['coverUrl']) as String?,
      logoUrl: (json['logo_Url'] ?? json['logoUrl']) as String?,
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
        'governorateId': governorateId,
        'governorateName': governorateName,
        'areaId': areaId,
        'areaName': areaName,
        'isFavorite': isFavorite,
        'acceptsPatientInsurance': acceptsPatientInsurance,
        'cover_url': coverUrl,
        'logo_Url': logoUrl,
      };

  PharmacyModel copyWith({
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
    String? governorateId,
    String? governorateName,
    String? areaId,
    String? areaName,
    bool? isFavorite,
    bool? acceptsPatientInsurance,
    String? coverUrl,
    String? logoUrl,
  }) {
    return PharmacyModel(
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
      governorateId: governorateId ?? this.governorateId,
      governorateName: governorateName ?? this.governorateName,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      isFavorite: isFavorite ?? this.isFavorite,
      acceptsPatientInsurance:
          acceptsPatientInsurance ?? this.acceptsPatientInsurance,
      coverUrl: coverUrl ?? this.coverUrl,
      logoUrl: logoUrl ?? this.logoUrl,
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
        governorateId,
        governorateName,
        areaId,
        areaName,
        isFavorite,
        acceptsPatientInsurance,
        coverUrl,
        logoUrl,
      ];
}

