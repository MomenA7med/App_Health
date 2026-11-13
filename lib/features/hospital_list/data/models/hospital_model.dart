import 'package:equatable/equatable.dart';

class HospitalModel extends Equatable {
  final String id;
  final String name;
  final double ratingAverage;
  final int totalReviews;
  final String address;
  final double distanceKm;
  final String workingHoursStatus;
  final String governorateId;
  final String governorateName;
  final String areaId;
  final String areaName;
  final bool isFavorite;
  final bool acceptsPatientInsurance;
  final int specialtiesCount;
  final String specialtiesCountLabel;
  final String? logoUrl;
  final String? coverUrl;

  const HospitalModel({
    required this.id,
    required this.name,
    required this.ratingAverage,
    required this.totalReviews,
    required this.address,
    required this.distanceKm,
    required this.workingHoursStatus,
    required this.governorateId,
    required this.governorateName,
    required this.areaId,
    required this.areaName,
    this.isFavorite = false,
    this.acceptsPatientInsurance = false,
    this.specialtiesCount = 0,
    this.specialtiesCountLabel = '',
    this.logoUrl,
    this.coverUrl,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      address: json['address'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      workingHoursStatus: json['workingHoursStatus'] as String? ?? '',
      governorateId: json['governorateId'] as String? ?? '',
      governorateName: json['governorateName'] as String? ?? '',
      areaId: json['areaId'] as String? ?? '',
      areaName: json['areaName'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      acceptsPatientInsurance:
          true,
      specialtiesCount: json['specialtiesCount'] as int? ?? 0,
      specialtiesCountLabel: json['specialtiesCountLabel'] as String? ?? '',
      logoUrl: (json['logo_Url'] ?? json['logoUrl']) as String?,
      coverUrl: (json['cover_url'] ?? json['coverUrl']) as String?,
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
        'governorateId': governorateId,
        'governorateName': governorateName,
        'areaId': areaId,
        'areaName': areaName,
        'isFavorite': isFavorite,
        'acceptsPatientInsurance': acceptsPatientInsurance,
        'specialtiesCount': specialtiesCount,
        'specialtiesCountLabel': specialtiesCountLabel,
        'logo_Url': logoUrl,
        'cover_url': coverUrl,
      };

  HospitalModel copyWith({
    String? id,
    String? name,
    double? ratingAverage,
    int? totalReviews,
    String? address,
    double? distanceKm,
    String? workingHoursStatus,
    String? governorateId,
    String? governorateName,
    String? areaId,
    String? areaName,
    bool? isFavorite,
    bool? acceptsPatientInsurance,
    int? specialtiesCount,
    String? specialtiesCountLabel,
    String? logoUrl,
    String? coverUrl,
  }) {
    return HospitalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      totalReviews: totalReviews ?? this.totalReviews,
      address: address ?? this.address,
      distanceKm: distanceKm ?? this.distanceKm,
      workingHoursStatus: workingHoursStatus ?? this.workingHoursStatus,
      governorateId: governorateId ?? this.governorateId,
      governorateName: governorateName ?? this.governorateName,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      isFavorite: isFavorite ?? this.isFavorite,
      acceptsPatientInsurance:
          acceptsPatientInsurance ?? this.acceptsPatientInsurance,
      specialtiesCount: specialtiesCount ?? this.specialtiesCount,
      specialtiesCountLabel:
          specialtiesCountLabel ?? this.specialtiesCountLabel,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }

  String get formattedDistance {
    if (distanceKm == distanceKm.roundToDouble()) {
      return distanceKm.toInt().toString();
    }
    return distanceKm.toStringAsFixed(1);
  }

  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'م';
    final parts = trimmed.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1);
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
        governorateId,
        governorateName,
        areaId,
        areaName,
        isFavorite,
        acceptsPatientInsurance,
        specialtiesCount,
        specialtiesCountLabel,
        logoUrl,
        coverUrl,
      ];
}

