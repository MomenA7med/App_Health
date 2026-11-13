import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/hospital_list/domain/entities/hospital_lists_ui_response.dart';
import 'package:app_health/features/hospital_list/domain/usecases/get_hospital_list_use_case.dart';
import 'package:app_health/features/hospital_list/presentation/bloc/hospital_list_event.dart';
import 'package:app_health/features/hospital_list/presentation/bloc/hospital_list_state.dart';

class HospitalListsBloc extends Bloc<HospitalListsEvent, HospitalListsState> {
  final GetHospitalListsUseCase getHospitalListsUseCase;
  Set<String> _favoriteHospitalIds = {};

  HospitalListsBloc({
    required this.getHospitalListsUseCase,
  }) : super(HospitalListsInitial()) {
    on<GetHospitalListsApiEvent>(_getHospitalListsApiEvent);
    on<NoMoreDataToLoadEvent>(_noMoreDataToLoadEvent);
    on<ToggleFavoriteHospitalEvent>(_toggleFavoriteHospitalEvent);
    on<ChangeHospitalSearchEvent>(_changeHospitalSearchEvent);
  }

  FutureOr<void> _getHospitalListsApiEvent(
      GetHospitalListsApiEvent event, Emitter<HospitalListsState> emit) async {
    emit((event.isFirstLoad())
        ? HospitalListLoadingState()
        : HospitalListLoadingAsPagingState());

    Either<ErrorApiModel, HospitalListsUiResponse> response =
        await getHospitalListsUseCase(event.sendModel);

    emit(response.fold(
      (failure) => HospitalListErrorState(
          failure.message, failure.isMessageLocalizationKey),
      (state) => HospitalListsLoadedState(
        state,
        favoriteHospitalIds: _favoriteHospitalIds,
      ),
    ));
  }

  FutureOr<void> _noMoreDataToLoadEvent(
      NoMoreDataToLoadEvent event, Emitter<HospitalListsState> emit) {
    emit(NoMoreHospitalDataToLoadState());
  }

  FutureOr<void> _changeHospitalSearchEvent(
      ChangeHospitalSearchEvent event, Emitter<HospitalListsState> emit) {
    // Can be used if debounced search is listened
  }

  FutureOr<void> _toggleFavoriteHospitalEvent(
      ToggleFavoriteHospitalEvent event, Emitter<HospitalListsState> emit) {
    final updated = Set<String>.from(_favoriteHospitalIds);
    if (updated.contains(event.hospitalId)) {
      updated.remove(event.hospitalId);
    } else {
      updated.add(event.hospitalId);
    }
    _favoriteHospitalIds = updated;
    if (state is HospitalListsLoadedState) {
      final loaded = state as HospitalListsLoadedState;
      emit(HospitalListsLoadedState(
        loaded.hospitalListUiResponse,
        favoriteHospitalIds: _favoriteHospitalIds,
      ));
    }
  }
}

// Aliases for compatibility
typedef HospitalListBloc = HospitalListsBloc;

