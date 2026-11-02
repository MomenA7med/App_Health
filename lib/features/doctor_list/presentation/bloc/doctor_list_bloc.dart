import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/features/doctor_list/domain/usecases/get_specialty_doctors_usecase.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_event.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_state.dart';

class DoctorListBloc extends Bloc<DoctorListEvent, DoctorListState> {
  final GetSpecialtyDoctorsUseCase getSpecialtyDoctorsUseCase;

  DoctorListBloc({required this.getSpecialtyDoctorsUseCase})
      : super(const DoctorListInitialState()) {
    on<FetchSpecialtyDoctorsEvent>(_onFetchSpecialtyDoctors);
    on<SearchDoctorsEvent>(_onSearchDoctors);
    on<ApplyFilterEvent>(_onApplyFilter);
    on<ResetFilterEvent>(_onResetFilter);
    on<ChangeSortOptionEvent>(_onChangeSortOption);
    on<ToggleFavoriteDoctorEvent>(_onToggleFavoriteDoctor);
  }

  FutureOr<void> _onFetchSpecialtyDoctors(
    FetchSpecialtyDoctorsEvent event,
    Emitter<DoctorListState> emit,
  ) async {
    final currentState = state;
    Set<String> previousFavorites = {};
    DoctorFilterModel previousFilter = DoctorFilterModel.initial;
    DoctorSortOption previousSort = DoctorSortOption.nearest;
    String previousSearch = '';

    if (currentState is DoctorListLoadedState) {
      previousFavorites = currentState.favoriteDoctorIds;
      previousFilter = currentState.filter;
      previousSort = currentState.sortOption;
      previousSearch = currentState.searchQuery;
    }

    if (!event.isRefresh) {
      emit(const DoctorListLoadingState());
    }

    final result = await getSpecialtyDoctorsUseCase(
      GetSpecialtyDoctorsParams(specialtyId: event.specialtyId),
    );

    result.fold(
      (error) {
        emit(
          DoctorListErrorState(
            errorMessage: error.message,
            isLocalizationKey: error.isMessageLocalizationKey,
          ),
        );
      },
      (response) {
        final items = response.data?.items ?? [];
        final totalCount = response.data?.totalCount ?? items.length;

        final displayed = applyFilterAndSort(
          doctors: items,
          filter: previousFilter,
          sortOption: previousSort,
          searchQuery: previousSearch,
        );

        emit(
          DoctorListLoadedState(
            specialtyId: event.specialtyId,
            allDoctors: items,
            displayedDoctors: displayed,
            filter: previousFilter,
            sortOption: previousSort,
            searchQuery: previousSearch,
            favoriteDoctorIds: previousFavorites,
            totalCount: totalCount,
          ),
        );
      },
    );
  }

  FutureOr<void> _onSearchDoctors(
    SearchDoctorsEvent event,
    Emitter<DoctorListState> emit,
  ) {
    final currentState = state;
    if (currentState is DoctorListLoadedState) {
      final updatedDisplayed = applyFilterAndSort(
        doctors: currentState.allDoctors,
        filter: currentState.filter,
        sortOption: currentState.sortOption,
        searchQuery: event.query,
      );

      emit(
        currentState.copyWith(
          searchQuery: event.query,
          displayedDoctors: updatedDisplayed,
        ),
      );
    }
  }

  FutureOr<void> _onApplyFilter(
    ApplyFilterEvent event,
    Emitter<DoctorListState> emit,
  ) {
    final currentState = state;
    if (currentState is DoctorListLoadedState) {
      final updatedDisplayed = applyFilterAndSort(
        doctors: currentState.allDoctors,
        filter: event.filter,
        sortOption: currentState.sortOption,
        searchQuery: currentState.searchQuery,
      );

      emit(
        currentState.copyWith(
          filter: event.filter,
          displayedDoctors: updatedDisplayed,
        ),
      );
    }
  }

  FutureOr<void> _onResetFilter(
    ResetFilterEvent event,
    Emitter<DoctorListState> emit,
  ) {
    final currentState = state;
    if (currentState is DoctorListLoadedState) {
      const resetFilter = DoctorFilterModel.initial;
      final updatedDisplayed = applyFilterAndSort(
        doctors: currentState.allDoctors,
        filter: resetFilter,
        sortOption: currentState.sortOption,
        searchQuery: currentState.searchQuery,
      );

      emit(
        currentState.copyWith(
          filter: resetFilter,
          displayedDoctors: updatedDisplayed,
        ),
      );
    }
  }

