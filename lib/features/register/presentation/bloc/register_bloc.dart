import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/failures.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/register/data/models/register_send_api_model.dart';
import 'package:app_health/features/register/domain/usecases/register_save_user_info_usecase.dart';
import 'package:app_health/features/register/domain/usecases/register_set_user_logged_in_usecase.dart';
import 'package:app_health/features/register/domain/usecases/register_use_case.dart';
import 'package:app_health/features/register/domain/usecases/register_validate_use_case.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterValidateUseCase registerValidateUseCase;
  final RegisterUseCase registerUseCase;
  final RegisterSaveUserInfoUseCase saveUserInfoUseCase;
  final RegisterSetUserLoggedInUseCase setUserLoggedInUseCase;

  RegisterBloc({
    required this.registerValidateUseCase,
    required this.registerUseCase,
    required this.saveUserInfoUseCase,
    required this.setUserLoggedInUseCase,
  }) : super(RegisterInitialState()) {
    on<ValidateRegisterEvent>(_validateRegisterEvent);
    on<RegisterApiEvent>(_registerApiEvent);
    on<SaveRegisterUserInfoEvent>(_saveUserInfoEvent);
    on<SetRegisterLoggedInUserEvent>(_setLoggedInUserEvent);
    on<ChangeRegisterAutoValidateModeEvent>((event, emit) {
      emit(RegisterAutoValidationChangedState(event.mode));
    });
  }

  FutureOr<void> _validateRegisterEvent(
    ValidateRegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    Either<Failure, bool> response = await registerValidateUseCase(
      event.registerFormKey,
    );

    emit(
      response.fold(
        (failure) => RegisterNotValidatedState(),
        (state) => RegisterValidatedState(),
      ),
    );
  }

  FutureOr<void> _registerApiEvent(
    RegisterApiEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoadingState());

    final Either<ErrorApiModel, LoginResponseApiModel> response =
        await registerUseCase(event.registerSendModel);
    emit(
      response.fold(
        (error) =>
            RegisterErrorState(error.message, error.isMessageLocalizationKey),
        (success) {
          return RegisterSuccessfullyState(success);
        },
      ),
    );
  }

  FutureOr<void> _setLoggedInUserEvent(
    SetRegisterLoggedInUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoadingState());
    Either<Failure, bool> response = await setUserLoggedInUseCase(NoParams());

    emit(
      response.fold(
        (error) =>
            const RegisterErrorState(LocalizationKeys.somethingWentWrong, true),
        (success) => SetRegisterLoggedInUserState(),
      ),
    );
  }

  FutureOr<void> _saveUserInfoEvent(
    SaveRegisterUserInfoEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoadingState());
    Either<Failure, bool> response = await saveUserInfoUseCase(
      event.loginResponseModel,
    );
    emit(
      response.fold(
        (error) =>
            const RegisterErrorState(LocalizationKeys.somethingWentWrong, true),
        (success) => SavedRegisterUserInfoState(),
      ),
    );
  }
}
