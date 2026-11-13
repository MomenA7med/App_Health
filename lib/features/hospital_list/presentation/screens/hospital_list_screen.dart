import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/extensions/extension_localization.dart';
import 'package:app_health/core/pagination_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/addresses/presentation/widgets/choose_address_bottom_sheet.dart';
import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/features/core/domain/entities/meta/meta_ui_model.dart';
import 'package:app_health/features/core/presentation/widgets/custom_app_bar.dart';
import 'package:app_health/features/hospital_list/data/datasources/hospital_list_api_manager.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_filter_model.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_list_send_model.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_model.dart';
import 'package:app_health/features/hospital_list/data/repository/hospital_list_repository.dart';
import 'package:app_health/features/hospital_list/domain/usecases/get_hospital_list_use_case.dart';
import 'package:app_health/features/hospital_list/presentation/bloc/hospital_list_bloc.dart';
import 'package:app_health/features/hospital_list/presentation/bloc/hospital_list_event.dart';
import 'package:app_health/features/hospital_list/presentation/bloc/hospital_list_state.dart';
import 'package:app_health/features/hospital_list/presentation/screens/hospital_list_filter_screen.dart';
import 'package:app_health/features/hospital_list/presentation/widgets/hospital_card_widget.dart';
import 'package:app_health/features/hospital_list/presentation/widgets/hospital_search_bar_widget.dart';
import 'package:app_health/features/hospital_list/presentation/widgets/hospital_sort_bottom_sheet_widget.dart';
import 'package:app_health/features/widgets/pagination_widgets/paging_swipe_to_refresh_list_widget.dart';
import 'package:app_health/res/app_asset_paths.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class HospitalListScreen extends StatelessWidget {
  const HospitalListScreen({super.key});

  static const String routeName = '/hospital-list';

  static void open({required BuildContext context}) {
    context.push(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
    final HospitalListRepository repository = HospitalListRepository(
      HospitalListApiManager(dioApiManager),
    );
    final GetHospitalListsUseCase useCase = GetHospitalListsUseCase(repository);

    return BlocProvider<HospitalListsBloc>(
      create: (BuildContext context) =>
          HospitalListsBloc(getHospitalListsUseCase: useCase),
      child: const HospitalListScreenWithBloc(),
    );
  }
}

class HospitalListScreenWithBloc extends BaseStatefulScreenWidget {
  const HospitalListScreenWithBloc({super.key});

  @override
  BaseScreenState<HospitalListScreenWithBloc> baseScreenCreateState() =>
      _HospitalListScreenWithBlocState();
}

