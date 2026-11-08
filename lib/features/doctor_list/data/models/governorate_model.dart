import 'package:equatable/equatable.dart';

class GovernoratesResponseModel extends Equatable {
  final bool success;
  final String code;
  final String message;
  final List<GovernorateModel> data;

  const GovernoratesResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory GovernoratesResponseModel.fromJson(Map<String, dynamic> json) {
    return GovernoratesResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  GovernorateModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'code': code,
        'message': message,
        'data': data.map((item) => item.toJson()).toList(),
      };

  @override
  List<Object?> get props => [success, code, message, data];
}

class GovernorateModel extends Equatable {
  final String id;
  final String name;
  final List<AreaModel> areas;

  const GovernorateModel({
    required this.id,
    required this.name,
    required this.areas,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      areas: (json['areas'] as List<dynamic>?)
              ?.map((item) => AreaModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'areas': areas.map((item) => item.toJson()).toList(),
      };

  @override
  List<Object?> get props => [id, name, areas];
}

class AreaModel extends Equatable {
  final String id;
  final String governorateId;
  final String name;

  const AreaModel({
    required this.id,
    required this.governorateId,
    required this.name,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'] as String? ?? '',
      governorateId: json['governorateId'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'governorateId': governorateId,
        'name': name,
      };

  @override
  List<Object?> get props => [id, governorateId, name];
}

