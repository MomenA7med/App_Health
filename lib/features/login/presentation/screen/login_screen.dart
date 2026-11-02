import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/login/data/datasources/login_api_manager.dart';
import 'package:app_health/features/login/data/datasources/login_local_datasources.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/login/data/models/login_send_api_model.dart';
import 'package:app_health/features/login/data/repository/login_repository.dart';
import 'package:app_health/features/login/domain/usecases/login_use_case.dart';
import 'package:app_health/features/login/domain/usecases/login_validate_use_case.dart';
import 'package:app_health/features/login/domain/usecases/save_user_info_usecase.dart';
import 'package:app_health/features/login/domain/usecases/set_user_logged_in_usecase.dart';
import 'package:app_health/features/login/presentation/bloc/login_bloc.dart';
import 'package:app_health/features/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:app_health/logic/user_manager.dart';
import 'package:app_health/preferences/preferences_manager.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/validations/app_validate.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/app_colors.dart';
import 'package:app_health/features/register/presentation/screen/register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static const String routeName = '/login';

  static void open({required BuildContext context}) {
    context.go(routeName);
  }

  final PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();
  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    LoginRepository loginRepository = LoginRepository(
      LoginLocaleManager(preferencesManager),
      LoginApiManager(dioApiManager),
    );
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(
        loginUseCase: LoginUseCase(loginRepository),
        loginValidateUseCase: LoginValidateUseCase(),
        saveUserInfoUseCase: SaveUserInfoUseCase(loginRepository),
        setUserLoggedInUseCase: SetUserLoggedInUseCase(loginRepository),
      ),
      child: const LoginScreenWithBloc(),
    );
  }
}

class LoginScreenWithBloc extends BaseStatefulScreenWidget {
  const LoginScreenWithBloc({super.key});

  @override
  BaseScreenState<LoginScreenWithBloc> baseScreenCreateState() =>
      _LoginScreenWithBlocState();
}

class _LoginScreenWithBlocState extends BaseScreenState<LoginScreenWithBloc>
    with AppValidate {
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  UserMangers user = GetIt.I<UserMangers>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool mobileSelected = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  //await UaePassService.instance.initSandbox(language: 'en');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is LoginNotValidatedState) {
            _autoValidateMode = AutovalidateMode.onUserInteraction;
          } else if (state is LoginValidatedState) {
            _loginEventApi();
          } else if (state is LoginSuccessfullyState) {
            _saveUserInfoEvent(state.loginResponseModel);
          } else if (state is LoginErrorState) {
            showFeedbackMessage(
              state.isLocalizationKey
                  ? context.translate(state.errorMassage)
                  : state.errorMassage,
            );
          } else if (state is SavedUserInfoState) {
            _setLoggedInUserEvent();
          } else if (state is SetLoggedInUserState) {}
        },
        builder: (context, state) {
          return buildLoginWidget();
        },
      ),
    );
  }

  Widget buildLoginWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 70.h),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  context.translate(LocalizationKeys.login),
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.buttonBlackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40.h),
              _emailWidget(),
              SizedBox(height: 24.h),
              _passwordWidget(),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Text(
                    context.translate(LocalizationKeys.forgotPassword),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.forgetPassTitle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(
                        AppColors.buttonBackground,
                      ),
                      textStyle: WidgetStateProperty.all(
                        const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: WidgetStateProperty.all(Size.zero),
                    ),
                    onPressed: () {
                      // context.push(ForgetPasswordScreen.routeName);
                    },
                    child: Text(
                      context.translate(LocalizationKeys.clickToReset),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: AppElevatedButton.withTitle(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onPressed: _getStartedClicked,
                  title: context.translate(LocalizationKeys.login),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: Text(
                  context.translate(
                    LocalizationKeys.dontHaveAccount,
                  ), //'Don’t have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.headlineSmall,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: AppElevatedButton.withTitle(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: AppColors.colorSecondary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onPressed: () {
                    RegisterScreen.open(context: context);
                  },
                  color: Colors.transparent,
                  textColor: AppColors.colorSecondary,
                  title: context.translate(LocalizationKeys.createAccount),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24.h),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     Text(
        //       context.translate(LocalizationKeys.userName),
        //       style: TextStyle(
        //         fontSize: 16,
        //         color: AppColors.buttonBlackTextColor,
        //         fontWeight: FontWeight.w400,
        //       ),
        //     ),
        //     Text(
        //       ' *',
        //       style: TextStyle(
        //         fontSize: 16,
        //         color: AppColors.formFieldAsterisk,
        //         fontWeight: FontWeight.w400,
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 10),
        AppTextFormField(
          hintText: context.translate(LocalizationKeys.userNameHint),
          hintTextStyle: TextStyle(
            fontSize: 16,
            color: AppColors.formFieldHintText,
            fontWeight: FontWeight.w400,
          ),
          controller: userNameController,
          validator: emailValidator,
          enableBorderColor: AppColors.formFieldBorder,
          requiredTitle: true,
          title: context.translate(LocalizationKeys.userName),
        ),
      ],
    );
  }

  Widget _passwordWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     Text(
        //       context.translate(LocalizationKeys.password),
        //       style: TextStyle(
        //         fontSize: 16,
        //         color: AppColors.buttonBlackTextColor,
        //         fontWeight: FontWeight.w400,
        //       ),
        //     ),
        //     Text(
        //       ' *',
        //       style: TextStyle(
        //         fontSize: 16,
        //         color: AppColors.formFieldAsterisk,
        //         fontWeight: FontWeight.w400,
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 10),
        AppTextFormField(
          title: context.translate(LocalizationKeys.password),
          requiredTitle: true,
          hintText: context.translate(LocalizationKeys.passwordHint),
          hintTextStyle: TextStyle(
            fontSize: 16,
            color: AppColors.formFieldHintText,
            fontWeight: FontWeight.w400,
          ),
          controller: passwordController,
          validator: passwordValidator,
          enableBorderColor: AppColors.formFieldBorder,
          obscure: true,
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  LoginBloc get currentBloc => context.read<LoginBloc>();

  void _getStartedClicked() {
    FocusManager.instance.primaryFocus?.unfocus();
    currentBloc.add(ValidateLoginEvent(_formKey));
  }

  void _loginEventApi() {
    String userName = userNameController.text;
    currentBloc.add(
      LoginApiEvent(
        LoginSendModel(userName: userName, password: passwordController.text),
      ),
    );
  }

  void _saveUserInfoEvent(LoginResponseApiModel loginResponseModel) {
    currentBloc.add(SaveUserInfoEvent(loginResponseModel));
  }

  void _setLoggedInUserEvent() {
    currentBloc.add(const SetLoggedInUserEvent());
  }
}
