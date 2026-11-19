import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_health/apis/errors/error_api_model.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_list_send_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_send_model.dart';
import 'package:app_health/features/send_prescription/domain/usecases/get_prescription_governorates_use_case.dart';
import 'package:app_health/features/send_prescription/domain/usecases/get_prescription_pharmacies_use_case.dart';
import 'package:app_health/features/send_prescription/domain/usecases/get_prescription_saved_addresses_use_case.dart';
import 'package:app_health/features/send_prescription/domain/usecases/send_prescription_use_case.dart';
import 'package:app_health/features/send_prescription/presentation/bloc/send_prescription_event.dart';
import 'package:app_health/features/send_prescription/presentation/bloc/send_prescription_state.dart';
import 'package:app_health/utils/locale/app_localization_keys.dart';

class SendPrescriptionBloc
    extends Bloc<SendPrescriptionEvent, SendPrescriptionState> {
  final SendPrescriptionUseCase sendPrescriptionUseCase;
  final GetPrescriptionGovernoratesUseCase getGovernoratesUseCase;
  final GetPrescriptionPharmaciesUseCase getPharmaciesUseCase;
  final GetPrescriptionSavedAddressesUseCase getSavedAddressesUseCase;

  SendPrescriptionBloc({
    required this.sendPrescriptionUseCase,
    required this.getGovernoratesUseCase,
    required this.getPharmaciesUseCase,
    required this.getSavedAddressesUseCase,
  }) : super(const SendPrescriptionState()) {
    on<InitSendPrescriptionEvent>(_onInit);
    on<SetPrescriptionImageEvent>(_onSetImage);
    on<ChangeLocationStrategyEvent>(_onChangeLocationStrategy);
    on<SelectSavedAddressEvent>(_onSelectSavedAddress);
    on<SelectGovernorateEvent>(_onSelectGovernorate);
    on<SelectAreaEvent>(_onSelectArea);
    on<ToggleSelectPharmacyEvent>(_onToggleSelectPharmacy);
    on<RemovePharmacyEvent>(_onRemovePharmacy);
    on<UpdateOrderDetailsEvent>(_onUpdateOrderDetails);
    on<SubmitPrescriptionOrderEvent>(_onSubmit);
  }

  Future<void> _onInit(
    InitSendPrescriptionEvent event,
    Emitter<SendPrescriptionState> emit,
  ) async {
    final initialImages = event.imagePaths ??
        (event.imagePath != null && event.imagePath!.isNotEmpty
            ? [event.imagePath!]
            : const <String>[]);

    emit(state.copyWith(
      status: SendPrescriptionStatus.loading,
      imagePath: event.imagePath ??
          (initialImages.isNotEmpty ? initialImages.first : null),
      imagePaths: initialImages,
      isWithoutPrescription: event.isWithoutPrescription,
    ));

    List<GovernorateModel> governorates = [];
    List<UserAddressModel> addresses = [];
    List<PharmacyModel> pharmacies = [];

    try {
      final govResult = await getGovernoratesUseCase();
      governorates = govResult;
    } catch (_) {}

    try {
      final addrResult = await getSavedAddressesUseCase();
      addresses = addrResult;
    } catch (_) {}

    try {
      final pharmResult = await getPharmaciesUseCase(
        PharmacyListSendModel(
          pagination: PagingListSendModel(pageNumber: 1, pageSize: 30),
        ),
      );
      pharmacies = pharmResult.data.items;
    } catch (_) {}

    final defaultAddress = addresses.isNotEmpty ? addresses.first : null;
    final List<PharmacyModel> initialSelected = [];

    if (event.preselectedPharmacyId != null) {
      final matches =
          pharmacies.where((p) => p.id == event.preselectedPharmacyId);
      if (matches.isNotEmpty) {
        initialSelected.add(matches.first);
      }
    }

    emit(state.copyWith(
      status: SendPrescriptionStatus.loaded,
      governorates: governorates,
      savedAddresses: addresses,
      selectedSavedAddress: defaultAddress,
      availablePharmacies: pharmacies,
      selectedPharmacies: initialSelected,
      locationStrategy: defaultAddress != null ? 1 : 0,
    ));
  }

  void _onSetImage(
    SetPrescriptionImageEvent event,
    Emitter<SendPrescriptionState> emit,
  ) {
    final paths = event.imagePaths ??
        (event.imagePath != null && event.imagePath!.isNotEmpty
            ? [event.imagePath!]
            : null);

    if (paths == null || paths.isEmpty) {
      emit(state.copyWith(
        clearImage: true,
        imagePaths: const [],
        isWithoutPrescription: true,
      ));
    } else {
      emit(state.copyWith(
        imagePath: paths.first,
        imagePaths: paths,
        isWithoutPrescription: false,
      ));
    }
  }

  void _onChangeLocationStrategy(
    ChangeLocationStrategyEvent event,
    Emitter<SendPrescriptionState> emit,
  ) {
    emit(state.copyWith(locationStrategy: event.strategy));
    _refreshPharmacies(emit);
  }

  void _onSelectSavedAddress(
    SelectSavedAddressEvent event,
    Emitter<SendPrescriptionState> emit,
  ) {
    emit(state.copyWith(selectedSavedAddress: event.address));
    _refreshPharmacies(emit);
  }

  void _onSelectGovernorate(
    SelectGovernorateEvent event,
    Emitter<SendPrescriptionState> emit,
  ) {
    emit(state.copyWith(
      selectedGovernorate: event.governorate,
      clearArea: true,
    ));
  }

  void _onSelectArea(
    SelectAreaEvent event,
    Emitter<SendPrescriptionState> emit,
  ) {
    emit(state.copyWith(selectedArea: event.area));
    _refreshPharmacies(emit);
  }

  Future<void> _refreshPharmacies(Emitter<SendPrescriptionState> emit) async {
    try {
      final sendModel = PharmacyListSendModel(
        pagination: PagingListSendModel(pageNumber: 1, pageSize: 30),
        locationStrategy: state.locationStrategy,
        governorateId: state.locationStrategy == 0
            ? state.selectedGovernorate?.id
            : null,
        areaId:
            state.locationStrategy == 0 ? state.selectedArea?.id : null,
      );

      final result = await getPharmaciesUseCase(sendModel);
      emit(state.copyWith(availablePharmacies: result.data.items));
    } catch (_) {}
  }

  void _onToggleSelectPharmacy(
    ToggleSelectPharmacyEvent event,
    Emitter<SendPrescriptionState> emit,
  ) {
    final current = List<PharmacyModel>.from(state.selectedPharmacies);
    final existsIndex = current.indexWhere((p) => p.id == event.pharmacy.id);

    if (existsIndex >= 0) {
      current.removeAt(existsIndex);
    } else {
      current.add(event.pharmacy);
    }

    emit(state.copyWith(selectedPharmacies: current));
  }

  void _onRemovePharmacy(
    RemovePharmacyEvent event,
    Emitter<SendPrescriptionState> emit,
  ) {
    final current = List<PharmacyModel>.from(state.selectedPharmacies);
    current.removeWhere((p) => p.id == event.pharmacyId);
    emit(state.copyWith(selectedPharmacies: current));
  }

  void _onUpdateOrderDetails(
    UpdateOrderDetailsEvent event,
    Emitter<SendPrescriptionState> emit,
  ) {
    emit(state.copyWith(orderDetails: event.details));
  }

  Future<void> _onSubmit(
    SubmitPrescriptionOrderEvent event,
    Emitter<SendPrescriptionState> emit,
  ) async {
    if (state.selectedPharmacies.isEmpty) {
      emit(state.copyWith(
        status: SendPrescriptionStatus.error,
        errorMessage: LocalizationKeys.pleaseSelectPharmacy,
        isErrorLocalizationKey: true,
      ));
      return;
    }

    if (state.locationStrategy == 1 && state.selectedSavedAddress == null) {
      emit(state.copyWith(
        status: SendPrescriptionStatus.error,
        errorMessage: LocalizationKeys.pleaseSelectAddress,
        isErrorLocalizationKey: true,
      ));
      return;
    }

    if (state.locationStrategy == 0 &&
        (state.selectedGovernorate == null || state.selectedArea == null)) {
      emit(state.copyWith(
        status: SendPrescriptionStatus.error,
        errorMessage: LocalizationKeys.pleaseSelectAddress,
        isErrorLocalizationKey: true,
      ));
      return;
    }

    emit(state.copyWith(status: SendPrescriptionStatus.submitting));

    try {
      final effectiveImages = state.isWithoutPrescription
          ? const <String>[]
          : (state.imagePaths.isNotEmpty
              ? state.imagePaths
              : (state.imagePath != null ? [state.imagePath!] : const <String>[]));

      final sendModel = SendPrescriptionSendModel(
        prescriptionImages: effectiveImages,
        locationStrategy: state.locationStrategy,
        savedAddressId: state.locationStrategy == 1
            ? state.selectedSavedAddress?.id
            : null,
        governorateId: state.locationStrategy == 0
            ? state.selectedGovernorate?.id
            : null,
        areaId: state.locationStrategy == 0 ? state.selectedArea?.id : null,
        pharmacyIds: state.selectedPharmacies.map((p) => p.id).toList(),
        orderDetails: state.orderDetails,
      );

      final response = await sendPrescriptionUseCase(sendModel);

      emit(state.copyWith(
        status: SendPrescriptionStatus.success,
        submittedOrder: response.data,
      ));
    } catch (e) {
      String errorMsg = LocalizationKeys.sendPrescriptionError;
      bool isKey = true;

      if (e is ErrorApiModel) {
        if (e.message.isNotEmpty) {
          errorMsg = e.message;
          isKey = false;
        }
      }

      emit(state.copyWith(
        status: SendPrescriptionStatus.error,
        errorMessage: errorMsg,
        isErrorLocalizationKey: isKey,
      ));
    }
  }
}

