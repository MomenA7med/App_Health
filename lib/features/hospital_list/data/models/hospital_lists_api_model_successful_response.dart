import 'package:equatable/equatable.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_model.dart';

class HospitalListsDataModel extends Equatable {
  final List<HospitalModel> items;
  final int page;
  final int pageSize;
  final int totalCount;

  const HospitalListsDataModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory HospitalListsDataModel.fromJson(Map<String, dynamic> json) {
    return HospitalListsDataModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) =>
                  HospitalModel.fromJson(item as Map<String, dynamic>))
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

class HospitalListsApiModelSuccessfulResponse extends Equatable {
  final bool success;
  final String code;
  final String message;
  final HospitalListsDataModel data;

  const HospitalListsApiModelSuccessfulResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory HospitalListsApiModelSuccessfulResponse.fromJson(
      Map<String, dynamic> json) {
    return HospitalListsApiModelSuccessfulResponse(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? HospitalListsDataModel.fromJson(
              json['data'] as Map<String, dynamic>)
          : const HospitalListsDataModel(
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

