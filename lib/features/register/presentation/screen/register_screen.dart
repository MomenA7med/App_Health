import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/login/data/datasources/login_local_datasources.dart';
import 'package:app_health/features/login/data/models/login_response_api_model.dart';
import 'package:app_health/features/login/presentation/screen/login_screen.dart';
import 'package:app_health/features/register/data/datasources/register_api_manager.dart';
import 'package:app_health/features/register/data/models/register_send_api_model.dart';
import 'package:app_health/features/register/data/repository/register_repository.dart';
import 'package:app_health/features/register/domain/usecases/register_save_user_info_usecase.dart';
import 'package:app_health/features/register/domain/usecases/register_set_user_logged_in_usecase.dart';
import 'package:app_health/features/register/domain/usecases/register_use_case.dart';
import 'package:app_health/features/register/domain/usecases/register_validate_use_case.dart';
import 'package:app_health/features/register/presentation/bloc/register_bloc.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/features/widgets/label_with_asterisk_widget.dart';
import 'package:app_health/features/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:app_health/features/widgets/text_field/date_time_form_field_widget.dart';
import 'package:app_health/preferences/preferences_manager.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/format/app_date_format.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';
import 'package:app_health/utils/validations/app_validate.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  static const String routeName = '/register';

  static void open({required BuildContext context}) {
    context.push(routeName);
  }

  final PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();
  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    final RegisterRepository registerRepository = RegisterRepository(
      LoginLocaleManager(preferencesManager),
      RegisterApiManager(dioApiManager),
    );
    return BlocProvider<RegisterBloc>(
      create: (BuildContext context) => RegisterBloc(
        registerUseCase: RegisterUseCase(registerRepository),
        registerValidateUseCase: RegisterValidateUseCase(),
        saveUserInfoUseCase: RegisterSaveUserInfoUseCase(registerRepository),
        setUserLoggedInUseCase: RegisterSetUserLoggedInUseCase(
          registerRepository,
        ),
      ),
      child: const RegisterScreenWithBloc(),
    );
  }
}

class RegisterScreenWithBloc extends BaseStatefulScreenWidget {
  const RegisterScreenWithBloc({super.key});

  @override
  BaseScreenState<RegisterScreenWithBloc> baseScreenCreateState() =>
      _RegisterScreenWithBlocState();
}