class _HospitalListScreenWithBlocState
    extends BaseScreenState<HospitalListScreenWithBloc>
    with PaginationManager<HospitalModel> {
  MetaUiModel _metaUiModel = MetaUiModel.emptyOne();
  late HospitalListSendModel sendModel;
  final TextEditingController _searchController = TextEditingController();
  HospitalSortOption currentSort = HospitalSortOption.highestRated;
  HospitalFilterModel currentFilter = HospitalFilterModel.initial;
  bool empty = false;
  int count = 0;

  @override
  void initState() {
    sendModel = HospitalListSendModel(
      pagination: PagingListSendModel(pageSize: 10),
    );
    Future.microtask(_getHospitalListsApiEvent);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  HospitalListsBloc get currentBloc =>
      BlocProvider.of<HospitalListsBloc>(context);

  void _getHospitalListsApiEvent() {
    sendModel.pagination.pageNumber++;
    currentBloc.add(GetHospitalListsApiEvent(sendModel: sendModel));
  }

  void _resetPaging() {
    sendModel.pagination = PagingListSendModel(pageSize: 10);
    resetPagination();
  }

  @override
  lastPageCallback() {
    currentBloc.add(NoMoreDataToLoadEvent());
  }

  void _applyFilter(HospitalFilterModel filter) {
    setState(() {
      currentFilter = filter;
    });
    sendModel.governorateId =
        (filter.governorateId != null && filter.governorateId!.isNotEmpty)
        ? filter.governorateId
        : null;
    sendModel.areaId = (filter.areaId != null && filter.areaId!.isNotEmpty)
        ? filter.areaId
        : null;
    sendModel.specialtyId =
        (filter.specialtyId != null && filter.specialtyId!.isNotEmpty)
            ? filter.specialtyId
            : null;
    sendModel.insuranceCompanyId =
        (filter.insuranceCompanyId != null &&
            filter.insuranceCompanyId!.isNotEmpty)
        ? filter.insuranceCompanyId
        : null;
    _resetPaging();
    _getHospitalListsApiEvent();
  }

  void _applySort(HospitalSortOption sort) {
    setState(() {
      currentSort = sort;
    });
    sendModel.sortBy = sort.toString();
    _resetPaging();
    _getHospitalListsApiEvent();
  }

  void _textChanged(String value) {
    _resetPaging();
    sendModel.pagination.searchText = value;
    _getHospitalListsApiEvent();
  }

  String _getSortOptionLabel(BuildContext context, HospitalSortOption option) {
    switch (option) {
      case HospitalSortOption.nearest:
        return context.translate(LocalizationKeys.nearestToYou);
      case HospitalSortOption.highestRated:
        return context.translate(LocalizationKeys.highestRated);
    }
  }

  Widget _buildHeader(BuildContext context, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          context.translate(LocalizationKeys.hospitals),
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.buttonBlackTextColor,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.colorSecondary.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            '$count',
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
    final hasActiveFilter = currentFilter.hasActiveFilters;

    return Row(
      children: [
        // Filter Button on start
        Expanded(
          child: InkWell(
            onTap: () async {
              final result = await HospitalListFilterScreen.open(
                context: context,
                currentFilter: currentFilter,
              );
              if (result != null) {
                _applyFilter(result);
              }
            },
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: hasActiveFilter
                    ? AppColors.colorPrimary
                    : AppColors.colorSecondary,
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
                      hasActiveFilter
                          ? AppColors.buttonWhiteTextColor
                          : AppColors.textSecondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    context.translate(LocalizationKeys.filter),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: hasActiveFilter
                          ? AppColors.buttonWhiteTextColor
                          : AppColors.textSecondaryColor,
                    ),
                  ),
                  if (hasActiveFilter) ...[
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${currentFilter.activeFiltersCount}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Sort Dropdown Button on end
        Expanded(
          child: InkWell(
            onTap: () {
              HospitalSortBottomSheetWidget.show(
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
              _getHospitalListsApiEvent();
            },
            onSelectCurrentLocation: () {
              setState(() {
                sendModel.governorateId = null;
                sendModel.areaId = null;
              });
              resetPagination();
              _getHospitalListsApiEvent();
            },
          );
        },
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<HospitalListsBloc, HospitalListsState>(
          listener: (context, state) {
            if (state is HospitalListErrorState) {
              stopPaginationLoading();
              showFeedbackMessage(
                state.isLocalizationKey
                    ? context.translate(state.errorMassage)
                    : state.errorMassage,
              );
            } else if (state is HospitalListsLoadedState) {
              _metaUiModel = state.hospitalListResponse.metaUiModel;
              count = state.hospitalListResponse.metaUiModel.total;
              stopPaginationLoading();
              alignPaginationWithApi(
                _metaUiModel.hasPrevious,
                _metaUiModel.hasNext,
                state.hospitalListResponse.hospitalList,
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
                  HospitalSearchBarWidget(
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

  Widget _buildContent(BuildContext context, HospitalListsState state) {
    if (state is HospitalListLoadingState) {
      return const Center(child: LoaderWidget());
    }

    if (empty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital_outlined,
              size: 64.r,
              color: AppColors.textMuted,
            ),
            SizedBox(height: 16.h),
            Text(
              context.translate(LocalizationKeys.noHospitalsFound),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.buttonBlackTextColor,
              ),
            ),
            if (currentFilter.hasActiveFilters ||
                _searchController.text.isNotEmpty) ...[
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  _applyFilter(HospitalFilterModel.initial);
                },
                child: Text(
                  context.translate(LocalizationKeys.clearAll),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.colorPrimary,
                    fontWeight: FontWeight.bold,
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
          _getHospitalListsApiEvent();
        } else if (shouldShowNoMoreData) {
          lastPageCallback();
        }
      },
      listPadding: EdgeInsets.only(bottom: 24.h),
      itemClickable: false,
      itemWidget: (int index) {
        final hospital = getUpdatedData[index];
        final isFav = (state is HospitalListsLoadedState)
            ? state.favoriteHospitalIds.contains(hospital.id) ||
                  hospital.isFavorite
            : hospital.isFavorite;

        return HospitalCardWidget(
          hospital: hospital,
          isFavorite: isFav,
          onFavoriteTap: () {
            currentBloc.add(ToggleFavoriteHospitalEvent(hospital.id));
          },
          onTap: () {
            // Can navigate to hospital details when implemented
          },
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getHospitalListsApiEvent();
      },
      listLength: getUpdatedData.length,
      showPagingLoader: currentLoadingState,
    );
  }
}
