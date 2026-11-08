import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/utils/extensions/extension_string.dart';

class DoctorListSendModel {
  final String specialtyId;
  PagingListSendModel pagination;

  String? sortBy;
  String? governorateId;
  String? areaId;
  String? insuranceCompanyId;
  int? doctorType;
  num? minFee;
  num? maxFee;
  int? dateFilter;

  DoctorListSendModel({
    required this.specialtyId,
    required this.pagination,
    this.sortBy,
    this.governorateId,
    this.areaId,
    this.insuranceCompanyId,
    this.doctorType,
    this.minFee,
    this.maxFee,
    this.dateFilter,
  });

  Map<String, dynamic> toMap() {
    return {
      'page': pagination.pageNumber,
      'pageSize': pagination.pageSize,
      if (pagination.searchText.isNotNullOrNotEmpty)
        'search': pagination.searchText,
      if (sortBy != null && sortBy!.isNotEmpty) 'sortBy': sortBy,
      if (governorateId != null && governorateId!.isNotEmpty)
        'governorateId': governorateId,
      if (areaId != null && areaId!.isNotEmpty) 'areaId': areaId,
      if (insuranceCompanyId != null && insuranceCompanyId!.isNotEmpty)
        'insuranceCompanyId': insuranceCompanyId,
      if (doctorType != null && doctorType! != 0) 'doctorType': doctorType,
      if (minFee != null && minFee! > 0) 'minFee': minFee,
      if (maxFee != null && maxFee! < 1000) 'maxFee': maxFee,
      if (dateFilter != null && dateFilter! != 0) 'dateFilter': dateFilter,
    };
  }
}
