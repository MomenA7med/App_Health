import 'package:equatable/equatable.dart';

enum HospitalSortOption {
  nearest,
  highestRated;

  @override
  String toString() {
    switch (this) {
      case HospitalSortOption.nearest:
        return 'nearest';
      case HospitalSortOption.highestRated:
        return 'highest_rating';
    }
  }
}

class HospitalFilterModel extends Equatable {
  final String? governorate;
  final String? governorateId;
  final String? area;
  final String? areaId;
  final String? locationMode; // 'area' or 'saved'
  final String? specialty;
  final String? specialtyId;
  final String? insuranceCompany;
  final String? insuranceCompanyId;
  final String? searchQuery;

  const HospitalFilterModel({
    this.governorate,
    this.governorateId,
    this.area,
    this.areaId,
    this.locationMode = 'area',
    this.specialty,
    this.specialtyId,
    this.insuranceCompany,
    this.insuranceCompanyId,
    this.searchQuery,
  });

  HospitalFilterModel copyWith({
    String? governorate,
    String? governorateId,
    String? area,
    String? areaId,
    String? locationMode,
    String? specialty,
    String? specialtyId,
    String? insuranceCompany,
    String? insuranceCompanyId,
    String? searchQuery,
    bool clearGovernorate = false,
    bool clearArea = false,
    bool clearSpecialty = false,
    bool clearInsurance = false,
  }) {
    return HospitalFilterModel(
      governorate: clearGovernorate ? null : (governorate ?? this.governorate),
      governorateId:
          clearGovernorate ? null : (governorateId ?? this.governorateId),
      area: clearArea ? null : (area ?? this.area),
      areaId: clearArea ? null : (areaId ?? this.areaId),
      locationMode: locationMode ?? this.locationMode,
      specialty: clearSpecialty ? null : (specialty ?? this.specialty),
      specialtyId:
          clearSpecialty ? null : (specialtyId ?? this.specialtyId),
      insuranceCompany:
          clearInsurance ? null : (insuranceCompany ?? this.insuranceCompany),
      insuranceCompanyId: clearInsurance
          ? null
          : (insuranceCompanyId ?? this.insuranceCompanyId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasActiveFilters {
    return (governorate != null && governorate!.isNotEmpty) ||
        (area != null && area!.isNotEmpty) ||
        (specialtyId != null && specialtyId!.isNotEmpty) ||
        (insuranceCompanyId != null && insuranceCompanyId!.isNotEmpty);
  }

  int get activeFiltersCount {
    int count = 0;
    if (governorate != null && governorate!.isNotEmpty) count++;
    if (area != null && area!.isNotEmpty) count++;
    if (specialtyId != null && specialtyId!.isNotEmpty) count++;
    if (insuranceCompanyId != null && insuranceCompanyId!.isNotEmpty) count++;
    return count;
  }

  static const initial = HospitalFilterModel();

  @override
  List<Object?> get props => [
        governorate,
        governorateId,
        area,
        areaId,
        locationMode,
        specialty,
        specialtyId,
        insuranceCompany,
        insuranceCompanyId,
        searchQuery,
      ];
}

