class MetaApiModel {
  final int currentPage;
  final int totalPages;
  MetaApiModel({required this.currentPage, required this.totalPages});

  factory MetaApiModel.fromJson(Map<String, dynamic> json) {
    int totalPages = 0;
    if (json['totalCount'] != null &&
        json['pageSize'] != null &&
        json['pageSize'] != 0) {
      totalPages = (json['totalCount'] as int) ~/ (json['pageSize'] as int);
      if ((json['totalCount'] as int) % (json['pageSize'] as int) != 0) {
        totalPages += 1;
      }
    }
    return MetaApiModel(
      currentPage: json['pageNumber'] as int? ?? 0,
      totalPages: totalPages,
    );
  }
  factory MetaApiModel.emptyOne() {
    return MetaApiModel(currentPage: 0, totalPages: 0);
  }
}
