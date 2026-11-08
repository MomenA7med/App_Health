import 'package:equatable/equatable.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_list_send_model.dart';

abstract class DoctorListsEvent extends Equatable {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetDoctorListsApiEvent extends DoctorListsEvent {
  final DoctorListSendModel sendModel;

  GetDoctorListsApiEvent({required this.sendModel});

  bool isFirstLoad() => (sendModel.pagination.pageNumber == 1) ? true : false;
}

class NoMoreDataToLoadEvent extends DoctorListsEvent {
  @override
  List<Object> get props => [];
}

class ChangeSearchEvent extends DoctorListsEvent {
  final String searchText;

  ChangeSearchEvent(this.searchText);
}

class ToggleFavoriteDoctorEvent extends DoctorListsEvent {
  final String doctorId;

  ToggleFavoriteDoctorEvent(this.doctorId);
}

// Aliases for compatibility
typedef DoctorListEvent = DoctorListsEvent;
typedef LoadMoreDoctorsEvent = NoMoreDataToLoadEvent;
