import 'package:equatable/equatable.dart';

abstract class HospitalDetailsEvent extends Equatable {
  const HospitalDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchHospitalDetailsEvent extends HospitalDetailsEvent {
  final String hospitalId;

  const FetchHospitalDetailsEvent({required this.hospitalId});

  @override
  List<Object?> get props => [hospitalId];
}

class ChangeHospitalDetailsTabEvent extends HospitalDetailsEvent {
  final int tabIndex;

  const ChangeHospitalDetailsTabEvent({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

class ToggleHospitalFavoriteEvent extends HospitalDetailsEvent {
  const ToggleHospitalFavoriteEvent();
}

