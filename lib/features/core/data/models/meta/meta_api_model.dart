class MetaApiModel {
  final int currentPage;
  final int totalPages;
  final int total;
  MetaApiModel({required this.currentPage, required this.totalPages, required this.total});

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
      currentPage:
          (json['page'] as num?)?.toInt() ??
          (json['pageNumber'] as num?)?.toInt() ??
          0,
      totalPages: totalPages,
      total: (json['totalCount'] as num?)?.toInt() ?? 0,
    );
  }
  factory MetaApiModel.emptyOne() {
    return MetaApiModel(currentPage: 0, totalPages: 0,total: 0);
  }
}