class _RegisterScreenWithBlocState
    extends BaseScreenState<RegisterScreenWithBloc>
    with AppValidate {
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  int selectedGender = 1; // 1: Male, 2: Female
  DateTime? selectedDateOfBirth;
  bool acceptTerms = false;
  bool termsError = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.appBarIconColor,
                  size: 20,
                ),
                onPressed: () => context.pop(),
              )
            : null,
        centerTitle: true,
        title: Text(
          context.translate(LocalizationKeys.register),
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.buttonBlackTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) async {
          if (state is RegisterLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is RegisterNotValidatedState) {
            setState(() {
              _autoValidateMode = AutovalidateMode.onUserInteraction;
            });
          } else if (state is RegisterValidatedState) {
            if (!acceptTerms) {
              setState(() {
                termsError = true;
              });
              showFeedbackMessage(
                context.translate(LocalizationKeys.mustAcceptTerms),
              );
              return;
            }
            if (selectedDateOfBirth == null) {
              showFeedbackMessage(context.translate(LocalizationKeys.required));
              return;
            }
            _registerEventApi();
          } else if (state is RegisterSuccessfullyState) {
            _saveUserInfoEvent(state.loginResponseModel);
          } else if (state is RegisterErrorState) {
            showFeedbackMessage(
              state.isLocalizationKey
                  ? context.translate(state.errorMessage)
                  : state.errorMessage,
            );
          } else if (state is SavedRegisterUserInfoState) {
            _setLoggedInUserEvent();
          } else if (state is SetRegisterLoggedInUserState) {
            showFeedbackMessage(
              context.translate(LocalizationKeys.registerSuccess),
            );
            if (context.canPop()) {
              context.pop();
            } else {
              LoginScreen.open(context: context);
            }
          }
        },
        builder: (context, state) {
          return buildRegisterWidget();
        },
      ),
    );
  }

  Widget buildRegisterWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10.h),
              _fullNameWidget(),
              SizedBox(height: 16.h),
              _emailWidget(),
              SizedBox(height: 16.h),
              _phoneWidget(),
              SizedBox(height: 16.h),
              _genderWidget(),
              SizedBox(height: 16.h),
              _dateOfBirthWidget(),
              SizedBox(height: 16.h),
              _addressWidget(),
              SizedBox(height: 16.h),
              _passwordWidget(),
              SizedBox(height: 16.h),
              _confirmPasswordWidget(),
              SizedBox(height: 16.h),
              _acceptTermsWidget(),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: AppElevatedButton.withTitle(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onPressed: _getStartedClicked,
                  title: context.translate(LocalizationKeys.register),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20.h),
              _alreadyHaveAccountWidget(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fullNameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        AppTextFormField(
          title: context.translate(LocalizationKeys.fullName),
          requiredTitle: true,
          hintText: context.translate(LocalizationKeys.fullNameHint),
          hintTextStyle: TextStyle(
            fontSize: 16,
            color: AppColors.formFieldHintText,
            fontWeight: FontWeight.w400,
          ),
          controller: fullNameController,
          validator: fullNameValidator,
          enableBorderColor: AppColors.formFieldBorder,
          textInputType: TextInputType.name,
        ),
      ],
    );
  }

  Widget _emailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        AppTextFormField(
          title: context.translate(LocalizationKeys.email),
          requiredTitle: true,
          hintText: context.translate(LocalizationKeys.emailHint),
          hintTextStyle: TextStyle(
            fontSize: 16,
            color: AppColors.formFieldHintText,
            fontWeight: FontWeight.w400,
          ),
          controller: emailController,
          validator: emailValidator,
          enableBorderColor: AppColors.formFieldBorder,
          textInputType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _phoneWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        AppTextFormField(
          title: context.translate(LocalizationKeys.phoneNumber),
          requiredTitle: true,
          hintText: context.translate(LocalizationKeys.phoneNumberHint),
          hintTextStyle: TextStyle(
            fontSize: 16,
            color: AppColors.formFieldHintText,
            fontWeight: FontWeight.w400,
          ),
          controller: phoneController,
          validator: phoneNumberValidator,
          enableBorderColor: AppColors.formFieldBorder,
          textInputType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _genderWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelWithAsterisk(
          text: context.translate(LocalizationKeys.gender),
          showAsterisk: true,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _genderOptionCard(
                title: context.translate(LocalizationKeys.male),
                genderValue: 1,
                icon: Icons.male,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _genderOptionCard(
                title: context.translate(LocalizationKeys.female),
                genderValue: 2,
                icon: Icons.female,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _genderOptionCard({
    required String title,
    required int genderValue,
    required IconData icon,
  }) {
    final bool isSelected = selectedGender == genderValue;
    return InkWell(
      onTap: () {
        setState(() {
          selectedGender = genderValue;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.colorPrimary.withValues(alpha: 0.08)
              : AppColors.appFormFieldFill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.colorPrimary
                : AppColors.enabledAppFormFieldBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.colorPrimary : AppColors.bodyMedium,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.colorPrimary
                    : AppColors.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateOfBirthWidget() {
    return DateTimeFormFieldWidget(
      title: context.translate(LocalizationKeys.dateOfBirth),
      requiredTitle: true,
      hintText: context.translate(LocalizationKeys.dateOfBirthHint),
      maximumDate: DateTime.now(),
      minimumDate: DateTime(1900),
      initialValue: DateTime(2000),
      onSaved: (date) {
        selectedDateOfBirth = date;
      },
      onChangedDate: (date) {
        setState(() {
          selectedDateOfBirth = date;
        });
      },
      validator: (date) {
        if (date == null) {
          return context.translate(LocalizationKeys.required);
        }
        return null;
      },
    );
  }

  Widget _addressWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        AppTextFormField(
          title: context.translate(LocalizationKeys.address),
          requiredTitle: true,
          hintText: context.translate(LocalizationKeys.addressHint),
          hintTextStyle: TextStyle(
            fontSize: 16,
            color: AppColors.formFieldHintText,
            fontWeight: FontWeight.w400,
          ),
          controller: addressController,
          validator: textValidator,
          enableBorderColor: AppColors.formFieldBorder,
          textInputType: TextInputType.streetAddress,
        ),
      ],
    );
  }

  Widget _passwordWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  Widget _confirmPasswordWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        AppTextFormField(
          title: context.translate(LocalizationKeys.confirmPassword),
          requiredTitle: true,
          hintText: context.translate(LocalizationKeys.confirmPasswordHint),
          hintTextStyle: TextStyle(
            fontSize: 16,
            color: AppColors.formFieldHintText,
            fontWeight: FontWeight.w400,
          ),
          controller: confirmPasswordController,
          validator: (value) =>
              confirmPasswordValidator(context, value, passwordController.text),
          enableBorderColor: AppColors.formFieldBorder,
          obscure: true,
        ),
      ],
    );
  }

  Widget _acceptTermsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: acceptTerms,
              activeColor: AppColors.colorPrimary,
              onChanged: (value) {
                setState(() {
                  acceptTerms = value ?? false;
                  if (acceptTerms) {
                    termsError = false;
                  }
                });
              },
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    acceptTerms = !acceptTerms;
                    if (acceptTerms) {
                      termsError = false;
                    }
                  });
                },
                child: Text(
                  context.translate(LocalizationKeys.acceptTerms),
                  style: TextStyle(
                    fontSize: 13,
                    color: termsError
                        ? AppColors.formFieldAsterisk
                        : AppColors.bodyMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (termsError)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              context.translate(LocalizationKeys.mustAcceptTerms),
              style: const TextStyle(
                color: AppColors.formFieldAsterisk,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _alreadyHaveAccountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.translate(LocalizationKeys.alreadyHaveAccount),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.headlineSmall,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(
              AppColors.buttonBackground,
            ),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: WidgetStateProperty.all(Size.zero),
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              LoginScreen.open(context: context);
            }
          },
          child: Text(context.translate(LocalizationKeys.login)),
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  RegisterBloc get currentBloc => context.read<RegisterBloc>();

  void _getStartedClicked() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!acceptTerms) {
      setState(() {
        termsError = true;
      });
    }
    currentBloc.add(ValidateRegisterEvent(_formKey));
  }

  void _registerEventApi() {
    final String formattedDate = AppDateFormat.formattingApiDate(
      selectedDateOfBirth,
      'en',
    );

    final sendModel = RegisterSendModel(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      gender: selectedGender,
      dateOfBirth: formattedDate,
      address: addressController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      acceptTerms: acceptTerms,
    );

    currentBloc.add(RegisterApiEvent(sendModel));
  }

  void _saveUserInfoEvent(LoginResponseApiModel loginResponseModel) {
    currentBloc.add(SaveRegisterUserInfoEvent(loginResponseModel));
  }

  void _setLoggedInUserEvent() {
    currentBloc.add(const SetRegisterLoggedInUserEvent());
  }
}
