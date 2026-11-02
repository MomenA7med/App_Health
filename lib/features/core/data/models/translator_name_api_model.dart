class TranslatorNameApiModel {
  String ar;
  String en;

  TranslatorNameApiModel({required this.ar, required this.en});

  factory TranslatorNameApiModel.fromJson(Map<String, dynamic> json) {
    return TranslatorNameApiModel(
      ar: json['ar'] as String? ?? "",
      en: json['en'] as String? ?? "",
    );
  }
}
