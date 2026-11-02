import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/doctor_list/data/datasources/doctor_list_api_manager.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/doctor_list/data/repository/doctor_list_repository.dart';
import 'package:app_health/features/doctor_list/domain/usecases/get_specialty_doctors_usecase.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_bloc.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_event.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_state.dart';
import 'package:app_health/features/doctor_list/presentation/screens/doctor_list_filter_screen.dart';
import 'package:app_health/features/doctor_list/presentation/widgets/doctor_card_widget.dart';
import 'package:app_health/features/doctor_list/presentation/widgets/doctor_search_bar_widget.dart';
import 'package:app_health/features/doctor_list/presentation/widgets/doctor_sort_bottom_sheet_widget.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class DoctorListScreen extends StatelessWidget {
  final String specialtyId;
  final String specialtyTitle;

  const DoctorListScreen({
    super.key,
    required this.specialtyId,
    required this.specialtyTitle,
  });

  static const String routeName = '/doctor-list';

  static void open({
    required BuildContext context,
    required String specialtyId,
    required String specialtyTitle,
  }) {
    context.push(
      routeName,
      extra: {
        'specialtyId': specialtyId,
        'specialtyTitle': specialtyTitle,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
    final DoctorListRepository repository = DoctorListRepository(
      DoctorListApiManager(dioApiManager),
    );
    final GetSpecialtyDoctorsUseCase useCase = GetSpecialtyDoctorsUseCase(
      repository,
    );

    return BlocProvider<DoctorListBloc>(
      create: (BuildContext context) =>
          DoctorListBloc(getSpecialtyDoctorsUseCase: useCase)
            ..add(FetchSpecialtyDoctorsEvent(specialtyId: specialtyId)),
      child: DoctorListScreenWithBloc(
        specialtyId: specialtyId,
        specialtyTitle: specialtyTitle,
      ),
    );
  }
}

class DoctorListScreenWithBloc extends BaseStatefulScreenWidget {
  final String specialtyId;
  final String specialtyTitle;

  const DoctorListScreenWithBloc({
    super.key,
    required this.specialtyId,
    required this.specialtyTitle,
  });

  @override
  BaseScreenState<DoctorListScreenWithBloc> baseScreenCreateState() =>
      _DoctorListScreenWithBlocState();
}

class _DoctorListScreenWithBlocState
    extends BaseScreenState<DoctorListScreenWithBloc> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getSortOptionLabel(BuildContext context, DoctorSortOption option) {
    switch (option) {
      case DoctorSortOption.nearest:
        return context.translate(LocalizationKeys.nearestToYou);
      case DoctorSortOption.highestRated:
        return context.translate(LocalizationKeys.highestRated);
      case DoctorSortOption.priceLowToHigh:
        return context.translate(LocalizationKeys.priceLowToHigh);
      case DoctorSortOption.priceHighToLow:
        return context.translate(LocalizationKeys.priceHighToLow);
    }
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button on the right (RTL start)
        InkWell(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.pop();
            }
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.r,
              color: AppColors.buttonBlackTextColor,
            ),
          ),
        ),

        // Location Selector Pill on the left/center (RTL end)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18.r,
                color: AppColors.colorPrimary,
              ),
              SizedBox(width: 6.w),
              Text(
                context.translate(LocalizationKeys.defaultLocation),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.buttonBlackTextColor,
                ),
              ),
              SizedBox(width: 4.w),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
    final title = widget.specialtyTitle.isNotEmpty
        ? '${context.translate(LocalizationKeys.doctorsOf)} ${widget.specialtyTitle}'
        : context.translate(LocalizationKeys.doctors);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title on the right (RTL start)
        Text(
          title,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonBlackTextColor,
          ),
        ),
        // Count chip on the left (RTL end)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.colorSecondary.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            '$count ${context.translate(LocalizationKeys.doctorSingle)}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.colorPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterAndSortRow(
    BuildContext context,
    DoctorListLoadedState state,
  ) {
    final hasActiveFilter = state.filter.hasActiveFilters;

    return Row(
      children: [
        // Filter Button on the right (RTL start)
        Expanded(
          child: InkWell(
            onTap: () {
              DoctorListFilterScreen.open(
                context: context,
                currentFilter: state.filter,
                onApply: (filter) {
                  context.read<DoctorListBloc>().add(
                        ApplyFilterEvent(filter),
                      );
                },
              );
            },
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: hasActiveFilter
                    ? AppColors.colorSecondary
                    : const Color(0xFFEBF5F5),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: AppColors.colorPrimary,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.translate(LocalizationKeys.filter),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.tune_rounded,
                    size: 18.r,
                    color: AppColors.colorPrimary,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Sort Dropdown Button on the left (RTL end)
        Expanded(
          child: InkWell(
            onTap: () {
              DoctorSortBottomSheetWidget.show(
                context: context,
                currentSort: state.sortOption,
                onApply: (sort) {
                  context.read<DoctorListBloc>().add(
                        ChangeSortOptionEvent(sort),
                      );
                },
              );
            },
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _getSortOptionLabel(context, state.sortOption),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<DoctorListBloc, DoctorListState>(
          listener: (context, state) {
            if (state is DoctorListErrorState) {
              showFeedbackMessage(
                state.isLocalizationKey
                    ? context.translate(state.errorMessage)
                    : state.errorMessage,
              );
            }
          },
          builder: (context, state) {
            final int count = state is DoctorListLoadedState
                ? state.displayedDoctors.length
                : 0;

            return RefreshIndicator(
              color: AppColors.colorPrimary,
              onRefresh: () async {
                context.read<DoctorListBloc>().add(
                      FetchSpecialtyDoctorsEvent(
                        specialtyId: widget.specialtyId,
                        isRefresh: true,
                      ),
                    );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    _buildTopBar(context),
                    SizedBox(height: 16.h),
                    _buildHeader(context, count),
                    SizedBox(height: 16.h),
                    DoctorSearchBarWidget(
                      controller: _searchController,
                      onChanged: (query) {
                        context.read<DoctorListBloc>().add(
                              SearchDoctorsEvent(query),
                            );
                      },
                      onClear: () {
                        _searchController.clear();
                        context.read<DoctorListBloc>().add(
                              const SearchDoctorsEvent(''),
                            );
                      },
                    ),
                    SizedBox(height: 14.h),
                    if (state is DoctorListLoadedState)
                      _buildFilterAndSortRow(context, state)
                    else
                      SizedBox(height: 42.h),
                    SizedBox(height: 16.h),
                    Expanded(child: _buildContent(context, state)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DoctorListState state) {
    if (state is DoctorListLoadingState || state is DoctorListInitialState) {
      return const Center(child: LoaderWidget());
    }

    if (state is DoctorListErrorState) {
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
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.labelSubtitle,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: 140.w,
              child: AppElevatedButton.withTitle(
                onPressed: () {
                  context.read<DoctorListBloc>().add(
                        FetchSpecialtyDoctorsEvent(
                          specialtyId: widget.specialtyId,
                        ),
                      );
                },
                title: context.translate(LocalizationKeys.retry),
              ),
            ),
          ],
        ),
      );
    }

    if (state is DoctorListLoadedState) {
      if (state.displayedDoctors.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_search_rounded,
                color: const Color(0xFF94A3B8),
                size: 56.r,
              ),
              SizedBox(height: 12.h),
              Text(
                context.translate(LocalizationKeys.noDoctorsFound),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.labelSubtitle,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (state.filter.hasActiveFilters ||
                  state.searchQuery.isNotEmpty) ...[
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    context.read<DoctorListBloc>()
                      ..add(const SearchDoctorsEvent(''))
                      ..add(const ResetFilterEvent());
                  },
                  child: Text(
                    context.translate(LocalizationKeys.clearAll),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }

      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.only(bottom: 24.h),
        itemCount: state.displayedDoctors.length,
        itemBuilder: (context, index) {
          final doctor = state.displayedDoctors[index];
          final isFav = state.favoriteDoctorIds.contains(doctor.id);
          return DoctorCardWidget(
            doctor: doctor,
            isFavorite: isFav,
            onFavoriteTap: () {
              context.read<DoctorListBloc>().add(
                    ToggleFavoriteDoctorEvent(doctor.id),
                  );
            },
            onBookTap: () {
              // Action for booking flow
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}

