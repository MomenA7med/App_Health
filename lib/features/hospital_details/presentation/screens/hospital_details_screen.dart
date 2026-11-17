import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/doctor_list/presentation/screens/doctor_list_screen.dart';
import 'package:app_health/features/hospital_details/data/datasources/hospital_details_api_manager.dart';
import 'package:app_health/features/hospital_details/data/repository/hospital_details_repository.dart';
import 'package:app_health/features/hospital_details/domain/repositories/base_hospital_details_repository.dart';
import 'package:app_health/features/hospital_details/domain/usecases/get_hospital_profile_use_case.dart';
import 'package:app_health/features/hospital_details/presentation/bloc/hospital_details_bloc.dart';
import 'package:app_health/features/hospital_details/presentation/bloc/hospital_details_event.dart';
import 'package:app_health/features/hospital_details/presentation/bloc/hospital_details_state.dart';
import 'package:app_health/features/hospital_details/presentation/widgets/hospital_about_tab_widget.dart';
import 'package:app_health/features/hospital_details/presentation/widgets/hospital_details_header_widget.dart';
import 'package:app_health/features/hospital_details/presentation/widgets/hospital_insurance_tab_widget.dart';
import 'package:app_health/features/hospital_details/presentation/widgets/hospital_specialties_tab_widget.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class HospitalDetailsScreen extends StatelessWidget {
  final String hospitalId;
  final BaseHospitalDetailsRepository? repository;

  const HospitalDetailsScreen({
    super.key,
    required this.hospitalId,
    this.repository,
  });

  static const String routeName = '/hospital-details';

  static void open(
    BuildContext context, {
    required String hospitalId,
  }) {
    context.push(
      routeName,
      extra: {'hospitalId': hospitalId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRepo = repository ??
        HospitalDetailsRepository(
          HospitalDetailsApiManager(GetIt.I<DioApiManager>()),
        );

    final useCase = GetHospitalProfileUseCase(effectiveRepo);

    return BlocProvider<HospitalDetailsBloc>(
      create: (context) => HospitalDetailsBloc(
        getHospitalProfileUseCase: useCase,
      )..add(FetchHospitalDetailsEvent(hospitalId: hospitalId)),
      child: HospitalDetailsScreenContent(hospitalId: hospitalId),
    );
  }
}

class HospitalDetailsScreenContent extends BaseStatefulScreenWidget {
  final String hospitalId;

  const HospitalDetailsScreenContent({
    super.key,
    required this.hospitalId,
  });

  @override
  BaseScreenState<HospitalDetailsScreenContent> baseScreenCreateState() =>
      _HospitalDetailsScreenContentState();
}

class _HospitalDetailsScreenContentState
    extends BaseScreenState<HospitalDetailsScreenContent> {
  void _makePhoneCall(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    final Uri uri = Uri(scheme: 'tel', path: phone.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _sendMessage(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    final Uri uri = Uri(scheme: 'sms', path: phone.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<HospitalDetailsBloc, HospitalDetailsState>(
        listener: (context, state) {
          if (state is HospitalDetailsErrorState) {
            final msg = state.isMessageLocalizationKey
                ? context.translate(state.message)
                : state.message;
            showFeedbackMessage(
              msg,
              context: context,
              feedbackStyle: FeedbackStyle.snackBar,
            );
          }
        },
        builder: (context, state) {
          if (state is HospitalDetailsLoadingState ||
              state is HospitalDetailsInitial) {
            return const Center(child: LoaderWidget());
          }

          if (state is HospitalDetailsErrorState) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 54.r,
                      color: AppColors.errorRed,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      state.isMessageLocalizationKey
                          ? context.translate(state.message)
                          : state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.buttonBlackTextColor,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    AppElevatedButton.withTitle(
                      title: context.translate(LocalizationKeys.retry),
                      color: AppColors.colorPrimary,
                      textColor: AppColors.white,
                      onPressed: () {
                        context.read<HospitalDetailsBloc>().add(
                              FetchHospitalDetailsEvent(
                                hospitalId: widget.hospitalId,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is HospitalDetailsLoadedState) {
            final hospital = state.hospital;

            return SingleChildScrollView(
              child: Column(
                children: [
                  HospitalDetailsHeaderWidget(
                    hospital: hospital,
                    isFavorite: state.isFavorite,
                    activeTab: state.activeTab,
                    onBackTap: () => Navigator.of(context).maybePop(),
                    onFavoriteTap: () {
                      context
                          .read<HospitalDetailsBloc>()
                          .add(const ToggleHospitalFavoriteEvent());
                    },
                    onCallTap: () => _makePhoneCall(hospital.phone),
                    onMessageTap: () => _sendMessage(hospital.phone),
                    onTabSelected: (tab) {
                      context
                          .read<HospitalDetailsBloc>()
                          .add(ChangeHospitalDetailsTabEvent(tabIndex: tab));
                    },
                  ),
                  if (state.activeTab == 0)
                    HospitalSpecialtiesTabWidget(
                      specialties: hospital.specialties,
                      onSpecialtyTap: (specialty) {
                        DoctorListScreen.open(
                          context: context,
                          specialtyId: specialty.id,
                          specialtyTitle: specialty.getName(context),
                        );
                      },
                    )
                  else if (state.activeTab == 1)
                    HospitalInsuranceTabWidget(
                      insuranceCompanies: hospital.acceptedInsuranceCompanies,
                    )
                  else
                    HospitalAboutTabWidget(
                      hospital: hospital,
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
