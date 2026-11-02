part of 'medical_specialties_bloc.dart';

abstract class MedicalSpecialtiesEvent extends Equatable {
  const MedicalSpecialtiesEvent();

  @override
  List<Object?> get props => [];
}

class FetchMedicalSpecialtiesEvent extends MedicalSpecialtiesEvent {
  const FetchMedicalSpecialtiesEvent();
}

class SearchSpecialtiesEvent extends MedicalSpecialtiesEvent {
  final String query;

  const SearchSpecialtiesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

