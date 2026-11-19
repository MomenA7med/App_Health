import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:app_health/apis/_base/dio_api_manager.dart';
import 'package:app_health/core/pagination_manager.dart';
import 'package:app_health/core/widgets/base_stateful_screen_widget.dart';
import 'package:app_health/features/addresses/presentation/widgets/choose_address_bottom_sheet.dart';
import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/features/core/domain/entities/meta/meta_ui_model.dart';
import 'package:app_health/features/core/presentation/widgets/custom_app_bar.dart';
import 'package:app_health/features/pharmacies_list/data/datasources/pharmacies_list_api_manager.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_filter_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';
import 'package:app_health/features/pharmacies_list/data/repository/pharmacies_list_repository.dart';
import 'package:app_health/features/pharmacies_list/domain/usecases/get_pharmacies_list_use_case.dart';
import 'package:app_health/features/pharmacies_list/presentation/bloc/pharmacies_list_bloc.dart';
import 'package:app_health/features/pharmacies_list/presentation/bloc/pharmacies_list_event.dart';
import 'package:app_health/features/pharmacies_list/presentation/bloc/pharmacies_list_state.dart';
import 'package:app_health/features/pharmacies_list/presentation/screens/pharmacies_list_filter_screen.dart';
import 'package:app_health/features/pharmacy_details/presentation/screens/pharmacy_details_screen.dart';
import 'package:app_health/features/pharmacies_list/presentation/widgets/pharmacy_card_widget.dart';
import 'package:app_health/features/pharmacies_list/presentation/widgets/pharmacy_sort_bottom_sheet_widget.dart';
import 'package:app_health/features/widgets/app_search_bar_widget.dart';
import 'package:app_health/features/widgets/filter_and_sort_row_widget.dart';
import 'package:app_health/features/widgets/pagination_widgets/paging_swipe_to_refresh_list_widget.dart';
import 'package:app_health/res/app_colors.dart';
import 'package:app_health/utils/feedback/feedback_message.dart';
import 'package:app_health/utils/loaders/loader_widget.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class PharmaciesListScreen extends StatelessWidget {
  const PharmaciesListScreen({super.key});

  static const String routeName = '/pharmacies-list';

  static void open({required BuildContext context}) {
    context.push(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
    final PharmaciesListRepository repository = PharmaciesListRepository(
      PharmaciesListApiManager(dioApiManager),
    );
    final GetPharmaciesListUseCase useCase =
        GetPharmaciesListUseCase(repository);

    return BlocProvider<PharmaciesListsBloc>(
      create: (BuildContext context) =>
          PharmaciesListsBloc(getPharmaciesListUseCase: useCase),
      child: const PharmaciesListScreenWithBloc(),
    );
  }
}

class PharmaciesListScreenWithBloc extends BaseStatefulScreenWidget {
  const PharmaciesListScreenWithBloc({super.key});

  @override
  BaseScreenState<PharmaciesListScreenWithBloc> baseScreenCreateState() =>
      _PharmaciesListScreenWithBlocState();
}

