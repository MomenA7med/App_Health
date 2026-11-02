import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/core/usecase.dart';
import 'package:app_health/features/medical_specialties/data/models/medical_specialties_response_model.dart';
import 'package:app_health/features/medical_specialties/domain/usecases/get_medical_specialties_usecase.dart';

part 'medical_specialties_event.dart';
part 'medical_specialties_state.dart';

class MedicalSpecialtiesBloc
    extends Bloc<MedicalSpecialtiesEvent, MedicalSpecialtiesState> {
  final GetMedicalSpecialtiesUseCase getMedicalSpecialtiesUseCase;

  MedicalSpecialtiesBloc({required this.getMedicalSpecialtiesUseCase})
      : super(const MedicalSpecialtiesInitialState()) {
    on<FetchMedicalSpecialtiesEvent>(_onFetchMedicalSpecialties);
    on<SearchSpecialtiesEvent>(_onSearchSpecialties);
  }

  FutureOr<void> _onFetchMedicalSpecialties(
    FetchMedicalSpecialtiesEvent event,
    Emitter<MedicalSpecialtiesState> emit,
  ) async {
    emit(const MedicalSpecialtiesLoadingState());

    final Either<ErrorApiModel, MedicalSpecialtiesResponseModel> result =
        await getMedicalSpecialtiesUseCase(NoParams());

    result.fold(
      (error) {
        emit(
          MedicalSpecialtiesErrorState(
            errorMessage: error.message,
            isLocalizationKey: error.isMessageLocalizationKey,
          ),
        );
      },
      (response) {
        final List<MedicalSpecialtyModel> sortedList =
            List<MedicalSpecialtyModel>.from(response.data)
              ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

        emit(
          MedicalSpecialtiesLoadedState(
            allSpecialties: sortedList,
            filteredSpecialties: sortedList,
            query: '',
          ),
        );
      },
    );
  }

  FutureOr<void> _onSearchSpecialties(
    SearchSpecialtiesEvent event,
    Emitter<MedicalSpecialtiesState> emit,
  ) {
    final MedicalSpecialtiesState currentState = state;
    if (currentState is MedicalSpecialtiesLoadedState) {
      final String trimmedQuery = event.query.trim().toLowerCase();
      if (trimmedQuery.isEmpty) {
        emit(
          MedicalSpecialtiesLoadedState(
            allSpecialties: currentState.allSpecialties,
            filteredSpecialties: currentState.allSpecialties,
            query: '',
          ),
        );
      } else {
        final List<MedicalSpecialtyModel> filtered =
            currentState.allSpecialties.where((specialty) {
              final bool matchesAr = specialty.nameAr.toLowerCase().contains(
                trimmedQuery,
              );
              final bool matchesEn = specialty.nameEn.toLowerCase().contains(
                trimmedQuery,
              );
              final bool matchesDescAr = specialty.descriptionAr
                  .toLowerCase()
                  .contains(trimmedQuery);
              final bool matchesDescEn = specialty.descriptionEn
                  .toLowerCase()
                  .contains(trimmedQuery);
              return matchesAr || matchesEn || matchesDescAr || matchesDescEn;
            }).toList();

        emit(
          MedicalSpecialtiesLoadedState(
            allSpecialties: currentState.allSpecialties,
            filteredSpecialties: filtered,
            query: event.query,
          ),
        );
      }
    }
  }
}

