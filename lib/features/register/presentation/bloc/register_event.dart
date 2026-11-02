part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class ChangeRegisterAutoValidateModeEvent extends RegisterEvent {
  final AutovalidateMode mode;

  const ChangeRegisterAutoValidateModeEvent(this.mode);

  @override
  List<Object> get props => [mode];
}

class ValidateRegisterEvent extends RegisterEvent {
  final GlobalKey<FormState> registerFormKey;

  const ValidateRegisterEvent(this.registerFormKey);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class RegisterApiEvent extends RegisterEvent {
  final RegisterSendModel registerSendModel;

  const RegisterApiEvent(this.registerSendModel);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class SetRegisterLoggedInUserEvent extends RegisterEvent {
  const SetRegisterLoggedInUserEvent();

  @override
  List<Object> get props => [];
}

class SaveRegisterUserInfoEvent extends RegisterEvent {
  final LoginResponseApiModel loginResponseModel;

  const SaveRegisterUserInfoEvent(this.loginResponseModel);

  @override
  List<Object> get props => [loginResponseModel];
}
