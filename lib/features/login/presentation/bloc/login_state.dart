part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  final AutovalidateMode autoValidateMode;

  const LoginState({this.autoValidateMode = AutovalidateMode.disabled});

  @override
  List<Object> get props => [autoValidateMode];
}

class AutoValidationChangedState extends LoginState {
  final AutovalidateMode mode;

  const AutoValidationChangedState(this.mode);

  @override
  List<Object> get props => [mode];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String errorMassage;
  final bool isLocalizationKey;

  const LoginErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class ErrorState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class LoginValidatedState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class LoginNotValidatedState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class LoginSuccessfullyState extends LoginState {
  final LoginResponseApiModel loginResponseModel;

  const LoginSuccessfullyState(this.loginResponseModel);

  @override
  List<Object> get props => [loginResponseModel];
}

class SavedUserInfoState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SetLoggedInUserState extends LoginState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

