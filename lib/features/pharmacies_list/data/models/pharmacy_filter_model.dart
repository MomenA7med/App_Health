import 'package:equatable/equatable.dart';

enum PharmacySortOption {
  nearest,
  highestRated;

  @override
  String toString() {
    switch (this) {
      case PharmacySortOption.nearest:
        return 'nearest';
      case PharmacySortOption.highestRated:
        return 'highest_rating';
    }
  }

  int get apiValue {
    switch (this) {
      case PharmacySortOption.nearest:
        return 1;
      case PharmacySortOption.highestRated:
        return 0;
    }
  }
}

enum PharmacyWorkingHoursFilter {
  all,
  openNow,
  twentyFourHours;

  int? get apiValue {
    switch (this) {
      case PharmacyWorkingHoursFilter.all:
        return null;
      case PharmacyWorkingHoursFilter.openNow:
        return 1;
      case PharmacyWorkingHoursFilter.twentyFourHours:
        return 2;
    }
  }
}

class PharmacyFilterModel extends Equatable {
  final String? governorate;
  final String? governorateId;
  final String? area;
  final String? areaId;
  final String? locationMode; // 'area' or 'saved'
  final int? locationStrategy;
  final int? workingHoursFilter; // 1: Open Now, 2: 24 Hours
  final String? workingHoursLabel;
  final String? insuranceCompany;
  final String? insuranceCompanyId;
  final String? searchQuery;

  const PharmacyFilterModel({
    this.governorate,
    this.governorateId,
    this.area,
    this.areaId,
    this.locationMode = 'area',
    this.locationStrategy,
    this.workingHoursFilter,
    this.workingHoursLabel,
    this.insuranceCompany,
    this.insuranceCompanyId,
    this.searchQuery,
  });

  PharmacyFilterModel copyWith({
    String? governorate,
    String? governorateId,
    String? area,
    String? areaId,
    String? locationMode,
    int? locationStrategy,
    int? workingHoursFilter,
    String? workingHoursLabel,
    String? insuranceCompany,
    String? insuranceCompanyId,
    String? searchQuery,
    bool clearGovernorate = false,
    bool clearArea = false,
    bool clearWorkingHours = false,
    bool clearInsurance = false,
  }) {
    return PharmacyFilterModel(
      governorate: clearGovernorate ? null : (governorate ?? this.governorate),
      governorateId:
          clearGovernorate ? null : (governorateId ?? this.governorateId),
      area: clearArea ? null : (area ?? this.area),
      areaId: clearArea ? null : (areaId ?? this.areaId),
      locationMode: locationMode ?? this.locationMode,
      locationStrategy: locationStrategy ?? this.locationStrategy,
      workingHoursFilter: clearWorkingHours
          ? null
          : (workingHoursFilter ?? this.workingHoursFilter),
      workingHoursLabel: clearWorkingHours
          ? null
          : (workingHoursLabel ?? this.workingHoursLabel),
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
        (workingHoursFilter != null && workingHoursFilter! > 0) ||
        (insuranceCompanyId != null && insuranceCompanyId!.isNotEmpty);
  }

  int get activeFiltersCount {
    int count = 0;
    if (governorate != null && governorate!.isNotEmpty) count++;
    if (area != null && area!.isNotEmpty) count++;
    if (workingHoursFilter != null && workingHoursFilter! > 0) count++;
    if (insuranceCompanyId != null && insuranceCompanyId!.isNotEmpty) count++;
    return count;
  }

  static const initial = PharmacyFilterModel();

  @override
  List<Object?> get props => [
        governorate,
        governorateId,
        area,
        areaId,
        locationMode,
        locationStrategy,
        workingHoursFilter,
        workingHoursLabel,
        insuranceCompany,
        insuranceCompanyId,
        searchQuery,
      ];
}

