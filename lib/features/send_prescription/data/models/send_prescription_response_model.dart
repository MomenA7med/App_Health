import 'package:equatable/equatable.dart';

class SendPrescriptionResponseModel extends Equatable {
  final bool success;
  final String code;
  final String message;
  final PrescriptionOrderModel data;

  const SendPrescriptionResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory SendPrescriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return SendPrescriptionResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: PrescriptionOrderModel.fromJson(
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

class PrescriptionOrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final String? imageName;
  final int locationStrategy;
  final String? savedAddressId;
  final String? governorateId;
  final String? areaId;
  final String? orderDetails;
  final String createdAt;
  final List<PrescriptionOrderPharmacyModel> pharmacies;

  const PrescriptionOrderModel({
    required this.id,
    required this.orderNumber,
    this.imageName,
    this.locationStrategy = 1,
    this.savedAddressId,
    this.governorateId,
    this.areaId,
    this.orderDetails,
    this.createdAt = '',
    this.pharmacies = const [],
  });

  factory PrescriptionOrderModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionOrderModel(
      id: json['id'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      imageName: json['imageName'] as String?,
      locationStrategy: (json['locationStrategy'] as num?)?.toInt() ?? 1,
      savedAddressId: json['savedAddressId'] as String?,
      governorateId: json['governorateId'] as String?,
      areaId: json['areaId'] as String?,
      orderDetails: json['orderDetails'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      pharmacies: (json['pharmacies'] as List<dynamic>?)
              ?.map((item) => PrescriptionOrderPharmacyModel.fromJson(
                  item as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderNumber': orderNumber,
        'imageName': imageName,
        'locationStrategy': locationStrategy,
        'savedAddressId': savedAddressId,
        'governorateId': governorateId,
        'areaId': areaId,
        'orderDetails': orderDetails,
        'createdAt': createdAt,
        'pharmacies': pharmacies.map((p) => p.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        imageName,
        locationStrategy,
        savedAddressId,
        governorateId,
        areaId,
        orderDetails,
        createdAt,
        pharmacies,
      ];
}

class PrescriptionOrderPharmacyModel extends Equatable {
  final String pharmacyId;
  final String name;
  final String? branchName;
  final String status;

  const PrescriptionOrderPharmacyModel({
    required this.pharmacyId,
    required this.name,
    this.branchName,
    this.status = 'Pending',
  });

  factory PrescriptionOrderPharmacyModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionOrderPharmacyModel(
      pharmacyId: json['pharmacyId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      branchName: json['branchName'] as String?,
      status: json['status'] as String? ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() => {
        'pharmacyId': pharmacyId,
        'name': name,
        'branchName': branchName,
        'status': status,
      };

  String get displayName {
    if (branchName != null && branchName!.trim().isNotEmpty) {
      return '$name - $branchName';
    }
    return name;
  }

  @override
  List<Object?> get props => [pharmacyId, name, branchName, status];
}

