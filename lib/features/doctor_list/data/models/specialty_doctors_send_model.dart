import 'package:equatable/equatable.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_filter_model.dart';

class SpecialtyDoctorsSendModel extends Equatable {
  final String specialtyId;
  final String? search;
  final String? sortBy;
  final String? location;
  final String? area;
  final int? doctorType;
  final num? minFee;
  final num? maxFee;
  final String? dateFilter;
  final int page;
  final int pageSize;

  const SpecialtyDoctorsSendModel({
    required this.specialtyId,
    this.search,
    this.sortBy,
    this.location,
    this.area,
    this.doctorType,
    this.minFee,
    this.maxFee,
    this.dateFilter,
    this.page = 1,
    this.pageSize = 20,
  });

  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> query = {};
    if (search != null && search!.trim().isNotEmpty) {
      query['search'] = search!.trim();
    }
    if (sortBy != null && sortBy!.trim().isNotEmpty) {
      query['sortBy'] = sortBy!.trim();
    }
    if (location != null && location!.trim().isNotEmpty) {
      query['location'] = location!.trim();
    }
    if (area != null && area!.trim().isNotEmpty) {
      query['area'] = area!.trim();
    }
    if (doctorType != null && doctorType != 0) {
      query['doctorType'] = doctorType!;
    }
    if (minFee != null) {
      query['minFee'] = minFee;
    }
    if (maxFee != null) {
      query['maxFee'] = maxFee;
    }
    if (dateFilter != null && dateFilter!.trim().isNotEmpty) {
      query['dateFilter'] = dateFilter!.trim();
    }
    query['page'] = page;
    query['pageSize'] = pageSize;
    return query;
  }

  Map<String, dynamic> toJson() => toQueryParameters();

  SpecialtyDoctorsSendModel copyWith({
    String? specialtyId,
    String? search,
    String? sortBy,
    String? location,
    String? area,
    int? doctorType,
    num? minFee,
    num? maxFee,
    String? dateFilter,
    int? page,
    int? pageSize,
  }) {
    return SpecialtyDoctorsSendModel(
      specialtyId: specialtyId ?? this.specialtyId,
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      location: location ?? this.location,
      area: area ?? this.area,
      doctorType: doctorType ?? this.doctorType,
      minFee: minFee ?? this.minFee,
      maxFee: maxFee ?? this.maxFee,
      dateFilter: dateFilter ?? this.dateFilter,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  factory SpecialtyDoctorsSendModel.fromFilter({
    required String specialtyId,
    String? search,
    DoctorSortOption? sortOption,
    DoctorFilterModel? filter,
    int page = 1,
    int pageSize = 20,
  }) {
    String? sortBy;
    if (sortOption != null) {
      switch (sortOption) {
        case DoctorSortOption.nearest:
          sortBy = 'nearest';
          break;
        case DoctorSortOption.highestRated:
          sortBy = 'highestRated';
          break;
        case DoctorSortOption.priceLowToHigh:
          sortBy = 'priceLowToHigh';
          break;
        case DoctorSortOption.priceHighToLow:
          sortBy = 'priceHighToLow';
          break;
      }
    }

    int? doctorType;
    if (filter?.gender != null && filter!.gender != 0) {
      doctorType = filter.gender;
    }

    String? dateFilter;
    if (filter?.consultationDate != null && filter!.consultationDate != 'any') {
      dateFilter = filter.consultationDate;
    }

    return SpecialtyDoctorsSendModel(
      specialtyId: specialtyId,
      search: search,
      sortBy: sortBy,
      location: (filter?.governorate != null && filter!.governorate != 'all')
          ? filter.governorate
          : null,
      area: (filter?.area != null && filter!.area != 'all')
          ? filter.area
          : null,
      doctorType: doctorType,
      minFee: filter?.minPrice,
      maxFee: filter?.maxPrice,
      dateFilter: dateFilter,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  List<Object?> get props => [
    specialtyId,
    search,
    sortBy,
    location,
    area,
    doctorType,
    minFee,
    maxFee,
    dateFilter,
    page,
    pageSize,
  ];
}
