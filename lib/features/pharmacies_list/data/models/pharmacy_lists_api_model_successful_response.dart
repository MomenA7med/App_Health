import 'package:equatable/equatable.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';

class PharmacyListsDataModel extends Equatable {
  final List<PharmacyModel> items;
  final int page;
  final int pageSize;
  final int totalCount;

  const PharmacyListsDataModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory PharmacyListsDataModel.fromJson(Map<String, dynamic> json) {
    return PharmacyListsDataModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) =>
                  PharmacyModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((item) => item.toJson()).toList(),
        'page': page,
        'pageSize': pageSize,
        'totalCount': totalCount,
      };

  @override
  List<Object?> get props => [items, page, pageSize, totalCount];
}

class PharmacyListsApiModelSuccessfulResponse extends Equatable {
  final bool success;
  final String code;
  final String message;
  final PharmacyListsDataModel data;

  const PharmacyListsApiModelSuccessfulResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory PharmacyListsApiModelSuccessfulResponse.fromJson(
      Map<String, dynamic> json) {
    return PharmacyListsApiModelSuccessfulResponse(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? PharmacyListsDataModel.fromJson(
              json['data'] as Map<String, dynamic>)
          : const PharmacyListsDataModel(
              items: [],
              page: 1,
              pageSize: 20,
              totalCount: 0,
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

