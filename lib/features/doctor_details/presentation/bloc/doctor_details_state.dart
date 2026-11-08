import 'package:equatable/equatable.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_profile_response_model.dart';
import 'package:app_health/features/doctor_details/data/models/doctor_reviews_response_model.dart';

abstract class DoctorDetailsState extends Equatable {
  const DoctorDetailsState();

  @override
  List<Object?> get props => [];
}

class DoctorDetailsInitial extends DoctorDetailsState {}

class DoctorDetailsLoadingState extends DoctorDetailsState {}

class DoctorDetailsLoadedState extends DoctorDetailsState {
  final DoctorProfileModel doctor;
  final DoctorReviewsDataModel? reviews;
  final int activeTab; // 0: About Doctor, 1: Reviews
  final bool isFavorite;
  final bool reviewsLoading;
  final String? reviewsError;

  const DoctorDetailsLoadedState({
    required this.doctor,
    this.reviews,
    this.activeTab = 0,
    required this.isFavorite,
    this.reviewsLoading = false,
    this.reviewsError,
  });

  DoctorDetailsLoadedState copyWith({
    DoctorProfileModel? doctor,
    DoctorReviewsDataModel? reviews,
    int? activeTab,
    bool? isFavorite,
    bool? reviewsLoading,
    String? reviewsError,
  }) {
    return DoctorDetailsLoadedState(
      doctor: doctor ?? this.doctor,
      reviews: reviews ?? this.reviews,
      activeTab: activeTab ?? this.activeTab,
      isFavorite: isFavorite ?? this.isFavorite,
      reviewsLoading: reviewsLoading ?? this.reviewsLoading,
      reviewsError: reviewsError ?? this.reviewsError,
    );
  }

  @override
  List<Object?> get props => [
        doctor,
        reviews,
        activeTab,
        isFavorite,
        reviewsLoading,
        reviewsError,
      ];
}

class DoctorDetailsErrorState extends DoctorDetailsState {
  final String errorMessage;
  final bool isLocalizationKey;

  const DoctorDetailsErrorState(
    this.errorMessage, [
    this.isLocalizationKey = false,
  ]);

  @override
  List<Object?> get props => [errorMessage, isLocalizationKey];
}

