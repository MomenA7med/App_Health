import 'package:equatable/equatable.dart';

enum DoctorSortOption {
  nearest,
  highestRated,
  priceLowToHigh,
  priceHighToLow;

  @override
  String toString() {
    switch (this) {
      case DoctorSortOption.nearest:
        return 'nearest';
      case DoctorSortOption.highestRated:
        return 'highest_rating';
      case DoctorSortOption.priceLowToHigh:
        return 'price_asc';
      case DoctorSortOption.priceHighToLow:
        return 'price_desc';
    }
  }
}

class DoctorFilterModel extends Equatable {
  final String? governorate;
  final String? governorateId;
  final String? area;
  final String? areaId;
  final String? locationMode; // 'area' or 'saved'
  final int? gender; // 0: 'all', 1: 'male', 2: 'female'
  final double? minPrice;
  final double? maxPrice;
  final String? consultationDate; // 'any', 'today', 'tomorrow'
  final String? insuranceCompany;
  final String? insuranceCompanyId;
  final String? searchQuery;

  const DoctorFilterModel({
    this.governorate,
    this.governorateId,
    this.area,
    this.areaId,
    this.locationMode = 'area',
    this.gender = 0,
    this.minPrice,
    this.maxPrice,
    this.consultationDate = 'any',
    this.insuranceCompany,
    this.insuranceCompanyId,
    this.searchQuery,
  });

  DoctorFilterModel copyWith({
    String? governorate,
    String? governorateId,
    String? area,
    String? areaId,
    String? locationMode,
    int? gender,
    double? minPrice,
    double? maxPrice,
    String? consultationDate,
    String? insuranceCompany,
    String? insuranceCompanyId,
    String? searchQuery,
  }) {
    return DoctorFilterModel(
      governorate: governorate ?? this.governorate,
      governorateId: governorateId ?? this.governorateId,
      area: area ?? this.area,
      areaId: areaId ?? this.areaId,
      locationMode: locationMode ?? this.locationMode,
      gender: gender ?? this.gender,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      consultationDate: consultationDate ?? this.consultationDate,
      insuranceCompany: insuranceCompany ?? this.insuranceCompany,
      insuranceCompanyId: insuranceCompanyId ?? this.insuranceCompanyId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasActiveFilters {
    return (area != null && area!.isNotEmpty && area != 'all') ||
        (governorate != null &&
            governorate!.isNotEmpty &&
            governorate != 'all') ||
        (gender != null && gender != 0) ||
        (minPrice != null && minPrice! > 0) ||
        (maxPrice != null && maxPrice! < 1000) ||
        (consultationDate != null && consultationDate != 'any') ||
        (insuranceCompany != null && insuranceCompany!.isNotEmpty);
  }

  static const DoctorFilterModel initial = DoctorFilterModel(
    governorate: null,
    governorateId: null,
    area: null,
    areaId: null,
    locationMode: 'area',
    gender: 0,
    minPrice: 0,
    maxPrice: 1000,
    consultationDate: 'any',
    insuranceCompany: null,
    insuranceCompanyId: null,
  );

  @override
  List<Object?> get props => [
        governorate,
        governorateId,
        area,
        areaId,
        locationMode,
        gender,
        minPrice,
        maxPrice,
        consultationDate,
        insuranceCompany,
        insuranceCompanyId,
        searchQuery,
      ];
}

