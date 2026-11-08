import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/doctor_list/data/models/insurance_company_model.dart';

void main() {
  group('InsuranceCompanyModel and Response Tests', () {
    const insuranceJson = '''
    {
      "success": true,
      "code": "INSURANCE_COMPANIES_RETRIEVED",
      "message": "Insurance companies retrieved successfully.",
      "data": [
        {
          "id": "79799fc6-a987-47f2-95f9-8d03fbb767c8",
          "nameAr": "Company1",
          "nameEn": "شركه ١",
          "logoUrl": "https://img.magnific.com/premium-vector/creative-elegant-abstract-minimalistic-logo-design-vector-any-brand-company_1253202-136451.jpg?semt=ais_hybrid&w=740&q=80"
        }
      ]
    }
    ''';

    test('parses fromJson and converts to toJson correctly', () {
      final jsonMap = jsonDecode(insuranceJson) as Map<String, dynamic>;
      final response = InsuranceCompaniesResponseModel.fromJson(jsonMap);

      expect(response.success, true);
      expect(response.code, 'INSURANCE_COMPANIES_RETRIEVED');
      expect(response.message, 'Insurance companies retrieved successfully.');
      expect(response.data.length, 1);

      final company = response.data.first;
      expect(company.id, '79799fc6-a987-47f2-95f9-8d03fbb767c8');
      expect(company.nameAr, 'Company1');
      expect(company.nameEn, 'شركه ١');
      expect(company.logoUrl, contains('img.magnific.com'));

      expect(company.localizedName('ar'), 'Company1');
      expect(company.localizedName('en'), 'شركه ١');

      final serialized = response.toJson();
      expect(serialized['success'], true);
      expect(serialized['data'], isA<List>());
    });
  });

  group('GovernoratesResponseModel Tests', () {
    const governoratesJson = '''
    {
      "success": true,
      "code": "GOVERNORATES_RETRIEVED",
      "message": "Governorates retrieved successfully.",
      "data": [
        {
          "id": "e3c2f002-6f7a-4890-b123-456789abd002",
          "name": "الجيزة",
          "areas": [
            {
              "id": "e3c2f013-6f7a-4890-b123-456789abd013",
              "governorateId": "e3c2f002-6f7a-4890-b123-456789abd002",
              "name": "المهندسين"
            }
          ]
        },
        {
          "id": "e3c2f001-6f7a-4890-b123-456789abd001",
          "name": "القاهرة",
          "areas": [
            {
              "id": "e3c2f012-6f7a-4890-b123-456789abd012",
              "governorateId": "e3c2f001-6f7a-4890-b123-456789abd001",
              "name": "المعادي"
            },
            {
              "id": "e3c2f011-6f7a-4890-b123-456789abd011",
              "governorateId": "e3c2f001-6f7a-4890-b123-456789abd001",
              "name": "مدينة نصر"
            }
          ]
        }
      ]
    }
    ''';

    test('parses fromJson and converts to toJson correctly', () {
      final jsonMap = jsonDecode(governoratesJson) as Map<String, dynamic>;
      final response = GovernoratesResponseModel.fromJson(jsonMap);

      expect(response.success, true);
      expect(response.code, 'GOVERNORATES_RETRIEVED');
      expect(response.data.length, 2);

      final giza = response.data[0];
      expect(giza.id, 'e3c2f002-6f7a-4890-b123-456789abd002');
      expect(giza.name, 'الجيزة');
      expect(giza.areas.length, 1);
      expect(giza.areas.first.name, 'المهندسين');
      expect(giza.areas.first.governorateId, giza.id);

      final cairo = response.data[1];
      expect(cairo.name, 'القاهرة');
      expect(cairo.areas.length, 2);
      expect(cairo.areas[0].name, 'المعادي');
      expect(cairo.areas[1].name, 'مدينة نصر');

      final serialized = response.toJson();
      expect(serialized['success'], true);
      expect((serialized['data'] as List).length, 2);
    });
  });

  group('DoctorFilterModel with new location & lookup fields', () {
    test('initial values match defaults', () {
      const initial = DoctorFilterModel.initial;
      expect(initial.minPrice, 0);
      expect(initial.maxPrice, 1000);
      expect(initial.governorate, isNull);
      expect(initial.area, isNull);
      expect(initial.locationMode, 'area');
      expect(initial.gender, 0);
      expect(initial.consultationDate, 'any');
    });

    test('copyWith updates fields as expected', () {
      const filter = DoctorFilterModel.initial;
      final updated = filter.copyWith(
        locationMode: 'saved',
        governorate: 'الجيزة',
        governorateId: 'gov-2',
        area: 'المهندسين',
        areaId: 'area-13',
        gender: 1,
        minPrice: 300,
        maxPrice: 900,
        consultationDate: 'today',
        insuranceCompany: 'Company1',
        insuranceCompanyId: 'ins-1',
      );

      expect(updated.locationMode, 'saved');
      expect(updated.governorate, 'الجيزة');
      expect(updated.governorateId, 'gov-2');
      expect(updated.area, 'المهندسين');
      expect(updated.areaId, 'area-13');
      expect(updated.gender, 1);
      expect(updated.minPrice, 300);
      expect(updated.maxPrice, 900);
      expect(updated.consultationDate, 'today');
      expect(updated.insuranceCompany, 'Company1');
      expect(updated.insuranceCompanyId, 'ins-1');
      expect(updated.hasActiveFilters, true);
    });
  });
}