  FutureOr<void> _onChangeSortOption(
    ChangeSortOptionEvent event,
    Emitter<DoctorListState> emit,
  ) {
    final currentState = state;
    if (currentState is DoctorListLoadedState) {
      final updatedDisplayed = applyFilterAndSort(
        doctors: currentState.allDoctors,
        filter: currentState.filter,
        sortOption: event.sortOption,
        searchQuery: currentState.searchQuery,
      );

      emit(
        currentState.copyWith(
          sortOption: event.sortOption,
          displayedDoctors: updatedDisplayed,
        ),
      );
    }
  }

  FutureOr<void> _onToggleFavoriteDoctor(
    ToggleFavoriteDoctorEvent event,
    Emitter<DoctorListState> emit,
  ) {
    final currentState = state;
    if (currentState is DoctorListLoadedState) {
      final updatedFavorites = Set<String>.from(currentState.favoriteDoctorIds);
      if (updatedFavorites.contains(event.doctorId)) {
        updatedFavorites.remove(event.doctorId);
      } else {
        updatedFavorites.add(event.doctorId);
      }

      emit(currentState.copyWith(favoriteDoctorIds: updatedFavorites));
    }
  }

  static List<DoctorModel> applyFilterAndSort({
    required List<DoctorModel> doctors,
    required DoctorFilterModel filter,
    required DoctorSortOption sortOption,
    required String searchQuery,
  }) {
    List<DoctorModel> result = List<DoctorModel>.from(doctors);

    // 1. Search Query
    final trimmedSearch = searchQuery.trim().toLowerCase();
    if (trimmedSearch.isNotEmpty) {
      result = result.where((doctor) {
        final name = doctor.name.toLowerCase();
        final title = doctor.specializationTitle.toLowerCase();
        final clinic = doctor.clinicName.toLowerCase();
        final address = doctor.clinicAddress.toLowerCase();
        final area = doctor.area.toLowerCase();
        return name.contains(trimmedSearch) ||
            title.contains(trimmedSearch) ||
            clinic.contains(trimmedSearch) ||
            address.contains(trimmedSearch) ||
            area.contains(trimmedSearch);
      }).toList();
    }

    // 2. Gender
    if (filter.gender != null && filter.gender != 'all') {
      if (filter.gender == 'male') {
        result = result.where((d) => d.isMale).toList();
      } else if (filter.gender == 'female') {
        result = result.where((d) => d.isFemale).toList();
      }
    }

    // 3. Price
    if (filter.minPrice != null) {
      result = result
          .where((d) => d.consultationFee >= filter.minPrice!)
          .toList();
    }
    if (filter.maxPrice != null) {
      result = result
          .where((d) => d.consultationFee <= filter.maxPrice!)
          .toList();
    }

    // 4. Area / Location
    if (filter.area != null && filter.area!.isNotEmpty && filter.area != 'all') {
      final areaFilter = filter.area!.toLowerCase();
      result = result.where((d) {
        return d.area.toLowerCase().contains(areaFilter) ||
            d.cityLocation.toLowerCase().contains(areaFilter);
      }).toList();
    }

    // 5. Availability Date
    if (filter.consultationDate != null && filter.consultationDate != 'any') {
      if (filter.consultationDate == 'today') {
        result = result.where((d) {
          final slot = d.nextAvailableSlot?.toLowerCase() ?? '';
          return slot.contains('اليوم') || slot.contains('today');
        }).toList();
      } else if (filter.consultationDate == 'tomorrow') {
        result = result.where((d) {
          final slot = d.nextAvailableSlot?.toLowerCase() ?? '';
          return slot.contains('غداً') || slot.contains('tomorrow');
        }).toList();
      }
    }

    // 6. Sorting
    switch (sortOption) {
      case DoctorSortOption.nearest:
        result.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case DoctorSortOption.highestRated:
        result.sort((a, b) {
          final cmp = b.ratingAverage.compareTo(a.ratingAverage);
          if (cmp != 0) return cmp;
          return b.totalReviews.compareTo(a.totalReviews);
        });
        break;
      case DoctorSortOption.priceLowToHigh:
        result.sort((a, b) => a.consultationFee.compareTo(b.consultationFee));
        break;
      case DoctorSortOption.priceHighToLow:
        result.sort((a, b) => b.consultationFee.compareTo(a.consultationFee));
        break;
    }

    return result;
  }
}

