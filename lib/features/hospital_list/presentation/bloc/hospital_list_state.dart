import 'package:equatable/equatable.dart';
import 'package:app_health/features/core/domain/entities/meta/meta_ui_model.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_model.dart';
import 'package:app_health/features/hospital_list/domain/entities/hospital_lists_ui_response.dart';

abstract class HospitalListsState extends Equatable {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class HospitalListsInitial extends HospitalListsState {}

class HospitalListLoadingState extends HospitalListsState {}

class HospitalListLoadingAsPagingState extends HospitalListsState {}

class HospitalListErrorState extends HospitalListsState {
  final String errorMassage;
  final bool isLocalizationKey;

  HospitalListErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];

  String get errorMessage => errorMassage;
}

class HospitalListsLoadedState extends HospitalListsState {
  final HospitalListsUiResponse hospitalListUiResponse;
  final Set<String> favoriteHospitalIds;

  HospitalListsLoadedState(
    this.hospitalListUiResponse, {
    this.favoriteHospitalIds = const {},
  });

  HospitalListsUiResponse get hospitalListResponse => hospitalListUiResponse;
  List<HospitalModel> get hospitalList => hospitalListUiResponse.hospitalList;
  List<HospitalModel> get hospitals => hospitalListUiResponse.hospitalList;
  List<HospitalModel> get allHospitals => hospitalListUiResponse.hospitalList;
  List<HospitalModel> get displayedHospitals =>
      hospitalListUiResponse.hospitalList;
  MetaUiModel get metaUiModel => hospitalListUiResponse.metaUiModel;

  HospitalListsLoadedState copyWith({
    HospitalListsUiResponse? hospitalListUiResponse,
    Set<String>? favoriteHospitalIds,
  }) {
    return HospitalListsLoadedState(
      hospitalListUiResponse ?? this.hospitalListUiResponse,
      favoriteHospitalIds: favoriteHospitalIds ?? this.favoriteHospitalIds,
    );
  }
}

class NoMoreHospitalDataToLoadState extends HospitalListsState {
  @override
  List<Object> get props => [];
}

// Aliases for compatibility
typedef HospitalListState = HospitalListsState;

