part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  final AutovalidateMode autoValidateMode;

  const RegisterState({this.autoValidateMode = AutovalidateMode.disabled});

  @override
  List<Object> get props => [autoValidateMode];
}

class RegisterAutoValidationChangedState extends RegisterState {
  final AutovalidateMode mode;

  const RegisterAutoValidationChangedState(this.mode);

  @override
  List<Object> get props => [mode];
}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  final String errorMessage;
  final bool isLocalizationKey;

  const RegisterErrorState(this.errorMessage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMessage, isLocalizationKey];
}

class RegisterValidatedState extends RegisterState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class RegisterNotValidatedState extends RegisterState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class RegisterSuccessfullyState extends RegisterState {
  final LoginResponseApiModel loginResponseModel;

  const RegisterSuccessfullyState(this.loginResponseModel);

  @override
  List<Object> get props => [loginResponseModel];
}

class SavedRegisterUserInfoState extends RegisterState {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class SetRegisterLoggedInUserState extends RegisterState {
  @override
  List<Object> get props => [identityHashCode(this)];
}
