import 'package:app_health/logic/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/medical_specialties/data/datasources/medical_specialties_api_manager.dart';
import 'package:app_health/features/medical_specialties/data/repository/medical_specialties_repository.dart';
import 'package:app_health/features/medical_specialties/domain/usecases/get_medical_specialties_usecase.dart';
import 'package:app_health/features/medical_specialties/presentation/bloc/medical_specialties_bloc.dart';
import 'package:app_health/features/doctor_list/presentation/screens/doctor_list_screen.dart';
import 'package:app_health/features/medical_specialties/presentation/widgets/medical_specialties_header_widget.dart';
import 'package:app_health/features/medical_specialties/presentation/widgets/medical_specialties_search_bar_widget.dart';
import 'package:app_health/features/medical_specialties/presentation/widgets/medical_specialty_card_widget.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class MedicalSpecialtiesScreen extends StatelessWidget {
  const MedicalSpecialtiesScreen({super.key});

  static const String routeName = '/medical-specialties';

  static void open({required BuildContext context}) {
    context.go(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
    final MedicalSpecialtiesRepository repository =
        MedicalSpecialtiesRepository(
          MedicalSpecialtiesApiManager(dioApiManager),
        );
    final GetMedicalSpecialtiesUseCase useCase = GetMedicalSpecialtiesUseCase(
      repository,
    );

    return BlocProvider<MedicalSpecialtiesBloc>(
      create: (BuildContext context) =>
          MedicalSpecialtiesBloc(getMedicalSpecialtiesUseCase: useCase)
            ..add(const FetchMedicalSpecialtiesEvent()),
      child: const MedicalSpecialtiesScreenWithBloc(),
    );
  }
}

class MedicalSpecialtiesScreenWithBloc extends BaseStatefulScreenWidget {
  const MedicalSpecialtiesScreenWithBloc({super.key});

  @override
  BaseScreenState<MedicalSpecialtiesScreenWithBloc> baseScreenCreateState() =>
      _MedicalSpecialtiesScreenWithBlocState();
}

class _MedicalSpecialtiesScreenWithBlocState
    extends BaseScreenState<MedicalSpecialtiesScreenWithBloc> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.translate(LocalizationKeys.medicalSpecialties),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.buttonBlackTextColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await GetIt.I<UserMangers>().signOut();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: BlocConsumer<MedicalSpecialtiesBloc, MedicalSpecialtiesState>(
        listener: (context, state) {
          if (state is MedicalSpecialtiesErrorState) {
            showFeedbackMessage(
              state.isLocalizationKey
                  ? context.translate(state.errorMessage)
                  : state.errorMessage,
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.colorPrimary,
            onRefresh: () async {
              context.read<MedicalSpecialtiesBloc>().add(
                const FetchMedicalSpecialtiesEvent(),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  const MedicalSpecialtiesHeaderWidget(),
                  SizedBox(height: 16.h),
                  MedicalSpecialtiesSearchBarWidget(
                    controller: _searchController,
                    onChanged: (query) {
                      context.read<MedicalSpecialtiesBloc>().add(
                        SearchSpecialtiesEvent(query),
                      );
                    },
                    onClear: () {
                      _searchController.clear();
                      context.read<MedicalSpecialtiesBloc>().add(
                        const SearchSpecialtiesEvent(''),
                      );
                    },
                  ),
                  SizedBox(height: 18.h),
                  Expanded(child: _buildContent(context, state)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MedicalSpecialtiesState state) {
    if (state is MedicalSpecialtiesLoadingState ||
        state is MedicalSpecialtiesInitialState) {
      return const Center(child: LoaderWidget());
    }

    if (state is MedicalSpecialtiesErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.redButtonColor,
              size: 48.r,
            ),
            SizedBox(height: 12.h),
            Text(
              state.isLocalizationKey
                  ? context.translate(state.errorMessage)
                  : state.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.labelSubtitle),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: 140.w,
              child: AppElevatedButton.withTitle(
                onPressed: () {
                  context.read<MedicalSpecialtiesBloc>().add(
                    const FetchMedicalSpecialtiesEvent(),
                  );
                },
                title: context.translate(LocalizationKeys.retry),
              ),
            ),
          ],
        ),
      );
    }

    if (state is MedicalSpecialtiesLoadedState) {
      if (state.filteredSpecialties.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                color: AppColors.textSecondary,
                size: 56.r,
              ),
              SizedBox(height: 12.h),
              Text(
                context.translate(LocalizationKeys.noSpecialtiesFound),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.labelSubtitle,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.only(bottom: 24.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
          childAspectRatio: 169 / 120,
        ),
        itemCount: state.filteredSpecialties.length,
        itemBuilder: (context, index) {
          final specialty = state.filteredSpecialties[index];
          return MedicalSpecialtyCardWidget(
            specialty: specialty,
            onTap: () {
              DoctorListScreen.open(
                context: context,
                specialtyId: specialty.id,
                specialtyTitle: specialty.getName(context),
              );
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
