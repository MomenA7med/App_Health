import 'package:equatable/equatable.dart';

class InsuranceCompaniesResponseModel extends Equatable {
  final bool success;
  final String code;
  final String message;
  final List<InsuranceCompanyModel> data;

  const InsuranceCompaniesResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory InsuranceCompaniesResponseModel.fromJson(Map<String, dynamic> json) {
    return InsuranceCompaniesResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  InsuranceCompanyModel.fromJson(item as Map<String, dynamic>))
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

class InsuranceCompanyModel extends Equatable {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? logoUrl;

  const InsuranceCompanyModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.logoUrl,
  });

  factory InsuranceCompanyModel.fromJson(Map<String, dynamic> json) {
    return InsuranceCompanyModel(
      id: json['id'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        if (logoUrl != null) 'logoUrl': logoUrl,
      };

  String localizedName(String languageCode) {
    if (languageCode == 'en' && nameEn.isNotEmpty) {
      return nameEn;
    }
    return nameAr.isNotEmpty ? nameAr : nameEn;
  }

  @override
  List<Object?> get props => [id, nameAr, nameEn, logoUrl];
}

