import 'package:equatable/equatable.dart';
import 'package:app_health/features/hospital_details/data/models/hospital_profile_response_model.dart';

abstract class HospitalDetailsState extends Equatable {
  const HospitalDetailsState();

  @override
  List<Object?> get props => [];
}

class HospitalDetailsInitial extends HospitalDetailsState {}

class HospitalDetailsLoadingState extends HospitalDetailsState {}

class HospitalDetailsLoadedState extends HospitalDetailsState {
  final HospitalProfileModel hospital;
  final int activeTab; // 0: Specialties, 1: Insurance, 2: About Hospital
  final bool isFavorite;

  const HospitalDetailsLoadedState({
    required this.hospital,
    this.activeTab = 0,
    required this.isFavorite,
  });

  HospitalDetailsLoadedState copyWith({
    HospitalProfileModel? hospital,
    int? activeTab,
    bool? isFavorite,
  }) {
    return HospitalDetailsLoadedState(
      hospital: hospital ?? this.hospital,
      activeTab: activeTab ?? this.activeTab,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [hospital, activeTab, isFavorite];
}

class HospitalDetailsErrorState extends HospitalDetailsState {
  final String message;
  final bool isMessageLocalizationKey;

  const HospitalDetailsErrorState(
    this.message,
    this.isMessageLocalizationKey,
  );

  @override
  List<Object?> get props => [message, isMessageLocalizationKey];
}

