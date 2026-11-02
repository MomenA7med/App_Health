import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';

void main() {
  test('LoginResponseApiModel parses response json correctly', () {
    const rawJson = '''
{
  "success": true,
  "code": "LOGIN_SUCCESS",
  "message": "Login successful.",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwMWExNWVkNy1iNTA2LTcyYmItODYxMi1jOGFlNzUzOTJiNDEiLCJlbWFpbCI6Im1vbWVuQG1haWwuY29tIiwianRpIjoiYmQ5YmZlYzgtMTM2Mi00MTY3LThjMTUtN2I2MmMxNWU3MTJkIiwicm9sZSI6IlBhdGllbnQiLCJuYmYiOjE3OTI1OTI4MDEsImV4cCI6MTc5MjU5NjQwMSwiaXNzIjoiSGVhbHRoQXBwIiwiYXVkIjoiSGVhbHRoQXBwLkNsaWVudHMifQ.02W92vlLwcvv-PBlyyMcmU8FIBXqu7IJ_Kzd7PKG_f8",
    "expiresAt": "2026-10-21T15:26:41.7704426Z",
    "userId": "01a15ed7-b506-72bb-8612-c8ae75392b41",
    "role": 1,
    "requiresProfileCompletion": false,
    "missingFields": [],
    "profile": {
      "userId": "01a15ed7-b506-72bb-8612-c8ae75392b41",
      "fullName": "Momen",
      "email": "momen@mail.com",
      "phoneNumber": "01120304567",
      "gender": 1,
      "dateOfBirth": "1997-10-21",
      "address": "Minia",
      "profilePhotoUrl": null
    }
  }
}
''';

    final Map<String, dynamic> jsonMap = jsonDecode(rawJson);
    final model = LoginResponseApiModel.fromJson(jsonMap);

    expect(model.success, isTrue);
    expect(model.code, 'LOGIN_SUCCESS');
    expect(model.message, 'Login successful.');
    expect(model.data, isNotNull);
    expect(model.token, startsWith('eyJhbGciOi'));
    expect(model.data!.userId, '01a15ed7-b506-72bb-8612-c8ae75392b41');
    expect(model.data!.role, 1);
    expect(model.data!.requiresProfileCompletion, isFalse);
    expect(model.data!.missingFields, isEmpty);
    expect(model.data!.expiresAt, isNotNull);

    final profile = model.data!.profile;
    expect(profile, isNotNull);
    expect(profile!.fullName, 'Momen');
    expect(profile.email, 'momen@mail.com');
    expect(profile.phoneNumber, '01120304567');
    expect(profile.gender, 1);
    expect(profile.dateOfBirth, '1997-10-21');
    expect(profile.address, 'Minia');
    expect(profile.profilePhotoUrl, isNull);

    final encoded = model.toJson();
    expect(encoded['success'], isTrue);
    expect(encoded['data']['profile']['fullName'], 'Momen');
  });
}
