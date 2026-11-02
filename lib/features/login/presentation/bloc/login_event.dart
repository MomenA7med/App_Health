part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}
class LoginWithUaePassEvent extends LoginEvent {
  final String? language;
  const LoginWithUaePassEvent({this.language});
}
class ChangeAutoValidateModeEvent extends LoginEvent {
  final AutovalidateMode mode;

  const ChangeAutoValidateModeEvent(this.mode);
}

class ValidateLoginEvent extends LoginEvent {
  final GlobalKey<FormState> loginFormKey;

  const ValidateLoginEvent(this.loginFormKey);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class LoginApiEvent extends LoginEvent {
  final LoginSendModel loginSendModel;

  const LoginApiEvent(this.loginSendModel);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class SetLoggedInUserEvent extends LoginEvent {
  const SetLoggedInUserEvent();

  @override
  List<Object> get props => [];
}

class SaveUserInfoEvent extends LoginEvent {
  final LoginResponseApiModel loginResponseModel;

  const SaveUserInfoEvent(this.loginResponseModel);

  @override
  List<Object> get props => [];
}
