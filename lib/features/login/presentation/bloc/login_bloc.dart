import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/failures.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/login/data/models/login_send_api_model.dart';
import 'package:app_health/features/login/domain/usecases/login_use_case.dart';
import 'package:app_health/features/login/domain/usecases/login_validate_use_case.dart';
import 'package:app_health/features/login/domain/usecases/save_user_info_usecase.dart';
import 'package:app_health/features/login/domain/usecases/set_user_logged_in_usecase.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginValidateUseCase loginValidateUseCase;
  final LoginUseCase loginUseCase;
  final SaveUserInfoUseCase saveUserInfoUseCase;
  final SetUserLoggedInUseCase setUserLoggedInUseCase;

  LoginBloc({
    required this.loginValidateUseCase,
    required this.loginUseCase,
    required this.saveUserInfoUseCase,
    required this.setUserLoggedInUseCase,
  }) : super(LoginInitialState()) {
    on<ValidateLoginEvent>(_validateLoginEvent);
    on<LoginApiEvent>(_loginApiEvent);
    on<SaveUserInfoEvent>(_saveUserInfoEvent);
    on<SetLoggedInUserEvent>(_setLoggedInUserEvent);
    on<ChangeAutoValidateModeEvent>((event, emit) {
      emit(AutoValidationChangedState(event.mode));
    });
  }

  FutureOr<void> _validateLoginEvent(
    ValidateLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    Either<Failure, bool> response = await loginValidateUseCase(
      event.loginFormKey,
    );

    emit(
      response.fold(
        (failure) => LoginNotValidatedState(),
        (state) => LoginValidatedState(),
      ),
    );
  }

  FutureOr<void> _loginApiEvent(
    LoginApiEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());

    final Either<ErrorApiModel, LoginResponseApiModel> response =
        await loginUseCase(event.loginSendModel);
    emit(
      response.fold(
        (error) =>
            LoginErrorState(error.message, error.isMessageLocalizationKey),
        (success) {
          return LoginSuccessfullyState(success);
        },
      ),
    );
  }


  FutureOr<void> _setLoggedInUserEvent(
    SetLoggedInUserEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());
    Either<Failure, bool> response = await setUserLoggedInUseCase(NoParams());

    emit(
      response.fold(
        (error) =>
            const LoginErrorState(LocalizationKeys.somethingWentWrong, true),
        (success) => SetLoggedInUserState(),
      ),
    );
  }

  FutureOr<void> _saveUserInfoEvent(
    SaveUserInfoEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());
    Either<Failure, bool> response = await saveUserInfoUseCase(
      event.loginResponseModel,
    );
    emit(
      response.fold(
        (error) =>
            const LoginErrorState(LocalizationKeys.somethingWentWrong, true),
        (success) => SavedUserInfoState(),
      ),
    );
  }
}
