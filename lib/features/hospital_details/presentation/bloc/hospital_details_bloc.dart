import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/features/hospital_details/domain/usecases/get_hospital_profile_use_case.dart';
import 'package:app_health/features/hospital_details/presentation/bloc/hospital_details_event.dart';
import 'package:app_health/features/hospital_details/presentation/bloc/hospital_details_state.dart';

class HospitalDetailsBloc
    extends Bloc<HospitalDetailsEvent, HospitalDetailsState> {
  final GetHospitalProfileUseCase getHospitalProfileUseCase;

  HospitalDetailsBloc({
    required this.getHospitalProfileUseCase,
  }) : super(HospitalDetailsInitial()) {
    on<FetchHospitalDetailsEvent>(_onFetchHospitalDetails);
    on<ChangeHospitalDetailsTabEvent>(_onChangeTab);
    on<ToggleHospitalFavoriteEvent>(_onToggleFavorite);
  }

  FutureOr<void> _onFetchHospitalDetails(
    FetchHospitalDetailsEvent event,
    Emitter<HospitalDetailsState> emit,
  ) async {
    emit(HospitalDetailsLoadingState());

    final result = await getHospitalProfileUseCase(event.hospitalId);

    result.fold(
      (failure) => emit(HospitalDetailsErrorState(
        failure.message,
        failure.isMessageLocalizationKey,
      )),
      (response) => emit(HospitalDetailsLoadedState(
        hospital: response.data,
        isFavorite: response.data.isFavorite,
      )),
    );
  }

  FutureOr<void> _onChangeTab(
    ChangeHospitalDetailsTabEvent event,
    Emitter<HospitalDetailsState> emit,
  ) {
    if (state is HospitalDetailsLoadedState) {
      final loaded = state as HospitalDetailsLoadedState;
      emit(loaded.copyWith(activeTab: event.tabIndex));
    }
  }

  FutureOr<void> _onToggleFavorite(
    ToggleHospitalFavoriteEvent event,
    Emitter<HospitalDetailsState> emit,
  ) {
    if (state is HospitalDetailsLoadedState) {
      final loaded = state as HospitalDetailsLoadedState;
      emit(loaded.copyWith(isFavorite: !loaded.isFavorite));
    }
  }
}

