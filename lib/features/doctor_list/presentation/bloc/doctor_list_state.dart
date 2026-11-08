import 'package:equatable/equatable.dart';
import 'package:app_health/features/core/domain/entities/meta/meta_ui_model.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';
import 'package:app_health/features/doctor_list/domain/entities/doctor_lists_ui_response.dart';

abstract class DoctorListsState extends Equatable {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class DoctorListsInitial extends DoctorListsState {}

class DoctorListListLoadingState extends DoctorListsState {}

class DoctorListLoadingAsPagingState extends DoctorListsState {}

class DoctorListErrorState extends DoctorListsState {
  final String errorMassage;
  final bool isLocalizationKey;

  DoctorListErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];

  String get errorMessage => errorMassage;
}

class DoctorListsLoadedState extends DoctorListsState {
  final DoctorListsUiResponse doctorListUiResponse;
  final Set<String> favoriteDoctorIds;

  DoctorListsLoadedState(
    this.doctorListUiResponse, {
    this.favoriteDoctorIds = const {},
  });

  DoctorListsUiResponse get doctorListResponse => doctorListUiResponse;
  List<DoctorModel> get doctorList => doctorListUiResponse.doctorList;
  List<DoctorModel> get doctors => doctorListUiResponse.doctorList;
  List<DoctorModel> get allDoctors => doctorListUiResponse.doctorList;
  List<DoctorModel> get displayedDoctors => doctorListUiResponse.doctorList;
  MetaUiModel get metaUiModel => doctorListUiResponse.metaUiModel;

  DoctorListsLoadedState copyWith({
    DoctorListsUiResponse? doctorListUiResponse,
    Set<String>? favoriteDoctorIds,
  }) {
    return DoctorListsLoadedState(
      doctorListUiResponse ?? this.doctorListUiResponse,
      favoriteDoctorIds: favoriteDoctorIds ?? this.favoriteDoctorIds,
    );
  }
}

class NoMoreDataToLoadState extends DoctorListsState {
  @override
  List<Object> get props => [];
}

// Aliases for compatibility
typedef DoctorListState = DoctorListsState;
typedef DoctorListInitialState = DoctorListsInitial;
typedef DoctorListLoadingState = DoctorListListLoadingState;
typedef DoctorListLoadedState = DoctorListsLoadedState;
