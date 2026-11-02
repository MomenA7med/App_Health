class LookupNameApiModel {
  final int id;
  final String name;

  const LookupNameApiModel({required this.id, required this.name});

  factory LookupNameApiModel.fromJson(Map<String, dynamic> json) =>
      LookupNameApiModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? "",
      );
}
