import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/pharmacies_list/domain/entities/pharmacy_lists_ui_response.dart';
import 'package:app_health/features/pharmacies_list/domain/usecases/get_pharmacies_list_use_case.dart';
import 'package:app_health/features/pharmacies_list/presentation/bloc/pharmacies_list_event.dart';
import 'package:app_health/features/pharmacies_list/presentation/bloc/pharmacies_list_state.dart';

class PharmaciesListsBloc
    extends Bloc<PharmaciesListsEvent, PharmaciesListsState> {
  final GetPharmaciesListUseCase getPharmaciesListUseCase;
  Set<String> _favoritePharmacyIds = {};

  PharmaciesListsBloc({
    required this.getPharmaciesListUseCase,
  }) : super(PharmaciesListsInitial()) {
    on<GetPharmaciesListsApiEvent>(_getPharmaciesListsApiEvent);
    on<NoMoreDataToLoadEvent>(_noMoreDataToLoadEvent);
    on<ToggleFavoritePharmacyEvent>(_toggleFavoritePharmacyEvent);
    on<ChangePharmacySearchEvent>(_changePharmacySearchEvent);
  }

  FutureOr<void> _getPharmaciesListsApiEvent(
      GetPharmaciesListsApiEvent event,
      Emitter<PharmaciesListsState> emit) async {
    emit((event.isFirstLoad())
        ? PharmacyListLoadingState()
        : PharmacyListLoadingAsPagingState());

    Either<ErrorApiModel, PharmacyListsUiResponse> response =
        await getPharmaciesListUseCase(event.sendModel);

    emit(response.fold(
      (failure) => PharmacyListErrorState(
          failure.message, failure.isMessageLocalizationKey),
      (state) => PharmaciesListsLoadedState(
        state,
        favoritePharmacyIds: _favoritePharmacyIds,
      ),
    ));
  }

  FutureOr<void> _noMoreDataToLoadEvent(
      NoMoreDataToLoadEvent event, Emitter<PharmaciesListsState> emit) {
    emit(NoMorePharmacyDataToLoadState());
  }

  FutureOr<void> _changePharmacySearchEvent(
      ChangePharmacySearchEvent event, Emitter<PharmaciesListsState> emit) {
    // Can be used if debounced search is listened
  }

  FutureOr<void> _toggleFavoritePharmacyEvent(
      ToggleFavoritePharmacyEvent event,
      Emitter<PharmaciesListsState> emit) {
    final updated = Set<String>.from(_favoritePharmacyIds);
    if (updated.contains(event.pharmacyId)) {
      updated.remove(event.pharmacyId);
    } else {
      updated.add(event.pharmacyId);
    }
    _favoritePharmacyIds = updated;
    if (state is PharmaciesListsLoadedState) {
      final loaded = state as PharmaciesListsLoadedState;
      emit(PharmaciesListsLoadedState(
        loaded.pharmacyListUiResponse,
        favoritePharmacyIds: _favoritePharmacyIds,
      ));
    }
  }
}

// Aliases for compatibility
typedef PharmaciesListBloc = PharmaciesListsBloc;
typedef PharmacyListBloc = PharmaciesListsBloc;

