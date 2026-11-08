import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/addresses/data/models/create_address_send_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';

void main() {
  group('UserAddressesResponseModel Tests', () {
    const addressesJson = '''
    {
      "success": true,
      "code": "USER_ADDRESSES_RETRIEVED",
      "message": "Saved addresses retrieved successfully.",
      "data": {
        "items": [
          {
            "id": "4533cb58-4c78-4d91-a432-7bbeffa7aa2e",
            "addressName": "Home",
            "governorate": "e3c2f002-6f7a-4890-b123-456789abd002",
            "area": "e3c2f013-6f7a-4890-b123-456789abd013",
            "detailedAddress": "Home address",
            "isCurrentLocation": true
          }
        ],
        "totalCount": 1,
        "defaultAddressId": "4533cb58-4c78-4d91-a432-7bbeffa7aa2e"
      }
    }
    ''';

    test('parses fromJson and converts to toJson correctly', () {
      final jsonMap = jsonDecode(addressesJson) as Map<String, dynamic>;
      final response = UserAddressesResponseModel.fromJson(jsonMap);

      expect(response.success, true);
      expect(response.code, 'USER_ADDRESSES_RETRIEVED');
      expect(response.message, 'Saved addresses retrieved successfully.');
      expect(response.data.totalCount, 1);
      expect(response.data.defaultAddressId,
          '4533cb58-4c78-4d91-a432-7bbeffa7aa2e');
      expect(response.data.items.length, 1);

      final address = response.data.items.first;
      expect(address.id, '4533cb58-4c78-4d91-a432-7bbeffa7aa2e');
      expect(address.addressName, 'Home');
      expect(address.governorate, 'e3c2f002-6f7a-4890-b123-456789abd002');
      expect(address.area, 'e3c2f013-6f7a-4890-b123-456789abd013');
      expect(address.detailedAddress, 'Home address');
      expect(address.isCurrentLocation, true);

      final serialized = response.toJson();
      expect(serialized['success'], true);
      expect(serialized['data']['totalCount'], 1);
      expect(serialized['data']['items'], isA<List>());
    });

    test('handles empty data gracefully', () {
      final response = UserAddressesResponseModel.fromJson({});
      expect(response.success, false);
      expect(response.data.items, isEmpty);
      expect(response.data.totalCount, 0);
    });
  });

  group('CreateAddress Models Tests', () {
    const createResponseJson = '''
    {
      "success": true,
      "code": "USER_ADDRESS_CREATED",
      "message": "Address saved successfully.",
      "data": {
        "id": "4533cb58-4c78-4d91-a432-7bbeffa7aa2e",
        "addressName": "Work",
        "governorate": "e3c2f001-6f7a-4890-b123-456789abd001",
        "area": "e3c2f011-6f7a-4890-b123-456789abd011",
        "detailedAddress": "Office Building",
        "isCurrentLocation": false
      }
    }
    ''';

    test('parses CreateAddressResponseModel correctly', () {
      final jsonMap = jsonDecode(createResponseJson) as Map<String, dynamic>;
      final response = CreateAddressResponseModel.fromJson(jsonMap);

      expect(response.success, true);
      expect(response.code, 'USER_ADDRESS_CREATED');
      expect(response.message, 'Address saved successfully.');
      expect(response.data.id, '4533cb58-4c78-4d91-a432-7bbeffa7aa2e');
      expect(response.data.addressName, 'Work');
      expect(response.data.governorate, 'e3c2f001-6f7a-4890-b123-456789abd001');
      expect(response.data.area, 'e3c2f011-6f7a-4890-b123-456789abd011');
      expect(response.data.detailedAddress, 'Office Building');
      expect(response.data.isCurrentLocation, false);

      final serialized = response.toJson();
      expect(serialized['success'], true);
      expect(serialized['data']['addressName'], 'Work');
    });

    test('CreateAddressSendModel serializes correctly', () {
      const model = CreateAddressSendModel(
        addressName: 'Home',
        governorate: 'gov_123',
        area: 'area_456',
        detailedAddress: 'Street 9',
        isCurrentLocation: true,
      );

      final json = model.toJson();
      expect(json['addressName'], 'Home');
      expect(json['governorate'], 'gov_123');
      expect(json['area'], 'area_456');
      expect(json['detailedAddress'], 'Street 9');
      expect(json['isCurrentLocation'], true);
      expect(model.props, [
        'Home',
        'gov_123',
        'area_456',
        'Street 9',
        true,
      ]);
    });
  });
}

