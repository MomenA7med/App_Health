import 'package:equatable/equatable.dart';

enum DoctorSortOption {
  nearest,
  highestRated,
  priceLowToHigh,
  priceHighToLow,
}

class DoctorFilterModel extends Equatable {
  final String? governorate;
  final String? area;
  final String? gender; // 'all', 'male', 'female'
  final double? minPrice;
  final double? maxPrice;
  final String? consultationDate; // 'any', 'today', 'tomorrow'
  final String? insuranceCompany;
  final String? searchQuery;

  const DoctorFilterModel({
    this.governorate,
    this.area,
    this.gender = 'all',
    this.minPrice,
    this.maxPrice,
    this.consultationDate = 'any',
    this.insuranceCompany,
    this.searchQuery,
  });

  DoctorFilterModel copyWith({
    String? governorate,
    String? area,
    String? gender,
    double? minPrice,
    double? maxPrice,
    String? consultationDate,
    String? insuranceCompany,
    String? searchQuery,
  }) {
    return DoctorFilterModel(
      governorate: governorate ?? this.governorate,
      area: area ?? this.area,
      gender: gender ?? this.gender,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      consultationDate: consultationDate ?? this.consultationDate,
      insuranceCompany: insuranceCompany ?? this.insuranceCompany,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasActiveFilters {
    return (area != null && area!.isNotEmpty && area != 'all') ||
        (governorate != null && governorate!.isNotEmpty && governorate != 'all') ||
        (gender != null && gender != 'all') ||
        (minPrice != null && minPrice! > 100) ||
        (maxPrice != null && maxPrice! < 1000) ||
        (consultationDate != null && consultationDate != 'any') ||
        (insuranceCompany != null && insuranceCompany!.isNotEmpty);
  }

  static const DoctorFilterModel initial = DoctorFilterModel(
    governorate: null,
    area: null,
    gender: 'all',
    minPrice: 100,
    maxPrice: 1000,
    consultationDate: 'any',
    insuranceCompany: null,
  );

  @override
  List<Object?> get props => [
        governorate,
        area,
        gender,
        minPrice,
        maxPrice,
        consultationDate,
        insuranceCompany,
        searchQuery,
      ];
}

