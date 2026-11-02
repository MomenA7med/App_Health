import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/register/data/models/register_send_api_model.dart';
import 'package:app_health/features/register/domain/repositories/base_register_repository.dart';
import 'package:app_health/features/register/domain/usecases/register_save_user_info_usecase.dart';
import 'package:app_health/features/register/domain/usecases/register_set_user_logged_in_usecase.dart';
import 'package:app_health/features/register/domain/usecases/register_use_case.dart';
import 'package:app_health/features/register/domain/usecases/register_validate_use_case.dart';
import 'package:app_health/features/register/presentation/bloc/register_bloc.dart';

class FakeRegisterRepository implements BaseRegisterRepository {
  bool shouldFail = false;
  bool saveUserInfoCalled = false;
  bool setLoginUserCalled = false;

  @override
  Future<LoginResponseApiModel> register(RegisterSendModel register) async {
    if (shouldFail) {
      throw Exception('Registration failed');
    }
    return LoginResponseApiModel(
      success: true,
      code: 'REGISTER_SUCCESS',
      message: 'Registration successful.',
      data: LoginDataModel(
        accessToken: 'mock_token',
        userId: 'patient-123',
        role: 1,
        requiresProfileCompletion: false,
        missingFields: [],
        profile: UserProfileModel(
          userId: 'patient-123',
          fullName: register.fullName,
          email: register.email,
          phoneNumber: register.phoneNumber,
          gender: register.gender,
          dateOfBirth: register.dateOfBirth,
          address: register.address,
        ),
      ),
    );
  }

  @override
  Future<void> saveUserInfo(LoginResponseApiModel loginResponseModel) async {
    saveUserInfoCalled = true;
  }

  @override
  Future<void> setLoginUser() async {
    setLoginUserCalled = true;
  }
}

void main() {
  group('RegisterSendModel Tests', () {
    test('toMap serializes all required fields correctly', () {
      const model = RegisterSendModel(
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '01234567890',
        gender: 1,
        dateOfBirth: '2026-10-22',
        address: '123 Main St',
        password: 'Password123!',
        confirmPassword: 'Password123!',
        acceptTerms: true,
      );

      final map = model.toMap();

      expect(map['fullName'], 'Test User');
      expect(map['email'], 'test@example.com');
      expect(map['phoneNumber'], '01234567890');
      expect(map['gender'], 1);
      expect(map['dateOfBirth'], '2026-10-22');
      expect(map['address'], '123 Main St');
      expect(map['password'], 'Password123!');
      expect(map['confirmPassword'], 'Password123!');
      expect(map['acceptTerms'], true);
    });

    test('Register response parses correctly with same login model', () {
      const rawJson = '''
      {
        "success": true,
        "code": "REGISTER_SUCCESS",
        "message": "Registered successfully",
        "data": {
          "accessToken": "sample_token",
          "userId": "usr-001",
          "role": 1,
          "requiresProfileCompletion": false,
          "missingFields": [],
          "profile": {
            "userId": "usr-001",
            "fullName": "Jane Doe",
            "email": "jane@example.com",
            "phoneNumber": "01123456789",
            "gender": 2,
            "dateOfBirth": "1995-05-15",
            "address": "Cairo"
          }
        }
      }
      ''';

      final model = LoginResponseApiModel.fromJson(jsonDecode(rawJson));
      expect(model.success, isTrue);
      expect(model.data?.profile?.fullName, 'Jane Doe');
      expect(model.data?.profile?.gender, 2);
      expect(model.data?.profile?.dateOfBirth, '1995-05-15');
      expect(model.data?.profile?.address, 'Cairo');
    });
  });

  group('RegisterBloc Tests', () {
    late FakeRegisterRepository repository;
    late RegisterBloc bloc;

    setUp(() {
      repository = FakeRegisterRepository();
      bloc = RegisterBloc(
        registerUseCase: RegisterUseCase(repository),
        registerValidateUseCase: RegisterValidateUseCase(),
        saveUserInfoUseCase: RegisterSaveUserInfoUseCase(repository),
        setUserLoggedInUseCase: RegisterSetUserLoggedInUseCase(repository),
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is RegisterInitialState', () {
      expect(bloc.state, isA<RegisterInitialState>());
    });

    test('ChangeRegisterAutoValidateModeEvent emits RegisterAutoValidationChangedState', () async {
      bloc.add(const ChangeRegisterAutoValidateModeEvent(AutovalidateMode.always));
      await expectLater(
        bloc.stream,
        emits(const RegisterAutoValidationChangedState(AutovalidateMode.always)),
      );
    });

    test('RegisterApiEvent emits loading then successfully state on success', () async {
      const sendModel = RegisterSendModel(
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '01234567890',
        gender: 1,
        dateOfBirth: '2026-10-22',
        address: '123 Main St',
        password: 'Password123!',
        confirmPassword: 'Password123!',
        acceptTerms: true,
      );

      bloc.add(const RegisterApiEvent(sendModel));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<RegisterLoadingState>(),
          isA<RegisterSuccessfullyState>(),
        ]),
      );
    });

    test('SaveRegisterUserInfoEvent and SetRegisterLoggedInUserEvent work as expected', () async {
      final responseModel = LoginResponseApiModel(
        success: true,
        code: 'SUCCESS',
        message: 'Success',
      );

      bloc.add(SaveRegisterUserInfoEvent(responseModel));
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<RegisterLoadingState>(),
          isA<SavedRegisterUserInfoState>(),
        ]),
      );
      expect(repository.saveUserInfoCalled, isTrue);

      bloc.add(const SetRegisterLoggedInUserEvent());
      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<RegisterLoadingState>(),
          isA<SetRegisterLoggedInUserState>(),
        ]),
      );
      expect(repository.setLoginUserCalled, isTrue);
    });
  });
}
