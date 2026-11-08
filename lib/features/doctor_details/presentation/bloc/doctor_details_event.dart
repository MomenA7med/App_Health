import 'package:equatable/equatable.dart';

abstract class DoctorDetailsEvent extends Equatable {
  const DoctorDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchDoctorDetailsEvent extends DoctorDetailsEvent {
  final String doctorId;

  const FetchDoctorDetailsEvent({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}

class ChangeDoctorDetailsTabEvent extends DoctorDetailsEvent {
  final int tabIndex;

  const ChangeDoctorDetailsTabEvent({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

class ToggleDoctorFavoriteEvent extends DoctorDetailsEvent {
  const ToggleDoctorFavoriteEvent();
}

