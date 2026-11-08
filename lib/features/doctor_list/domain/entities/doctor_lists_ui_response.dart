import 'package:app_health/features/core/domain/entities/meta/meta_ui_model.dart';
import 'package:app_health/features/doctor_list/data/models/doctor_lists_api_model_successful_response.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';

class DoctorListsUiResponse {
  final List<DoctorModel> doctorList;
  final MetaUiModel metaUiModel;

  DoctorListsUiResponse(this.doctorList, this.metaUiModel);

  DoctorListsUiResponse.fromApiModel(
      DoctorListsApiModelSuccessfulResponse model)
      : doctorList = model.doctorList,
        metaUiModel = MetaUiModel.fromMetaApiModel(model.metaApiModel);
}

