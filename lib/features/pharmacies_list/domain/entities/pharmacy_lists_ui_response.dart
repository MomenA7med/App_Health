import 'package:app_health/features/core/domain/entities/meta/meta_ui_model.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_lists_api_model_successful_response.dart';
import 'package:app_health/features/pharmacies_list/data/models/pharmacy_model.dart';

class PharmacyListsUiResponse {
  final List<PharmacyModel> pharmacyList;
  final MetaUiModel metaUiModel;

  PharmacyListsUiResponse(this.pharmacyList, this.metaUiModel);

  PharmacyListsUiResponse.fromApiModel(
      PharmacyListsApiModelSuccessfulResponse model)
      : pharmacyList = model.data.items,
        metaUiModel = MetaUiModel(
          currentPage: model.data.page,
          totalPages: model.data.pageSize > 0
              ? (model.data.totalCount / model.data.pageSize).ceil()
              : 1,
          total: model.data.totalCount,
        );
}

