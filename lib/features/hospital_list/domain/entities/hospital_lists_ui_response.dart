import 'package:app_health/features/core/domain/entities/meta/meta_ui_model.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_lists_api_model_successful_response.dart';
import 'package:app_health/features/hospital_list/data/models/hospital_model.dart';

class HospitalListsUiResponse {
  final List<HospitalModel> hospitalList;
  final MetaUiModel metaUiModel;

  HospitalListsUiResponse(this.hospitalList, this.metaUiModel);

  HospitalListsUiResponse.fromApiModel(
      HospitalListsApiModelSuccessfulResponse model)
      : hospitalList = model.data.items,
        metaUiModel = MetaUiModel(
          currentPage: model.data.page,
          totalPages: model.data.pageSize > 0
              ? (model.data.totalCount / model.data.pageSize).ceil()
              : 1,
          total: model.data.totalCount,
        );
}

