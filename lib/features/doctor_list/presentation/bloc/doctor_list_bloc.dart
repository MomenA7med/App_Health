import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/doctor_list/domain/entities/doctor_lists_ui_response.dart';
import 'package:app_health/features/doctor_list/domain/usecases/get_doctor_list_use_case.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_event.dart';
import 'package:app_health/features/doctor_list/presentation/bloc/doctor_list_state.dart';

class DoctorListsBloc extends Bloc<DoctorListsEvent, DoctorListsState> {
  final GetDoctorListsUseCase getDoctorListsUseCase;
  Set<String> _favoriteDoctorIds = {};

  DoctorListsBloc({
    required this.getDoctorListsUseCase,
  }) : super(DoctorListsInitial()) {
    on<GetDoctorListsApiEvent>(_getDoctorListsApiEvent);
    on<NoMoreDataToLoadEvent>(_noMoreDataToLoadEvent);
    on<ToggleFavoriteDoctorEvent>(_toggleFavoriteDoctorEvent);
    on<ChangeSearchEvent>(_changeSearchEvent);
  }

  FutureOr<void> _getDoctorListsApiEvent(
      GetDoctorListsApiEvent event, Emitter<DoctorListsState> emit) async {
    emit((event.isFirstLoad())
        ? DoctorListListLoadingState()
        : DoctorListLoadingAsPagingState());

    Either<ErrorApiModel, DoctorListsUiResponse> response =
        await getDoctorListsUseCase(event.sendModel);

    emit(response.fold(
      (failure) => DoctorListErrorState(
          failure.message, failure.isMessageLocalizationKey),
      (state) => DoctorListsLoadedState(state,
          favoriteDoctorIds: _favoriteDoctorIds),
    ));
  }

  FutureOr<void> _noMoreDataToLoadEvent(
      NoMoreDataToLoadEvent event, Emitter<DoctorListsState> emit) {
    emit(NoMoreDataToLoadState());
  }

  FutureOr<void> _changeSearchEvent(
      ChangeSearchEvent event, Emitter<DoctorListsState> emit) {
    // Can be used if debounced search is listened
  }

  FutureOr<void> _toggleFavoriteDoctorEvent(
      ToggleFavoriteDoctorEvent event, Emitter<DoctorListsState> emit) {
    final updated = Set<String>.from(_favoriteDoctorIds);
    if (updated.contains(event.doctorId)) {
      updated.remove(event.doctorId);
    } else {
      updated.add(event.doctorId);
    }
    _favoriteDoctorIds = updated;
    if (state is DoctorListsLoadedState) {
      final loaded = state as DoctorListsLoadedState;
      emit(DoctorListsLoadedState(loaded.doctorListUiResponse,
          favoriteDoctorIds: _favoriteDoctorIds));
    }
  }
}

// Aliases for compatibility
typedef DoctorListBloc = DoctorListsBloc;
