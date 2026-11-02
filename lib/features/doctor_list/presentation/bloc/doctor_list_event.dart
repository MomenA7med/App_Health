import 'package:equatable/equatable.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';

abstract class DoctorListEvent extends Equatable {
  const DoctorListEvent();

  @override
  List<Object?> get props => [];
}

class FetchSpecialtyDoctorsEvent extends DoctorListEvent {
  final String specialtyId;
  final bool isRefresh;

  const FetchSpecialtyDoctorsEvent({
    required this.specialtyId,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [specialtyId, isRefresh];
}

class SearchDoctorsEvent extends DoctorListEvent {
  final String query;

  const SearchDoctorsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ApplyFilterEvent extends DoctorListEvent {
  final DoctorFilterModel filter;

  const ApplyFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ResetFilterEvent extends DoctorListEvent {
  const ResetFilterEvent();
}

class ChangeSortOptionEvent extends DoctorListEvent {
  final DoctorSortOption sortOption;

  const ChangeSortOptionEvent(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}

class ToggleFavoriteDoctorEvent extends DoctorListEvent {
  final String doctorId;

  const ToggleFavoriteDoctorEvent(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

