import 'package:equatable/equatable.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';

abstract class DoctorListState extends Equatable {
  const DoctorListState();

  @override
  List<Object?> get props => [];
}

class DoctorListInitialState extends DoctorListState {
  const DoctorListInitialState();
}

class DoctorListLoadingState extends DoctorListState {
  const DoctorListLoadingState();
}

class DoctorListLoadedState extends DoctorListState {
  final String specialtyId;
  final List<DoctorModel> allDoctors;
  final List<DoctorModel> displayedDoctors;
  final DoctorFilterModel filter;
  final DoctorSortOption sortOption;
  final String searchQuery;
  final Set<String> favoriteDoctorIds;
  final int totalCount;

  const DoctorListLoadedState({
    required this.specialtyId,
    required this.allDoctors,
    required this.displayedDoctors,
    required this.filter,
    required this.sortOption,
    this.searchQuery = '',
    this.favoriteDoctorIds = const {},
    required this.totalCount,
  });

  DoctorListLoadedState copyWith({
    String? specialtyId,
    List<DoctorModel>? allDoctors,
    List<DoctorModel>? displayedDoctors,
    DoctorFilterModel? filter,
    DoctorSortOption? sortOption,
    String? searchQuery,
    Set<String>? favoriteDoctorIds,
    int? totalCount,
  }) {
    return DoctorListLoadedState(
      specialtyId: specialtyId ?? this.specialtyId,
      allDoctors: allDoctors ?? this.allDoctors,
      displayedDoctors: displayedDoctors ?? this.displayedDoctors,
      filter: filter ?? this.filter,
      sortOption: sortOption ?? this.sortOption,
      searchQuery: searchQuery ?? this.searchQuery,
      favoriteDoctorIds: favoriteDoctorIds ?? this.favoriteDoctorIds,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object?> get props => [
        specialtyId,
        allDoctors,
        displayedDoctors,
        filter,
        sortOption,
        searchQuery,
        favoriteDoctorIds,
        totalCount,
      ];
}

class DoctorListErrorState extends DoctorListState {
  final String errorMessage;
  final bool isLocalizationKey;

  const DoctorListErrorState({
    required this.errorMessage,
    this.isLocalizationKey = false,
  });

  @override
  List<Object?> get props => [errorMessage, isLocalizationKey];
}

