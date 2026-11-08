import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_list_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_lists_api_model_successful_response.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_send_model.dart';
import 'package:app_health/features/doctor_list/domain/entities/doctor_lists_ui_response.dart';

void main() {
  const String sampleApiResponse = '''
{
  "success": true,
  "code": "DOCTORS_RETRIEVED",
  "message": "Doctors retrieved successfully.",
  "data": {
    "items": [
      {
        "id": "c1a0d001-6f7a-4890-b123-456789abc001",
        "name": "د. عمر أحمد",
        "gender": "Male",
        "specializationTitle": "استشاري الباطنة",
        "ratingAverage": 4.9,
        "totalReviews": 10,
        "clinicName": "المركز الطبي التخصصي",
        "clinicAddress": "شارع الطيران",
        "cityLocation": "مدينة نصر، القاهرة",
        "area": "مدينة نصر",
        "distanceKm": 1.2,
        "consultationFee": 350,
        "nextAvailableSlot": "اليوم، ٣:٣٠ مساءً",
        "nextAvailableDate": "2026-11-01",
        "imageUrl": null
      },
      {
        "id": "c1a0d002-6f7a-4890-b123-456789abc002",
        "name": "د. سارة محمود",
        "gender": "Female",
        "specializationTitle": "أخصائي الباطنة",
        "ratingAverage": 4.6,
        "totalReviews": 5,
        "clinicName": "عيادة النيل",
        "clinicAddress": "شارع عباس العقاد",
        "cityLocation": "مدينة نصر، القاهرة",
        "area": "مدينة نصر",
        "distanceKm": 2.4,
        "consultationFee": 280,
        "nextAvailableSlot": "غداً، ١٠:٠٠ صباحاً",
        "nextAvailableDate": "2026-11-02",
        "imageUrl": "https://example.com/doctor.jpg"
      }
    ],
    "page": 1,
    "pageSize": 20,
    "totalCount": 2
  }
}
''';

  group('SpecialtyDoctorsResponseModel Tests', () {
    test('parses sample json correctly', () {
      final Map<String, dynamic> jsonMap = jsonDecode(sampleApiResponse);
      final model = SpecialtyDoctorsResponseModel.fromJson(jsonMap);

      expect(model.success, isTrue);
      expect(model.code, 'DOCTORS_RETRIEVED');
      expect(model.message, 'Doctors retrieved successfully.');
      expect(model.data, isNotNull);
      expect(model.data!.items.length, 2);
      expect(model.data!.page, 1);
      expect(model.data!.pageSize, 20);
      expect(model.data!.totalCount, 2);

      final first = model.data!.items[0];
      expect(first.id, 'c1a0d001-6f7a-4890-b123-456789abc001');
      expect(first.name, 'د. عمر أحمد');
      expect(first.gender, 'Male');
      expect(first.isMale, isTrue);
      expect(first.isFemale, isFalse);
      expect(first.specializationTitle, 'استشاري الباطنة');
      expect(first.ratingAverage, 4.9);
      expect(first.totalReviews, 10);
      expect(first.clinicName, 'المركز الطبي التخصصي');
      expect(first.clinicAddress, 'شارع الطيران');
      expect(first.cityLocation, 'مدينة نصر، القاهرة');
      expect(first.area, 'مدينة نصر');
      expect(first.distanceKm, 1.2);
      expect(first.consultationFee, 350);
      expect(first.nextAvailableSlot, 'اليوم، ٣:٣٠ مساءً');
      expect(first.nextAvailableDate, '2026-11-01');
      expect(first.imageUrl, isNull);
      expect(first.initials, 'ع أ');

      final second = model.data!.items[1];
      expect(second.name, 'د. سارة محمود');
      expect(second.isFemale, isTrue);
      expect(second.isMale, isFalse);
      expect(second.initials, 'س م');
      expect(second.imageUrl, 'https://example.com/doctor.jpg');
    });

    test('toJson serializes correctly', () {
      final Map<String, dynamic> jsonMap = jsonDecode(sampleApiResponse);
      final model = SpecialtyDoctorsResponseModel.fromJson(jsonMap);
      final serialized = model.toJson();

      expect(serialized['success'], isTrue);
      expect(serialized['code'], 'DOCTORS_RETRIEVED');
      expect(serialized['data'], isNotNull);
      final dataMap = serialized['data'] as Map<String, dynamic>;
      expect((dataMap['items'] as List).length, 2);
      expect((dataMap['items'] as List)[0]['name'], 'د. عمر أحمد');
    });

    test('handles empty and null fields gracefully', () {
      final model = SpecialtyDoctorsResponseModel.fromJson({});
      expect(model.success, isFalse);
      expect(model.code, isEmpty);
      expect(model.message, isEmpty);
      expect(model.data, isNull);

      final doctor = DoctorModel.fromJson({});
      expect(doctor.id, isEmpty);
      expect(doctor.name, isEmpty);
      expect(doctor.gender, isEmpty);
      expect(doctor.specializationTitle, isEmpty);
      expect(doctor.ratingAverage, 0.0);
      expect(doctor.totalReviews, 0);
      expect(doctor.clinicName, isEmpty);
      expect(doctor.clinicAddress, isEmpty);
      expect(doctor.cityLocation, isEmpty);
      expect(doctor.area, isEmpty);
      expect(doctor.distanceKm, 0.0);
      expect(doctor.consultationFee, 0);
      expect(doctor.nextAvailableSlot, isNull);
      expect(doctor.imageUrl, isNull);
      expect(doctor.initials, isEmpty);
    });

    test('SpecialtyDoctorsResponseModel and DataModel expose pagination properties correctly', () {
      final dataModel = SpecialtyDoctorsDataModel(
        items: [],
        page: 2,
        pageSize: 10,
        totalCount: 35,
      );

      expect(dataModel.totalPages, 4);
      expect(dataModel.hasNext, isTrue);
      expect(dataModel.hasPrevious, isTrue);
      expect(dataModel.isFirstPage, isFalse);
      expect(dataModel.isLastPage, isFalse);

      final responseModel = SpecialtyDoctorsResponseModel(
        success: true,
        code: 'DOCTORS_RETRIEVED',
        message: 'Success',
        data: dataModel,
      );

      expect(responseModel.hasNext, isTrue);
      expect(responseModel.hasPrevious, isTrue);
      expect(responseModel.totalPages, 4);
      expect(responseModel.currentPage, 2);
      expect(responseModel.totalCount, 35);
      expect(responseModel.metaUiModel.currentPage, 2);
      expect(responseModel.metaUiModel.totalPages, 4);
      expect(responseModel.metaUiModel.hasNext, isTrue);
      expect(responseModel.metaUiModel.hasPrevious, isTrue);
      expect(responseModel.doctorList, isEmpty);
      expect(responseModel.doctors, isEmpty);
    });

    test('SpecialtyDoctorsSendModel generates query parameters matching Swagger schema', () {
      final sendModel = SpecialtyDoctorsSendModel(
        specialtyId: 'c1a0d001-6f7a-4890-b123-456789abc001',
        search: 'عمر',
        sortBy: 'highestRated',
        location: 'القاهرة',
        area: 'مدينة نصر',
        doctorType: 1,
        minFee: 150.0,
        maxFee: 500.0,
        dateFilter: 'today',
        page: 1,
        pageSize: 20,
      );

      final params = sendModel.toQueryParameters();

      expect(params['search'], 'عمر');
      expect(params['sortBy'], 'highestRated');
      expect(params['location'], 'القاهرة');
      expect(params['area'], 'مدينة نصر');
      expect(params['doctorType'], 1);
      expect(params['minFee'], 150.0);
      expect(params['maxFee'], 500.0);
      expect(params['dateFilter'], 'today');
      expect(params['page'], 1);
      expect(params['pageSize'], 20);
    });

    test('SpecialtyDoctorsSendModel.fromFilter maps UI models correctly', () {
      final sendModel = SpecialtyDoctorsSendModel.fromFilter(
        specialtyId: 'uuid-1',
        search: 'خالد',
        sortOption: DoctorSortOption.nearest,
        filter: const DoctorFilterModel(
          governorate: 'القاهرة',
          area: 'المعادي',
          gender: 2,
          minPrice: 200,
          maxPrice: 600,
          consultationDate: 'tomorrow',
        ),
        page: 2,
        pageSize: 15,
      );

      final params = sendModel.toQueryParameters();
      expect(params['search'], 'خالد');
      expect(params['sortBy'], 'nearest');
      expect(params['location'], 'القاهرة');
      expect(params['area'], 'المعادي');
      expect(params['doctorType'], 2);
      expect(params['minFee'], 200.0);
      expect(params['maxFee'], 600.0);
      expect(params['dateFilter'], 'tomorrow');
      expect(params['page'], 2);
      expect(params['pageSize'], 15);
    });

    test('DoctorListSendModel toMap generates correct parameters', () {
      final sendModel = DoctorListSendModel(
        specialtyId: 'spec-uuid',
        pagination: PagingListSendModel(
          pageNumber: 1,
          pageSize: 20,
          searchText: 'عمر',
        ),
        sortBy: 'nearest',
        governorateId: 'gov-123',
        areaId: 'area-456',
        insuranceCompanyId: 'ins-789',
        doctorType: 1,
        minFee: 100,
        maxFee: 500,
        dateFilter: 1,
      );

      final map = sendModel.toMap();
      expect(map['page'], 1);
      expect(map['pageSize'], 20);
      expect(map['search'], 'عمر');
      expect(map['sortBy'], 'nearest');
      expect(map['governorateId'], 'gov-123');
      expect(map['areaId'], 'area-456');
      expect(map['insuranceCompanyId'], 'ins-789');
      expect(map['doctorType'], 1);
      expect(map['minFee'], 100);
      expect(map['maxFee'], 500);
      expect(map['dateFilter'], 1);
    });

    test('DoctorListsApiModelSuccessfulResponse and DoctorListsUiResponse parse correctly', () {
      final Map<String, dynamic> jsonMap = jsonDecode(sampleApiResponse);
      final apiResponse = DoctorListsApiModelSuccessfulResponse.fromJson(jsonMap);

      expect(apiResponse.doctorList.length, 2);
      expect(apiResponse.metaApiModel.currentPage, 1);
      expect(apiResponse.metaApiModel.totalPages, 1);

      final uiResponse = DoctorListsUiResponse.fromApiModel(apiResponse);
      expect(uiResponse.doctorList.length, 2);
      expect(uiResponse.metaUiModel.currentPage, 1);
      expect(uiResponse.metaUiModel.totalPages, 1);
      expect(uiResponse.metaUiModel.hasPrevious, isFalse);
      expect(uiResponse.metaUiModel.hasNext, isFalse);
    });
  });
}

