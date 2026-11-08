import 'package:app_health/features/core/data/models/meta/meta_api_model.dart';

class MetaUiModel {
  final int currentPage;
  final int totalPages;
  final int total;

  MetaUiModel({this.currentPage = 0, this.totalPages = 0, this.total = 0});

  factory MetaUiModel.fromMetaApiModel(MetaApiModel model) {
    return MetaUiModel(
      currentPage: model.currentPage,
      totalPages: model.totalPages,
      total: model.total,
    );
  }
  factory MetaUiModel.emptyOne() {
    return MetaUiModel(currentPage: 0, totalPages: 0, total: 0);
  }

  bool get hasNext => currentPage < totalPages;

  bool get hasPrevious => currentPage > 1;
}
