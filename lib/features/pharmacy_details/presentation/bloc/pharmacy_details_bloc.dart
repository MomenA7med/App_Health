import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/features/pharmacy_details/domain/usecases/get_pharmacy_profile_use_case.dart';
import 'package:app_health/features/pharmacy_details/presentation/bloc/pharmacy_details_event.dart';
import 'package:app_health/features/pharmacy_details/presentation/bloc/pharmacy_details_state.dart';

class PharmacyDetailsBloc
    extends Bloc<PharmacyDetailsEvent, PharmacyDetailsState> {
  final GetPharmacyProfileUseCase getPharmacyProfileUseCase;

  PharmacyDetailsBloc({
    required this.getPharmacyProfileUseCase,
  }) : super(PharmacyDetailsInitial()) {
    on<FetchPharmacyDetailsEvent>(_onFetchPharmacyDetails);
    on<ChangePharmacyDetailsTabEvent>(_onChangeTab);
    on<TogglePharmacyFavoriteEvent>(_onToggleFavorite);
  }

  FutureOr<void> _onFetchPharmacyDetails(
    FetchPharmacyDetailsEvent event,
    Emitter<PharmacyDetailsState> emit,
  ) async {
    emit(PharmacyDetailsLoadingState());

    final result = await getPharmacyProfileUseCase(event.pharmacyId);

    result.fold(
      (failure) => emit(PharmacyDetailsErrorState(
        failure.message,
        failure.isMessageLocalizationKey,
      )),
      (response) => emit(PharmacyDetailsLoadedState(
        pharmacy: response.data,
        isFavorite: response.data.isFavorite,
      )),
    );
  }

  FutureOr<void> _onChangeTab(
    ChangePharmacyDetailsTabEvent event,
    Emitter<PharmacyDetailsState> emit,
  ) {
    if (state is PharmacyDetailsLoadedState) {
      final loaded = state as PharmacyDetailsLoadedState;
      emit(loaded.copyWith(activeTab: event.tabIndex));
    }
  }

  FutureOr<void> _onToggleFavorite(
    TogglePharmacyFavoriteEvent event,
    Emitter<PharmacyDetailsState> emit,
  ) {
    if (state is PharmacyDetailsLoadedState) {
      final loaded = state as PharmacyDetailsLoadedState;
      emit(loaded.copyWith(isFavorite: !loaded.isFavorite));
    }
  }
}

