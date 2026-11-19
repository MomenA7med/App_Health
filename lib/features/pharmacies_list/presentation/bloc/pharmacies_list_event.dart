import 'package:equatable/equatable.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';

abstract class PharmaciesListsEvent extends Equatable {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetPharmaciesListsApiEvent extends PharmaciesListsEvent {
  final PharmacyListSendModel sendModel;

  GetPharmaciesListsApiEvent({required this.sendModel});

  bool isFirstLoad() => (sendModel.pagination.pageNumber == 1);
}

class NoMoreDataToLoadEvent extends PharmaciesListsEvent {
  @override
  List<Object> get props => [];
}

class ChangePharmacySearchEvent extends PharmaciesListsEvent {
  final String searchText;

  ChangePharmacySearchEvent(this.searchText);
}

class ToggleFavoritePharmacyEvent extends PharmaciesListsEvent {
  final String pharmacyId;

  ToggleFavoritePharmacyEvent(this.pharmacyId);
}

// Aliases for compatibility
typedef PharmacyListEvent = PharmaciesListsEvent;
typedef GetPharmacyListsApiEvent = GetPharmaciesListsApiEvent;

