import 'package:equatable/equatable.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';
import 'package:app_health/features/send_prescription/data/models/send_prescription_response_model.dart';

enum SendPrescriptionStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

class SendPrescriptionState extends Equatable {
  final SendPrescriptionStatus status;
  final String? imagePath;
  final List<String> imagePaths;
  final bool isWithoutPrescription;
  final int locationStrategy; // 1: Saved Address, 0: Manual Area
  final List<UserAddressModel> savedAddresses;
  final UserAddressModel? selectedSavedAddress;
  final List<GovernorateModel> governorates;
  final GovernorateModel? selectedGovernorate;
  final AreaModel? selectedArea;
  final List<PharmacyModel> availablePharmacies;
  final List<PharmacyModel> selectedPharmacies;
  final String orderDetails;
  final String? errorMessage;
  final bool isErrorLocalizationKey;
  final PrescriptionOrderModel? submittedOrder;

  const SendPrescriptionState({
    this.status = SendPrescriptionStatus.initial,
    this.imagePath,
    this.imagePaths = const [],
    this.isWithoutPrescription = false,
    this.locationStrategy = 1,
    this.savedAddresses = const [],
    this.selectedSavedAddress,
    this.governorates = const [],
    this.selectedGovernorate,
    this.selectedArea,
    this.availablePharmacies = const [],
    this.selectedPharmacies = const [],
    this.orderDetails = '',
    this.errorMessage,
    this.isErrorLocalizationKey = true,
    this.submittedOrder,
  });

  bool get canSubmit {
    if (selectedPharmacies.isEmpty) return false;
    if (locationStrategy == 1 && selectedSavedAddress == null) return false;
    if (locationStrategy == 0 &&
        (selectedGovernorate == null || selectedArea == null)) {
      return false;
    }
    return true;
  }

  SendPrescriptionState copyWith({
    SendPrescriptionStatus? status,
    String? imagePath,
    List<String>? imagePaths,
    bool? isWithoutPrescription,
    int? locationStrategy,
    List<UserAddressModel>? savedAddresses,
    UserAddressModel? selectedSavedAddress,
    List<GovernorateModel>? governorates,
    GovernorateModel? selectedGovernorate,
    AreaModel? selectedArea,
    List<PharmacyModel>? availablePharmacies,
    List<PharmacyModel>? selectedPharmacies,
    String? orderDetails,
    String? errorMessage,
    bool? isErrorLocalizationKey,
    PrescriptionOrderModel? submittedOrder,
    bool clearImage = false,
    bool clearArea = false,
  }) {
    return SendPrescriptionState(
      status: status ?? this.status,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      imagePaths: clearImage ? const [] : (imagePaths ?? this.imagePaths),
      isWithoutPrescription:
          isWithoutPrescription ?? this.isWithoutPrescription,
      locationStrategy: locationStrategy ?? this.locationStrategy,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      selectedSavedAddress: selectedSavedAddress ?? this.selectedSavedAddress,
      governorates: governorates ?? this.governorates,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedArea: clearArea ? null : (selectedArea ?? this.selectedArea),
      availablePharmacies: availablePharmacies ?? this.availablePharmacies,
      selectedPharmacies: selectedPharmacies ?? this.selectedPharmacies,
      orderDetails: orderDetails ?? this.orderDetails,
      errorMessage: errorMessage,
      isErrorLocalizationKey:
          isErrorLocalizationKey ?? this.isErrorLocalizationKey,
      submittedOrder: submittedOrder ?? this.submittedOrder,
    );
  }

  @override
  List<Object?> get props => [
        status,
        imagePath,
        imagePaths,
        isWithoutPrescription,
        locationStrategy,
        savedAddresses,
        selectedSavedAddress,
        governorates,
        selectedGovernorate,
        selectedArea,
        availablePharmacies,
        selectedPharmacies,
        orderDetails,
        errorMessage,
        isErrorLocalizationKey,
        submittedOrder,
      ];
}

