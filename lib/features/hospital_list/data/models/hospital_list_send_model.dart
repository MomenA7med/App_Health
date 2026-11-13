import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/utils/extensions/extension_string.dart';

class HospitalListSendModel {
  PagingListSendModel pagination;

  String? sortBy;
  String? governorateId;
  String? areaId;
  String? specialtyId;
  String? insuranceCompanyId;

  HospitalListSendModel({
    required this.pagination,
    this.sortBy,
    this.governorateId,
    this.areaId,
    this.specialtyId,
    this.insuranceCompanyId,
  });

  Map<String, dynamic> toMap() {
    return {
      'page': pagination.pageNumber,
      'pageSize': pagination.pageSize,
      if (pagination.searchText.isNotNullOrNotEmpty)
        'search': pagination.searchText,
      if (sortBy != null && sortBy!.isNotEmpty)
        'sortBy': sortBy == 'highest_rating' ? 0 : 1,
      if (governorateId != null && governorateId!.isNotEmpty)
        'governorateId': governorateId,
      if (areaId != null && areaId!.isNotEmpty) 'areaId': areaId,
      if (specialtyId != null && specialtyId!.isNotEmpty)
        'specializationId': specialtyId,
      if (insuranceCompanyId != null && insuranceCompanyId!.isNotEmpty)
        'insuranceCompanyId': insuranceCompanyId,
    };
  }
}