class _PharmaciesListScreenWithBlocState
    extends BaseScreenState<PharmaciesListScreenWithBloc>
    with PaginationManager<PharmacyModel> {
  MetaUiModel _metaUiModel = MetaUiModel.emptyOne();
  late PharmacyListSendModel sendModel;
  final TextEditingController _searchController = TextEditingController();
  PharmacySortOption currentSort = PharmacySortOption.highestRated;
  PharmacyFilterModel currentFilter = PharmacyFilterModel.initial;
  bool empty = false;
  int count = 0;

  @override
  void initState() {
    sendModel = PharmacyListSendModel(
      pagination: PagingListSendModel(pageSize: 10),
    );
    Future.microtask(_getPharmaciesListsApiEvent);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  PharmaciesListsBloc get currentBloc =>
      BlocProvider.of<PharmaciesListsBloc>(context);

  void _getPharmaciesListsApiEvent() {
    sendModel.pagination.pageNumber++;
    currentBloc.add(GetPharmaciesListsApiEvent(sendModel: sendModel));
  }

  void _resetPaging() {
    sendModel.pagination = PagingListSendModel(pageSize: 10);
    resetPagination();
  }

  @override
  lastPageCallback() {
    currentBloc.add(NoMoreDataToLoadEvent());
  }

  void _applyFilter(PharmacyFilterModel filter) {
    setState(() {
      currentFilter = filter;
    });
    sendModel.governorateId =
        (filter.governorateId != null && filter.governorateId!.isNotEmpty)
            ? filter.governorateId
            : null;
    sendModel.areaId =
        (filter.areaId != null && filter.areaId!.isNotEmpty)
            ? filter.areaId
            : null;
    sendModel.locationStrategy = filter.locationStrategy;
    sendModel.workingHoursFilter = filter.workingHoursFilter;
    sendModel.insuranceCompanyId =
        (filter.insuranceCompanyId != null &&
                filter.insuranceCompanyId!.isNotEmpty)
            ? filter.insuranceCompanyId
            : null;
    _resetPaging();
    _getPharmaciesListsApiEvent();
  }

  void _applySort(PharmacySortOption sort) {
    setState(() {
      currentSort = sort;
    });
    sendModel.sortBy = sort.toString();
    _resetPaging();
    _getPharmaciesListsApiEvent();
  }

  void _textChanged(String value) {
    _resetPaging();
    sendModel.pagination.searchText = value;
    _getPharmaciesListsApiEvent();
  }

  String _getSortOptionLabel(BuildContext context, PharmacySortOption option) {
    switch (option) {
      case PharmacySortOption.nearest:
        return context.translate(LocalizationKeys.nearestToYou);
      case PharmacySortOption.highestRated:
        return context.translate(LocalizationKeys.highestRated);
    }
  }

  Widget _buildHeader(BuildContext context, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          context.translate(LocalizationKeys.pharmacies),
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
    return FilterAndSortRowWidget(
      onFilterTap: () async {
        final result = await PharmaciesListFilterScreen.open(
          context: context,
          currentFilter: currentFilter,
        );
        if (result != null) {
          _applyFilter(result);
        }
      },
      onSortTap: () {
        PharmacySortBottomSheetWidget.show(
          context: context,
          currentSort: currentSort,
          onApply: _applySort,
        );
      },
      sortLabel: _getSortOptionLabel(context, currentSort),
      hasActiveFilter: currentFilter.hasActiveFilters,
      activeFiltersCount: currentFilter.activeFiltersCount,
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
              _getPharmaciesListsApiEvent();
            },
            onSelectCurrentLocation: () {
              setState(() {
                sendModel.governorateId = null;
                sendModel.areaId = null;
              });
              resetPagination();
              _getPharmaciesListsApiEvent();
            },
          );
        },
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<PharmaciesListsBloc, PharmaciesListsState>(
          listener: (context, state) {
            if (state is PharmacyListErrorState) {
              stopPaginationLoading();
              showFeedbackMessage(
                state.isLocalizationKey
                    ? context.translate(state.errorMassage)
                    : state.errorMassage,
              );
            } else if (state is PharmaciesListsLoadedState) {
              _metaUiModel = state.pharmacyListResponse.metaUiModel;
              count = state.pharmacyListResponse.metaUiModel.total;
              stopPaginationLoading();
              alignPaginationWithApi(
                _metaUiModel.hasPrevious,
                _metaUiModel.hasNext,
                state.pharmacyListResponse.pharmacyList,
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
                  AppSearchBarWidget(
                    controller: _searchController,
                    hintText: context.translate(
                      LocalizationKeys.searchPharmacies,
                    ),
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

  Widget _buildContent(BuildContext context, PharmaciesListsState state) {
    if (state is PharmacyListLoadingState) {
      return const Center(child: LoaderWidget());
    }

    if (empty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_pharmacy_outlined,
              size: 64.r,
              color: AppColors.textMuted,
            ),
            SizedBox(height: 16.h),
            Text(
              context.translate(LocalizationKeys.noPharmaciesFound),
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
                  _applyFilter(PharmacyFilterModel.initial);
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
          _getPharmaciesListsApiEvent();
        } else if (shouldShowNoMoreData) {
          lastPageCallback();
        }
      },
      listPadding: EdgeInsets.only(bottom: 24.h),
      itemClickable: false,
      itemWidget: (int index) {
        final pharmacy = getUpdatedData[index];
        final isFav = (state is PharmaciesListsLoadedState)
            ? state.favoritePharmacyIds.contains(pharmacy.id) ||
                pharmacy.isFavorite
            : pharmacy.isFavorite;

        return PharmacyCardWidget(
          pharmacy: pharmacy,
          isFavorite: isFav,
          onFavoriteTap: () {
            currentBloc.add(
              ToggleFavoritePharmacyEvent(pharmacy.id),
            );
          },
          onTap: () {
            PharmacyDetailsScreen.open(context, pharmacyId: pharmacy.id);
          },
        );
      },
      swipedToRefresh: () {
        _resetPaging();
        _getPharmaciesListsApiEvent();
      },
      listLength: getUpdatedData.length,
      showPagingLoader: currentLoadingState,
    );
  }
}
