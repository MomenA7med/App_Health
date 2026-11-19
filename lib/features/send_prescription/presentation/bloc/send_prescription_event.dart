import 'package:equatable/equatable.dart';
import 'package:app_health/features/addresses/data/models/user_address_model.dart';
import 'package:app_health/features/doctor_list/data/models/governorate_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';

abstract class SendPrescriptionEvent extends Equatable {
  const SendPrescriptionEvent();

  @override
  List<Object?> get props => [];
}

class InitSendPrescriptionEvent extends SendPrescriptionEvent {
  final String? imagePath;
  final List<String>? imagePaths;
  final bool isWithoutPrescription;
  final String? preselectedPharmacyId;

  const InitSendPrescriptionEvent({
    this.imagePath,
    this.imagePaths,
    this.isWithoutPrescription = false,
    this.preselectedPharmacyId,
  });

  @override
  List<Object?> get props => [
        imagePath,
        imagePaths,
        isWithoutPrescription,
        preselectedPharmacyId,
      ];
}

class SetPrescriptionImageEvent extends SendPrescriptionEvent {
  final String? imagePath;
  final List<String>? imagePaths;

  const SetPrescriptionImageEvent(this.imagePath, {this.imagePaths});

  @override
  List<Object?> get props => [imagePath, imagePaths];
}

class ChangeLocationStrategyEvent extends SendPrescriptionEvent {
  final int strategy;

  const ChangeLocationStrategyEvent(this.strategy);

  @override
  List<Object?> get props => [strategy];
}

class SelectSavedAddressEvent extends SendPrescriptionEvent {
  final UserAddressModel address;

  const SelectSavedAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class SelectGovernorateEvent extends SendPrescriptionEvent {
  final GovernorateModel governorate;

  const SelectGovernorateEvent(this.governorate);

  @override
  List<Object?> get props => [governorate];
}

class SelectAreaEvent extends SendPrescriptionEvent {
  final AreaModel area;

  const SelectAreaEvent(this.area);

  @override
  List<Object?> get props => [area];
}

class ToggleSelectPharmacyEvent extends SendPrescriptionEvent {
  final PharmacyModel pharmacy;

  const ToggleSelectPharmacyEvent(this.pharmacy);

  @override
  List<Object?> get props => [pharmacy];
}

class RemovePharmacyEvent extends SendPrescriptionEvent {
  final String pharmacyId;

  const RemovePharmacyEvent(this.pharmacyId);

  @override
  List<Object?> get props => [pharmacyId];
}

class UpdateOrderDetailsEvent extends SendPrescriptionEvent {
  final String details;

  const UpdateOrderDetailsEvent(this.details);

  @override
  List<Object?> get props => [details];
}

class SubmitPrescriptionOrderEvent extends SendPrescriptionEvent {
  const SubmitPrescriptionOrderEvent();
}

