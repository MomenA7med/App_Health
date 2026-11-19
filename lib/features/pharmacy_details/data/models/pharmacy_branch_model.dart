import 'package:equatable/equatable.dart';

class PharmacyBranchModel extends Equatable {
  final String id;
  final String branchName;
  final String address;
  final double distanceKm;
  final String workingHoursStatus;
  final bool isTwentyFourHours;
  final bool isOpenNow;
  final String governorateId;
  final String governorateName;
  final String areaId;
  final String areaName;
  final bool isPrimary;

  const PharmacyBranchModel({
    required this.id,
    required this.branchName,
    this.address = '',
    this.distanceKm = 0.0,
    this.workingHoursStatus = '',
    this.isTwentyFourHours = false,
    this.isOpenNow = false,
    this.governorateId = '',
    this.governorateName = '',
    this.areaId = '',
    this.areaName = '',
    this.isPrimary = false,
  });

  factory PharmacyBranchModel.fromJson(Map<String, dynamic> json) {
    return PharmacyBranchModel(
      id: json['id'] as String? ?? '',
      branchName: json['branchName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      workingHoursStatus: json['workingHoursStatus'] as String? ?? '',
      isTwentyFourHours: json['isTwentyFourHours'] as bool? ?? false,
      isOpenNow: json['isOpenNow'] as bool? ?? false,
      governorateId: json['governorateId'] as String? ?? '',
      governorateName: json['governorateName'] as String? ?? '',
      areaId: json['areaId'] as String? ?? '',
      areaName: json['areaName'] as String? ?? '',
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'branchName': branchName,
        'address': address,
        'distanceKm': distanceKm,
        'workingHoursStatus': workingHoursStatus,
        'isTwentyFourHours': isTwentyFourHours,
        'isOpenNow': isOpenNow,
        'governorateId': governorateId,
        'governorateName': governorateName,
        'areaId': areaId,
        'areaName': areaName,
        'isPrimary': isPrimary,
      };

  String get formattedDistance {
    if (distanceKm <= 0) return '';
    return distanceKm.toStringAsFixed(1).replaceAll('.0', '');
  }

  @override
  List<Object?> get props => [
        id,
        branchName,
        address,
        distanceKm,
        workingHoursStatus,
        isTwentyFourHours,
        isOpenNow,
        governorateId,
        governorateName,
        areaId,
        areaName,
        isPrimary,
      ];
}

