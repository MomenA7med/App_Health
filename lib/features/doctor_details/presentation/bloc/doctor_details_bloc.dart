import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/features/doctor_details/domain/usecases/get_doctor_profile_use_case.dart';
import 'package:app_health/features/doctor_details/domain/usecases/get_doctor_reviews_use_case.dart';
import 'package:app_health/features/doctor_details/presentation/bloc/doctor_details_event.dart';
import 'package:app_health/features/doctor_details/presentation/bloc/doctor_details_state.dart';

class DoctorDetailsBloc extends Bloc<DoctorDetailsEvent, DoctorDetailsState> {
  final GetDoctorProfileUseCase getDoctorProfileUseCase;
  final GetDoctorReviewsUseCase getDoctorReviewsUseCase;

  DoctorDetailsBloc({
    required this.getDoctorProfileUseCase,
    required this.getDoctorReviewsUseCase,
  }) : super(DoctorDetailsInitial()) {
    on<FetchDoctorDetailsEvent>(_fetchDoctorDetailsEvent);
    on<ChangeDoctorDetailsTabEvent>(_changeDoctorDetailsTabEvent);
    on<ToggleDoctorFavoriteEvent>(_toggleDoctorFavoriteEvent);
  }

  FutureOr<void> _fetchDoctorDetailsEvent(
    FetchDoctorDetailsEvent event,
    Emitter<DoctorDetailsState> emit,
  ) async {
    emit(DoctorDetailsLoadingState());

    final profileResult = await getDoctorProfileUseCase(event.doctorId);

    await profileResult.fold(
      (failure) async {
        emit(DoctorDetailsErrorState(
          failure.message,
          failure.isMessageLocalizationKey,
        ));
      },
      (profileResponse) async {
        final doctor = profileResponse.data;
        emit(DoctorDetailsLoadedState(
          doctor: doctor,
          isFavorite: doctor.isFavorite,
          reviewsLoading: true,
        ));

        // Fetch reviews in background
        final reviewsResult = await getDoctorReviewsUseCase(event.doctorId);
        if (state is DoctorDetailsLoadedState) {
          final current = state as DoctorDetailsLoadedState;
          reviewsResult.fold(
            (revError) {
              emit(current.copyWith(
                reviewsLoading: false,
                reviewsError: revError.message,
              ));
            },
            (revResponse) {
              emit(current.copyWith(
                reviews: revResponse.data,
                reviewsLoading: false,
              ));
            },
          );
        }
      },
    );
  }

  FutureOr<void> _changeDoctorDetailsTabEvent(
    ChangeDoctorDetailsTabEvent event,
    Emitter<DoctorDetailsState> emit,
  ) {
    if (state is DoctorDetailsLoadedState) {
      final current = state as DoctorDetailsLoadedState;
      emit(current.copyWith(activeTab: event.tabIndex));
    }
  }

  FutureOr<void> _toggleDoctorFavoriteEvent(
    ToggleDoctorFavoriteEvent event,
    Emitter<DoctorDetailsState> emit,
  ) {
    if (state is DoctorDetailsLoadedState) {
      final current = state as DoctorDetailsLoadedState;
      emit(current.copyWith(isFavorite: !current.isFavorite));
    }
  }
}

