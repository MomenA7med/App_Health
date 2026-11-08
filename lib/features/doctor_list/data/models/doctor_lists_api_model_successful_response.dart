import 'package:app_health/features/core/data/models/meta/meta_api_model.dart';
import 'package:app_health/features/doctor_list/data/models/specialty_doctors_response_model.dart';

class DoctorListsApiModelSuccessfulResponse {
  final List<DoctorModel> doctorList;
  final MetaApiModel metaApiModel;

  DoctorListsApiModelSuccessfulResponse(this.doctorList, this.metaApiModel);

  DoctorListsApiModelSuccessfulResponse.fromJson(Map<String, dynamic> json)
      : doctorList = (json["data"]?["items"] != null)
            ? (json["data"]?["items"] as List<dynamic>).map((item) {
                return DoctorModel.fromJson(item as Map<String, dynamic>);
              }).toList()
            : [],
        metaApiModel = (json["data"] != null)
            ? MetaApiModel.fromJson(json["data"] as Map<String, dynamic>)
            : MetaApiModel.emptyOne();
}

