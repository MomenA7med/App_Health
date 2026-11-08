import 'package:equatable/equatable.dart';

class UserAddressModel extends Equatable {
  final String id;
  final String addressName;
  final String governorate;
  final String area;
  final String detailedAddress;
  final bool isCurrentLocation;

  const UserAddressModel({
    required this.id,
    required this.addressName,
    required this.governorate,
    required this.area,
    required this.detailedAddress,
    required this.isCurrentLocation,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      id: json['id'] as String? ?? '',
      addressName: json['addressName'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      area: json['area'] as String? ?? '',
      detailedAddress: json['detailedAddress'] as String? ?? '',
      isCurrentLocation: json['isCurrentLocation'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'addressName': addressName,
        'governorate': governorate,
        'area': area,
        'detailedAddress': detailedAddress,
        'isCurrentLocation': isCurrentLocation,
      };

  @override
  List<Object?> get props => [
        id,
        addressName,
        governorate,
        area,
        detailedAddress,
        isCurrentLocation,
      ];
}

class UserAddressesDataModel extends Equatable {
  final List<UserAddressModel> items;
  final int totalCount;
  final String? defaultAddressId;

  const UserAddressesDataModel({
    required this.items,
    required this.totalCount,
    this.defaultAddressId,
  });

  factory UserAddressesDataModel.fromJson(Map<String, dynamic> json) {
    return UserAddressesDataModel(
      items: (json['items'] as List<dynamic>?)
              ?.map(
                  (item) => UserAddressModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
      defaultAddressId: json['defaultAddressId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((item) => item.toJson()).toList(),
        'totalCount': totalCount,
        'defaultAddressId': defaultAddressId,
      };

  @override
  List<Object?> get props => [items, totalCount, defaultAddressId];
}

class UserAddressesResponseModel extends Equatable {
  final bool success;
  final String code;
  final String message;
  final UserAddressesDataModel data;

  const UserAddressesResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory UserAddressesResponseModel.fromJson(Map<String, dynamic> json) {
    return UserAddressesResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? UserAddressesDataModel.fromJson(
              json['data'] as Map<String, dynamic>)
          : const UserAddressesDataModel(items: [], totalCount: 0),
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

class CreateAddressResponseModel extends Equatable {
  final bool success;
  final String code;
  final String message;
  final UserAddressModel data;

  const CreateAddressResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CreateAddressResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateAddressResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? UserAddressModel.fromJson(json['data'] as Map<String, dynamic>)
          : const UserAddressModel(
              id: '',
              addressName: '',
              governorate: '',
              area: '',
              detailedAddress: '',
              isCurrentLocation: false,
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

