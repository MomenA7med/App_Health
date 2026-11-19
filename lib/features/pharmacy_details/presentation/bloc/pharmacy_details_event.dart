import 'package:equatable/equatable.dart';

abstract class PharmacyDetailsEvent extends Equatable {
  const PharmacyDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPharmacyDetailsEvent extends PharmacyDetailsEvent {
  final String pharmacyId;

  const FetchPharmacyDetailsEvent({required this.pharmacyId});

  @override
  List<Object?> get props => [pharmacyId];
}

class ChangePharmacyDetailsTabEvent extends PharmacyDetailsEvent {
  final int tabIndex;

  const ChangePharmacyDetailsTabEvent({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

class TogglePharmacyFavoriteEvent extends PharmacyDetailsEvent {
  const TogglePharmacyFavoriteEvent();
}

