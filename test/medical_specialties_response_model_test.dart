import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';

void main() {
  const String sampleApiResponse = '''
{
  "success": true,
  "code": "MEDICAL_SPECIALTIES_RETRIEVED",
  "message": "Medical specialties retrieved successfully.",
  "data": [
    {
      "id": "a3f1c2d4-5e6b-4789-a012-3456789abcde",
      "nameAr": "الأسنان",
      "nameEn": "Dentistry",
      "descriptionAr": "تشخيص وعلاج أمراض الأسنان واللثة والفم.",
      "descriptionEn": "Diagnosis and treatment of teeth, gums, and oral health.",
      "imageUrl": "https://healthappstaging.runasp.net/uploads/specialties/a3f1c2d45e6b4789a0123456789abcde.jpg",
      "displayOrder": 1
    },
    {
      "id": "b4e2d3c5-6f7a-4890-b123-456789abcdef",
      "nameAr": "الباطنة",
      "nameEn": "Internal Medicine",
      "descriptionAr": "تشخيص وعلاج أمراض البالغين الداخلية.",
      "descriptionEn": "Diagnosis and treatment of adult internal diseases.",
      "imageUrl": "https://healthappstaging.runasp.net/uploads/specialties/b4e2d3c56f7a4890b123456789abcdef.jpg",
      "displayOrder": 2
    }
  ]
}
''';

  group('MedicalSpecialtiesResponseModel Tests', () {
    test('parses sample json correctly', () {
      final Map<String, dynamic> jsonMap = jsonDecode(sampleApiResponse);
      final model = MedicalSpecialtiesResponseModel.fromJson(jsonMap);

      expect(model.success, isTrue);
      expect(model.code, 'MEDICAL_SPECIALTIES_RETRIEVED');
      expect(model.message, 'Medical specialties retrieved successfully.');
      expect(model.data.length, 2);

      final first = model.data[0];
      expect(first.id, 'a3f1c2d4-5e6b-4789-a012-3456789abcde');
      expect(first.nameAr, 'الأسنان');
      expect(first.nameEn, 'Dentistry');
      expect(first.descriptionAr, 'تشخيص وعلاج أمراض الأسنان واللثة والفم.');
      expect(
        first.descriptionEn,
        'Diagnosis and treatment of teeth, gums, and oral health.',
      );
      expect(
        first.imageUrl,
        'https://healthappstaging.runasp.net/uploads/specialties/a3f1c2d45e6b4789a0123456789abcde.jpg',
      );
      expect(first.displayOrder, 1);

      final second = model.data[1];
      expect(second.id, 'b4e2d3c5-6f7a-4890-b123-456789abcdef');
      expect(second.nameAr, 'الباطنة');
      expect(second.nameEn, 'Internal Medicine');
      expect(second.displayOrder, 2);
    });

    test('toJson serializes correctly', () {
      final Map<String, dynamic> jsonMap = jsonDecode(sampleApiResponse);
      final model = MedicalSpecialtiesResponseModel.fromJson(jsonMap);
      final serialized = model.toJson();

      expect(serialized['success'], isTrue);
      expect(serialized['code'], 'MEDICAL_SPECIALTIES_RETRIEVED');
      expect((serialized['data'] as List).length, 2);
      expect((serialized['data'] as List)[0]['nameAr'], 'الأسنان');
    });

    test('handles empty and null fields gracefully', () {
      final model = MedicalSpecialtiesResponseModel.fromJson({});
      expect(model.success, isFalse);
      expect(model.code, isEmpty);
      expect(model.message, isEmpty);
      expect(model.data, isEmpty);

      final item = MedicalSpecialtyModel.fromJson({});
      expect(item.id, isEmpty);
      expect(item.nameAr, isEmpty);
      expect(item.nameEn, isEmpty);
      expect(item.descriptionAr, isEmpty);
      expect(item.descriptionEn, isEmpty);
      expect(item.imageUrl, isEmpty);
      expect(item.displayOrder, 0);
    });
  });
}

