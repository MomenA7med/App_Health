import 'package:equatable/equatable.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_list_send_model.dart';

abstract class HospitalListsEvent extends Equatable {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetHospitalListsApiEvent extends HospitalListsEvent {
  final HospitalListSendModel sendModel;

  GetHospitalListsApiEvent({required this.sendModel});

  bool isFirstLoad() => (sendModel.pagination.pageNumber == 1);
}

class NoMoreDataToLoadEvent extends HospitalListsEvent {
  @override
  List<Object> get props => [];
}

class ChangeHospitalSearchEvent extends HospitalListsEvent {
  final String searchText;

  ChangeHospitalSearchEvent(this.searchText);
}

class ToggleFavoriteHospitalEvent extends HospitalListsEvent {
  final String hospitalId;

  ToggleFavoriteHospitalEvent(this.hospitalId);
}

// Aliases for compatibility
typedef HospitalListEvent = HospitalListsEvent;

