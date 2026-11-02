import 'package:flutter/widgets.dart';

class MedicalSpecialtiesResponseModel {
  final bool success;
  final String code;
  final String message;
  final List<MedicalSpecialtyModel> data;

  MedicalSpecialtiesResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory MedicalSpecialtiesResponseModel.fromJson(Map<String, dynamic> json) {
    return MedicalSpecialtiesResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    MedicalSpecialtyModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class MedicalSpecialtyModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String imageUrl;
  final int displayOrder;

  MedicalSpecialtyModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.imageUrl,
    required this.displayOrder,
  });

  factory MedicalSpecialtyModel.fromJson(Map<String, dynamic> json) {
    return MedicalSpecialtyModel(
      id: json['id'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'imageUrl': imageUrl,
      'displayOrder': displayOrder,
    };
  }

  String getName(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic) {
      return nameAr.isNotEmpty ? nameAr : nameEn;
    } else {
      return nameEn.isNotEmpty ? nameEn : nameAr;
    }
  }

  String getDescription(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic) {
      return descriptionAr.isNotEmpty ? descriptionAr : descriptionEn;
    } else {
      return descriptionEn.isNotEmpty ? descriptionEn : descriptionAr;
    }
  }
}

