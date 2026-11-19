import 'package:app_health/features/core/data/models/meta/paging_send_model.dart';
import 'package:app_health/utils/extensions/extension_string.dart';

class PharmacyListSendModel {
  PagingListSendModel pagination;

  String? sortBy;
  int? locationStrategy;
  String? governorateId;
  String? areaId;
  int? workingHoursFilter;
  String? insuranceCompanyId;

  PharmacyListSendModel({
    required this.pagination,
    this.sortBy,
    this.locationStrategy,
    this.governorateId,
    this.areaId,
    this.workingHoursFilter,
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
      if (locationStrategy != null)
        'locationStrategy': locationStrategy,
      if (governorateId != null && governorateId!.isNotEmpty)
        'governorateId': governorateId,
      if (areaId != null && areaId!.isNotEmpty)
        'areaId': areaId,
      if (workingHoursFilter != null && workingHoursFilter! > 0)
        'workingHoursFilter': workingHoursFilter,
      if (insuranceCompanyId != null && insuranceCompanyId!.isNotEmpty)
        'insuranceCompanyId': insuranceCompanyId,
    };
  }
}

