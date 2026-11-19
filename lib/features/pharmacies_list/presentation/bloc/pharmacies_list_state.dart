import 'package:equatable/equatable.dart';
import 'package:app_health/features/core/domain/entities/meta/meta_ui_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';
import 'package:app_health/features/pharmacies_list/domain/entities/pharmacy_lists_ui_response.dart';

abstract class PharmaciesListsState extends Equatable {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class PharmaciesListsInitial extends PharmaciesListsState {}

class PharmacyListLoadingState extends PharmaciesListsState {}

class PharmacyListLoadingAsPagingState extends PharmaciesListsState {}

class PharmacyListErrorState extends PharmaciesListsState {
  final String errorMassage;
  final bool isLocalizationKey;

  PharmacyListErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];

  String get errorMessage => errorMassage;
}

class PharmaciesListsLoadedState extends PharmaciesListsState {
  final PharmacyListsUiResponse pharmacyListUiResponse;
  final Set<String> favoritePharmacyIds;

  PharmaciesListsLoadedState(
    this.pharmacyListUiResponse, {
    this.favoritePharmacyIds = const {},
  });

  PharmacyListsUiResponse get pharmacyListResponse => pharmacyListUiResponse;
  List<PharmacyModel> get pharmacyList => pharmacyListUiResponse.pharmacyList;
  List<PharmacyModel> get pharmacies => pharmacyListUiResponse.pharmacyList;
  List<PharmacyModel> get allPharmacies => pharmacyListUiResponse.pharmacyList;
  List<PharmacyModel> get displayedPharmacies =>
      pharmacyListUiResponse.pharmacyList;
  MetaUiModel get metaUiModel => pharmacyListUiResponse.metaUiModel;

  PharmaciesListsLoadedState copyWith({
    PharmacyListsUiResponse? pharmacyListUiResponse,
    Set<String>? favoritePharmacyIds,
  }) {
    return PharmaciesListsLoadedState(
      pharmacyListUiResponse ?? this.pharmacyListUiResponse,
      favoritePharmacyIds: favoritePharmacyIds ?? this.favoritePharmacyIds,
    );
  }

  @override
  List<Object> get props => [
        pharmacyListUiResponse,
        favoritePharmacyIds,
      ];
}

class NoMorePharmacyDataToLoadState extends PharmaciesListsState {}

// Aliases for compatibility
typedef PharmacyListState = PharmaciesListsState;
typedef PharmacyListsLoadedState = PharmaciesListsLoadedState;
typedef PharmacyListsInitial = PharmaciesListsInitial;

