import 'package:equatable/equatable.dart';
import 'package:app_health/features/pharmacy_details/data/models/pharmacy_profile_response_model.dart';

abstract class PharmacyDetailsState extends Equatable {
  const PharmacyDetailsState();

  @override
  List<Object?> get props => [];
}

class PharmacyDetailsInitial extends PharmacyDetailsState {}

class PharmacyDetailsLoadingState extends PharmacyDetailsState {}

class PharmacyDetailsLoadedState extends PharmacyDetailsState {
  final PharmacyProfileModel pharmacy;
  final int activeTab; // 0: About, 1: Branches, 2: Insurance
  final bool isFavorite;

  const PharmacyDetailsLoadedState({
    required this.pharmacy,
    this.activeTab = 0,
    required this.isFavorite,
  });

  PharmacyDetailsLoadedState copyWith({
    PharmacyProfileModel? pharmacy,
    int? activeTab,
    bool? isFavorite,
  }) {
    return PharmacyDetailsLoadedState(
      pharmacy: pharmacy ?? this.pharmacy,
      activeTab: activeTab ?? this.activeTab,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [pharmacy, activeTab, isFavorite];
}

class PharmacyDetailsErrorState extends PharmacyDetailsState {
  final String message;
  final bool isMessageLocalizationKey;

  const PharmacyDetailsErrorState(
    this.message,
    this.isMessageLocalizationKey,
  );

  @override
  List<Object?> get props => [message, isMessageLocalizationKey];
}

