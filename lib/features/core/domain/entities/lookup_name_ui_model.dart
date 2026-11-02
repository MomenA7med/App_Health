import 'package:app_health/features/core/data/models/lookup_name_api_model.dart';

class LookupNameUiModel {
  final int id;
  final String name;

  const LookupNameUiModel({required this.id, required this.name});

  factory LookupNameUiModel.fromLookupNameApiModel(LookupNameApiModel model) =>
      LookupNameUiModel(id: model.id, name: model.name);
}
