import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/pharmacy_details/data/datasources/pharmacy_details_api_manager.dart';
import 'package:app_health/features/pharmacy_details/data/repository/pharmacy_details_repository.dart';
import 'package:app_health/features/pharmacy_details/domain/repositories/base_pharmacy_details_repository.dart';
import 'package:app_health/features/pharmacy_details/domain/usecases/get_pharmacy_profile_use_case.dart';
import 'package:app_health/features/pharmacy_details/presentation/bloc/pharmacy_details_bloc.dart';
import 'package:app_health/features/pharmacy_details/presentation/bloc/pharmacy_details_event.dart';
import 'package:app_health/features/pharmacy_details/presentation/bloc/pharmacy_details_state.dart';
import 'package:app_health/features/pharmacy_details/presentation/widgets/pharmacy_about_tab_widget.dart';
import 'package:app_health/features/pharmacy_details/presentation/widgets/pharmacy_branches_tab_widget.dart';
import 'package:app_health/features/pharmacy_details/presentation/widgets/pharmacy_details_header_widget.dart';
import 'package:app_health/features/pharmacy_details/presentation/widgets/pharmacy_insurance_tab_widget.dart';
import 'package:app_health/features/send_prescription/presentation/screens/capture_prescription_screen.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/features/widgets/app_error_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PharmacyDetailsScreen extends StatelessWidget {
  final String pharmacyId;
  final BasePharmacyDetailsRepository? repository;

  const PharmacyDetailsScreen({
    super.key,
    required this.pharmacyId,
    this.repository,
  });

  static const String routeName = '/pharmacy-details';

  static void open(
    BuildContext context, {
    required String pharmacyId,
  }) {
    context.push(
      routeName,
      extra: {'pharmacyId': pharmacyId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRepo = repository ??
        PharmacyDetailsRepository(
          PharmacyDetailsApiManager(GetIt.I<DioApiManager>()),
        );

    final useCase = GetPharmacyProfileUseCase(effectiveRepo);

    return BlocProvider<PharmacyDetailsBloc>(
      create: (context) => PharmacyDetailsBloc(
        getPharmacyProfileUseCase: useCase,
      )..add(FetchPharmacyDetailsEvent(pharmacyId: pharmacyId)),
      child: PharmacyDetailsScreenContent(pharmacyId: pharmacyId),
    );
  }
}

class PharmacyDetailsScreenContent extends BaseStatefulScreenWidget {
  final String pharmacyId;

  const PharmacyDetailsScreenContent({
    super.key,
    required this.pharmacyId,
  });

  @override
  BaseScreenState<PharmacyDetailsScreenContent> baseScreenCreateState() =>
      _PharmacyDetailsScreenContentState();
}

class _PharmacyDetailsScreenContentState
    extends BaseScreenState<PharmacyDetailsScreenContent> {
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
      body: BlocConsumer<PharmacyDetailsBloc, PharmacyDetailsState>(
        listener: (context, state) {
          if (state is PharmacyDetailsErrorState) {
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
          if (state is PharmacyDetailsLoadingState ||
              state is PharmacyDetailsInitial) {
            return const Center(child: LoaderWidget());
          }

          if (state is PharmacyDetailsErrorState) {
            return AppErrorWidget(
              errorMessage: state.message,
              isLocalizationKey: state.isMessageLocalizationKey,
              onRetry: () {
                context.read<PharmacyDetailsBloc>().add(
                      FetchPharmacyDetailsEvent(
                        pharmacyId: widget.pharmacyId,
                      ),
                    );
              },
            );
          }

          if (state is PharmacyDetailsLoadedState) {
            final pharmacy = state.pharmacy;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        PharmacyDetailsHeaderWidget(
                          pharmacy: pharmacy,
                          isFavorite: state.isFavorite,
                          activeTab: state.activeTab,
                          onBackTap: () => Navigator.of(context).maybePop(),
                          onFavoriteTap: () {
                            context
                                .read<PharmacyDetailsBloc>()
                                .add(const TogglePharmacyFavoriteEvent());
                          },
                          onCallTap: () => _makePhoneCall(pharmacy.phone),
                          onMessageTap: () => _sendMessage(pharmacy.phone),
                          onTabSelected: (tab) {
                            context
                                .read<PharmacyDetailsBloc>()
                                .add(ChangePharmacyDetailsTabEvent(tabIndex: tab));
                          },
                        ),
                        if (state.activeTab == 0)
                          PharmacyAboutTabWidget(
                            pharmacy: pharmacy,
                          )
                        else if (state.activeTab == 1)
                          PharmacyBranchesTabWidget(
                            branches: pharmacy.branches,
                          )
                        else
                          PharmacyInsuranceTabWidget(
                            insuranceCompanies:
                                pharmacy.acceptedInsuranceCompanies,
                          ),
                      ],
                    ),
                  ),
                ),

                // Sticky Bottom CTA: Send Prescription ("إرسال روشتة")
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        offset: const Offset(0, -2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: AppElevatedButton.withTitle(
                      title: context.translate(LocalizationKeys.sendPrescription),
                      textColor: AppColors.buttonWhiteTextColor,
                      color: AppColors.colorPrimary,
                      onPressed: () {
                        CapturePrescriptionScreen.open(
                          context,
                          preselectedPharmacyId: pharmacy.id,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

