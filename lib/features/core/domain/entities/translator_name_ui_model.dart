import 'package:app_health/features/core/data/models/translator_name_api_model.dart';
import 'package:app_health/utils/extensions/extension_string.dart';

class TranslatorNameUiModel {
  String ar;
  String en;

  TranslatorNameUiModel({required this.ar, required this.en});

  factory TranslatorNameUiModel.fromTranslatorNameApiModel(
    TranslatorNameApiModel model,
  ) {
    return TranslatorNameUiModel(ar: model.ar, en: model.en);
  }
  String getName(bool isEnglish) => isEnglish ? en : ar;
  bool get isNotEmptyName => ar.isNotNullOrNotEmpty && en.isNotNullOrNotEmpty;
  bool get isEmptyName => ar.isNullOrEmpty && en.isNullOrEmpty;
}
