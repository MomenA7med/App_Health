import 'package:app_health/features/doctor_details/presentation/screens/doctor_details_screen.dart';
import 'package:app_health/features/addresses/presentation/widgets/choose_address_bottom_sheet.dart';
import 'package:app_health/features/core/presentation/widgets/custom_app_bar.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/pagination_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/features/core/domain/entities/meta/meta_ui_model.dart';
import 'package:app_health/features/doctor_list/data/datasources/doctor_list_api_manager.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_list_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/features/doctor_list/data/repository/doctor_list_repository.dart';
import 'package:app_health/features/doctor_list/domain/usecases/get_doctor_list_use_case.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_bloc.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_event.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_state.dart';
import 'package:app_health/features/doctor_list/presentation/screens/doctor_list_filter_screen.dart';
import 'package:app_health/features/doctor_list/presentation/widgets/doctor_card_widget.dart';
import 'package:app_health/features/doctor_list/presentation/widgets/doctor_search_bar_widget.dart';
import 'package:app_health/features/doctor_list/presentation/widgets/doctor_sort_bottom_sheet_widget.dart';
import 'package:app_health/features/widgets/app_buttons/app_elevated_button.dart';
import 'package:app_health/features/widgets/pagination_widgets/paging_swipe_to_refresh_list_widget.dart';
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
      extra: {'specialtyId': specialtyId, 'specialtyTitle': specialtyTitle},
    );
  }

  @override
  Widget build(BuildContext context) {
    final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
    final DoctorListRepository repository = DoctorListRepository(
      DoctorListApiManager(dioApiManager),
    );
    final GetDoctorListsUseCase useCase = GetDoctorListsUseCase(repository);

    return BlocProvider<DoctorListsBloc>(
      create: (BuildContext context) =>
          DoctorListsBloc(getDoctorListsUseCase: useCase),
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
    extends BaseScreenState<DoctorListScreenWithBloc>
    with PaginationManager<DoctorModel> {
  MetaUiModel _metaUiModel = MetaUiModel.emptyOne();
  late DoctorListSendModel sendModel;
  final TextEditingController _searchController = TextEditingController();
  DoctorSortOption currentSort = DoctorSortOption.nearest;
  DoctorFilterModel currentFilter = DoctorFilterModel.initial;
  bool empty = false;
  int count = 0;

  @override
  void initState() {
    sendModel = DoctorListSendModel(
      specialtyId: widget.specialtyId,
      pagination: PagingListSendModel(pageSize: 10),
    );
    Future.microtask(_getDoctorListsApiEvent);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  DoctorListsBloc get currentBloc => BlocProvider.of<DoctorListsBloc>(context);

  void _getDoctorListsApiEvent() {
    sendModel.pagination.pageNumber++;
    currentBloc.add(GetDoctorListsApiEvent(sendModel: sendModel));
  }

  void _resetPaging() {
    sendModel.pagination = PagingListSendModel(pageSize: 10);
    resetPagination();
  }

  @override
  lastPageCallback() {
    currentBloc.add(NoMoreDataToLoadEvent());
  }

  void _applyFilter(DoctorFilterModel filter) {
    currentFilter = filter;
    sendModel.governorateId =
        (filter.governorateId != null && filter.governorateId!.isNotEmpty)
            ? filter.governorateId
            : null;
    sendModel.areaId =
        (filter.areaId != null && filter.areaId!.isNotEmpty)
            ? filter.areaId
            : null;
    sendModel.insuranceCompanyId =
        (filter.insuranceCompanyId != null &&
                filter.insuranceCompanyId!.isNotEmpty)
            ? filter.insuranceCompanyId
            : null;
    sendModel.doctorType = (filter.gender != null && filter.gender != 0)
        ? filter.gender
        : null;
    sendModel.minFee = filter.minPrice;
    sendModel.maxFee = filter.maxPrice;
    int? dateFilterInt;
    if (filter.consultationDate == 'today' || filter.consultationDate == '1') {
      dateFilterInt = 1;
    } else if (filter.consultationDate == 'tomorrow' ||
        filter.consultationDate == '2') {
      dateFilterInt = 2;
    }
    sendModel.dateFilter = dateFilterInt;
    _resetPaging();
    _getDoctorListsApiEvent();
  }

  void _applySort(DoctorSortOption sort) {
    currentSort = sort;
    sendModel.sortBy = sort.toString();
    _resetPaging();
    _getDoctorListsApiEvent();
  }

  void _textChanged(String value) {
    _resetPaging();
    sendModel.pagination.searchText = value;
    _getDoctorListsApiEvent();
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

  Widget _buildHeader(BuildContext context, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title on the right (RTL start)
        Text(
          '${context.translate(LocalizationKeys.doctorsOf)} ${widget.specialtyTitle}',
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

  Widget _buildFilterAndSortRow(BuildContext context) {
    return Row(
      children: [
        // Filter Button on the right (RTL start)
        Expanded(
          child: InkWell(
            onTap: () {
              DoctorListFilterScreen.open(
                context: context,
                currentFilter: currentFilter,
                onApply: _applyFilter,
              );
            },
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.colorSecondary,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColors.colorPrimary, width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssetPaths.filterIcon,
                    width: 18.w,
                    height: 18.h,
                    colorFilter: ColorFilter.mode(
                      AppColors.textSecondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    context.translate(LocalizationKeys.filter),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondaryColor,
                    ),
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
                currentSort: currentSort,
                onApply: _applySort,
              );
            },
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: AppColors.textSecondaryColor,
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      _getSortOptionLabel(context, currentSort),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHeader,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
      appBar: CustomAppBar(
        showLocation: true,
        onLocationTap: () async {
          await ChooseAddressBottomSheet.show(
            context: context,
            onSelectAddress: (selected) {
              setState(() {
                sendModel.governorateId = selected.governorate;
                sendModel.areaId = selected.area;
              });
              resetPagination();
              _getDoctorListsApiEvent();
            },
            onSelectCurrentLocation: () {
              setState(() {
                sendModel.governorateId = null;
                sendModel.areaId = null;
              });
              resetPagination();
              _getDoctorListsApiEvent();
            },
          );
        },
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<DoctorListsBloc, DoctorListsState>(
          listener: (context, state) {
            if (state is DoctorListErrorState) {
              stopPaginationLoading();
              showFeedbackMessage(
                state.isLocalizationKey
                    ? context.translate(state.errorMassage)
                    : state.errorMassage,
              );
            } else if (state is DoctorListsLoadedState) {
              _metaUiModel = state.doctorListResponse.metaUiModel;
              count = state.doctorListResponse.metaUiModel.total;
              stopPaginationLoading();
              alignPaginationWithApi(
                _metaUiModel.hasPrevious,
                _metaUiModel.hasNext,
                state.doctorListResponse.doctorList,
              );
              if (getUpdatedData.isEmpty) {
                empty = true;
              } else {
                empty = false;
              }
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  _buildHeader(context, count),
                  SizedBox(height: 16.h),
                  DoctorSearchBarWidget(
                    controller: _searchController,
                    onChanged: _textChanged,
                    onClear: () {
                      _searchController.clear();
                      _textChanged('');
                    },
                  ),
                  SizedBox(height: 14.h),
                  _buildFilterAndSortRow(context),
                  SizedBox(height: 16.h),
                  Expanded(child: _buildContent(context, state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DoctorListsState state) {
    if (state is DoctorListListLoadingState) {
      return const Center(child: LoaderWidget());
    }

    if (state is DoctorListErrorState && getUpdatedData.isEmpty) {
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
                  ? context.translate(state.errorMassage)
                  : state.errorMassage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.labelSubtitle),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: 140.w,
              child: AppElevatedButton.withTitle(
                onPressed: () {
                  _resetPaging();
                  _getDoctorListsApiEvent();
                },
                title: context.translate(LocalizationKeys.retry),
              ),
            ),
          ],
        ),
      );
    }

    if (empty || (state is DoctorListsLoadedState && getUpdatedData.isEmpty)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search_rounded,
              color: AppColors.textSecondary,
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
            if (currentFilter.hasActiveFilters ||
                sendModel.pagination.searchText.isNotEmpty) ...[
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  currentFilter = DoctorFilterModel.initial;
                  sendModel.governorateId = null;
                  sendModel.areaId = null;
                  sendModel.insuranceCompanyId = null;
                  sendModel.doctorType = null;
                  sendModel.minFee = null;
                  sendModel.maxFee = null;
                  sendModel.dateFilter = null;
                  sendModel.pagination.searchText = '';
                  _resetPaging();
                  _getDoctorListsApiEvent();
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

    return PagingSwipeToRefreshListWidget(
      reachedEndOfScroll: () {
        if (shouldLoadMore) {
          startPaginationLoading();
          _getDoctorListsApiEvent();
        } else if (shouldShowNoMoreData) {
          lastPageCallback();
        }
      },
      listPadding: EdgeInsets.only(bottom: 24.h),
      itemClickable: false,
      itemWidget: (int index) {
        final doctor = getUpdatedData[index];
        final isFav = (state is DoctorListsLoadedState)
            ? state.favoriteDoctorIds.contains(doctor.id)
            : false;
        return DoctorCardWidget(
          doctor: doctor,
          isFavorite: isFav,
          onFavoriteTap: () {
            currentBloc.add(ToggleFavoriteDoctorEvent(doctor.id));
          },
          onBookTap: () {
            DoctorDetailsScreen.open(
              context,
              doctorId: doctor.id,
              consultationFee: doctor.consultationFee.toDouble(),
            );
          },
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getDoctorListsApiEvent();
      },
      listLength: getUpdatedData.length,
      showPagingLoader: currentLoadingState,
    );
  }
}
