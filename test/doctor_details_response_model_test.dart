import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';

void main() {
  const sampleProfileJson = '''
{
  "success": true,
  "code": "DOCTOR_PROFILE_RETRIEVED",
  "message": "Doctor profile retrieved successfully.",
  "data": {
    "id": "c1a0d001-6f7a-4890-b123-456789abc001",
    "specialtyId": "b4e2d3c5-6f7a-4890-b123-456789abcdef",
    "name": "د. عمر أحمد",
    "specializationTitle": "استشاري الباطنة",
    "ratingAverage": 4.9,
    "totalReviews": 10,
    "clinicName": "المركز الطبي التخصصي",
    "clinicAddress": "شارع الطيران",
    "locationType": "Hospital",
    "cityLocation": "مدينة نصر، القاهرة",
    "area": "مدينة نصر",
    "areaId": "e3c2f011-6f7a-4890-b123-456789abd011",
    "governorateId": "e3c2f001-6f7a-4890-b123-456789abd001",
    "distanceKm": 1.2,
    "phoneNumber": "+201012345671",
    "aboutText": "استشاري الباطنة، متخصص في تشخيص ومتابعة الأمراض المزمنة واضطرابات الجهاز الهضمي.",
    "qualifications": [
      "دكتوراه أمراض الباطنة",
      "12 عاماً من الخبرة في طب الباطنة"
    ],
    "workingHours": "السبت إلى الخميس: من 3 إلى 9 مساءً",
    "imageUrl": null,
    "isFavorite": false,
    "acceptsPatientInsurance": true,
    "acceptedInsuranceCompanies": []
  }
}
''';

  const sampleReviewsJson = '''
{
  "success": true,
  "code": "DOCTOR_REVIEWS_RETRIEVED",
  "message": "Doctor reviews retrieved successfully.",
  "data": {
    "ratingAverage": 4.9,
    "totalReviews": 10,
    "breakdown": [
      {
        "rating": 5,
        "count": 9
      },
      {
        "rating": 4,
        "count": 1
      }
    ],
    "items": [
      {
        "id": "c1a0e101-6f7a-4890-b123-456789abce01",
        "patientName": "أحمد م.",
        "rating": 5,
        "comment": "الدكتور شرح الحالة بوضوح، والتعامل في العيادة كان منظم.",
        "createdAt": "2026-10-24T12:00:00Z"
      }
    ],
    "page": 1,
    "pageSize": 20,
    "totalCount": 10
  }
}
''';

  group('DoctorDetails Models Tests', () {
    test('DoctorProfileResponseModel parses correctly from json', () {
      final Map<String, dynamic> map = jsonDecode(sampleProfileJson);
      final response = DoctorProfileResponseModel.fromJson(map);

      expect(response.success, isTrue);
      expect(response.code, 'DOCTOR_PROFILE_RETRIEVED');
      expect(response.data.id, 'c1a0d001-6f7a-4890-b123-456789abc001');
      expect(response.data.name, 'د. عمر أحمد');
      expect(response.data.specializationTitle, 'استشاري الباطنة');
      expect(response.data.ratingAverage, 4.9);
      expect(response.data.totalReviews, 10);
      expect(response.data.clinicName, 'المركز الطبي التخصصي');
      expect(response.data.distanceKm, 1.2);
      expect(response.data.phoneNumber, '+201012345671');
      expect(response.data.qualifications.length, 2);
      expect(response.data.acceptsPatientInsurance, isTrue);
    });

    test('DoctorReviewsResponseModel parses correctly from json', () {
      final Map<String, dynamic> map = jsonDecode(sampleReviewsJson);
      final response = DoctorReviewsResponseModel.fromJson(map);

      expect(response.success, isTrue);
      expect(response.data.ratingAverage, 4.9);
      expect(response.data.totalReviews, 10);
      expect(response.data.breakdown.length, 2);
      expect(response.data.breakdown.first.rating, 5);
      expect(response.data.breakdown.first.count, 9);
      expect(response.data.items.length, 1);
      expect(response.data.items.first.patientName, 'أحمد م.');
      expect(response.data.items.first.rating, 5);
      expect(response.data.items.first.comment,
          'الدكتور شرح الحالة بوضوح، والتعامل في العيادة كان منظم.');
    });
  });
}

