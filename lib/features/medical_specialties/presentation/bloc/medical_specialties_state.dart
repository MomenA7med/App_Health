part of 'medical_specialties_bloc.dart';

abstract class MedicalSpecialtiesState extends Equatable {
  const MedicalSpecialtiesState();

  @override
  List<Object?> get props => [];
}

class MedicalSpecialtiesInitialState extends MedicalSpecialtiesState {
  const MedicalSpecialtiesInitialState();
}

class MedicalSpecialtiesLoadingState extends MedicalSpecialtiesState {
  const MedicalSpecialtiesLoadingState();
}

class MedicalSpecialtiesLoadedState extends MedicalSpecialtiesState {
  final List<MedicalSpecialtyModel> allSpecialties;
  final List<MedicalSpecialtyModel> filteredSpecialties;
  final String query;

  const MedicalSpecialtiesLoadedState({
    required this.allSpecialties,
    required this.filteredSpecialties,
    this.query = '',
  });

  @override
  List<Object?> get props => [allSpecialties, filteredSpecialties, query];
}

class MedicalSpecialtiesErrorState extends MedicalSpecialtiesState {
  final String errorMessage;
  final bool isLocalizationKey;

  const MedicalSpecialtiesErrorState({
    required this.errorMessage,
    required this.isLocalizationKey,
  });

  @override
  List<Object?> get props => [errorMessage, isLocalizationKey];
}

