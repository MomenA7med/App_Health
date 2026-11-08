import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/doctor_details/data/datasources/doctor_details_api_manager.dart';
import 'package:app_health/features/doctor_details/data/repository/doctor_details_repository.dart';
import 'package:app_health/features/doctor_details/domain/usecases/get_doctor_profile_use_case.dart';
import 'package:app_health/features/doctor_details/domain/usecases/get_doctor_reviews_use_case.dart';
import 'package:app_health/features/doctor_details/presentation/bloc/doctor_details_bloc.dart';
import 'package:app_health/features/doctor_details/presentation/bloc/doctor_details_event.dart';
import 'package:app_health/features/doctor_details/presentation/bloc/doctor_details_state.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_about_tab_widget.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_booking_bottom_bar_widget.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_details_clinic_card_widget.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_details_header_widget.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_details_tabs_widget.dart';
import 'package:app_health/features/doctor_details/presentation/widgets/doctor_reviews_tab_widget.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final String doctorId;
  final double? consultationFee;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorId,
    this.consultationFee,
  });

  static const String routeName = '/doctor-details';

  static void open(
    BuildContext context, {
    required String doctorId,
    double? consultationFee,
  }) {
    context.push(
      routeName,
      extra: {
        'doctorId': doctorId,
        'consultationFee': consultationFee,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
    final DoctorDetailsRepository repository = DoctorDetailsRepository(
      DoctorDetailsApiManager(dioApiManager),
    );
    final GetDoctorProfileUseCase profileUseCase =
        GetDoctorProfileUseCase(repository);
    final GetDoctorReviewsUseCase reviewsUseCase =
        GetDoctorReviewsUseCase(repository);

    return BlocProvider<DoctorDetailsBloc>(
      create: (BuildContext context) => DoctorDetailsBloc(
        getDoctorProfileUseCase: profileUseCase,
        getDoctorReviewsUseCase: reviewsUseCase,
      )..add(FetchDoctorDetailsEvent(doctorId: doctorId)),
      child: DoctorDetailsScreenContent(
        doctorId: doctorId,
        consultationFee: consultationFee,
      ),
    );
  }
}

class DoctorDetailsScreenContent extends BaseStatefulScreenWidget {
  final String doctorId;
  final double? consultationFee;

  const DoctorDetailsScreenContent({
    super.key,
    required this.doctorId,
    this.consultationFee,
  });

  @override
  BaseScreenState<DoctorDetailsScreenContent> baseScreenCreateState() =>
      _DoctorDetailsScreenContentState();
}

class _DoctorDetailsScreenContentState
    extends BaseScreenState<DoctorDetailsScreenContent> {
  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<DoctorDetailsBloc, DoctorDetailsState>(
        listener: (context, state) {
          if (state is DoctorDetailsErrorState) {
            showFeedbackMessage(
              state.isLocalizationKey
                  ? context.translate(state.errorMessage)
                  : state.errorMessage,
            );
          }
        },
        builder: (context, state) {
          if (state is DoctorDetailsLoadingState) {
            return const Center(child: LoaderWidget());
          }

          if (state is DoctorDetailsErrorState) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 56.r,
                      color: AppColors.errorRed,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.isLocalizationKey
                          ? context.translate(state.errorMessage)
                          : state.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.labelSubtitle,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppElevatedButton.withTitle(
                      title: context.translate(LocalizationKeys.retry),
                      onPressed: () {
                        context.read<DoctorDetailsBloc>().add(
                              FetchDoctorDetailsEvent(
                                doctorId: widget.doctorId,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is DoctorDetailsLoadedState) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Doctor Header Photo + Overlay
                        DoctorDetailsHeaderWidget(
                          doctor: state.doctor,
                          isFavorite: state.isFavorite,
                          onFavoriteTap: () {
                            context
                                .read<DoctorDetailsBloc>()
                                .add(const ToggleDoctorFavoriteEvent());
                          },
                          onBackTap: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              context.pop();
                            }
                          },
                        ),

                        // Overlapping White Content Card
                        Transform.translate(
                          offset: Offset(0, -20.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24.r),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Clinic info & action buttons
                                DoctorDetailsClinicCardWidget(
                                  doctor: state.doctor,
                                ),
                                SizedBox(height: 20.h),

                                // Tabs: 2 tabs (About & Reviews)
                                DoctorDetailsTabsWidget(
                                  activeTab: state.activeTab,
                                  onTabChanged: (tabIndex) {
                                    context.read<DoctorDetailsBloc>().add(
                                          ChangeDoctorDetailsTabEvent(
                                            tabIndex: tabIndex,
                                          ),
                                        );
                                  },
                                ),
                                SizedBox(height: 20.h),

                                // Tab Content
                                if (state.activeTab == 0)
                                  DoctorAboutTabWidget(doctor: state.doctor)
                                else
                                  DoctorReviewsTabWidget(
                                    reviews: state.reviews,
                                    isLoading: state.reviewsLoading,
                                    error: state.reviewsError,
                                  ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Persistent Bottom Booking Bar
                DoctorBookingBottomBarWidget(
                  consultationFee: widget.consultationFee,
                  onProceedTap: () {
                    // Action for booking flow
                  },
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
