class DoctorReviewsResponseModel {
  final bool success;
  final String code;
  final String message;
  final DoctorReviewsDataModel data;

  const DoctorReviewsResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory DoctorReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorReviewsResponseModel(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: DoctorReviewsDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'code': code,
        'message': message,
        'data': data.toJson(),
      };
}

class DoctorReviewsDataModel {
  final double ratingAverage;
  final int totalReviews;
  final List<ReviewBreakdownModel> breakdown;
  final List<DoctorReviewModel> items;
  final int page;
  final int pageSize;
  final int totalCount;

  const DoctorReviewsDataModel({
    required this.ratingAverage,
    required this.totalReviews,
    this.breakdown = const [],
    this.items = const [],
    this.page = 1,
    this.pageSize = 20,
    this.totalCount = 0,
  });

  factory DoctorReviewsDataModel.fromJson(Map<String, dynamic> json) {
    return DoctorReviewsDataModel(
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      breakdown: (json['breakdown'] as List<dynamic>?)
              ?.map(
                  (e) => ReviewBreakdownModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => DoctorReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'ratingAverage': ratingAverage,
        'totalReviews': totalReviews,
        'breakdown': breakdown.map((e) => e.toJson()).toList(),
        'items': items.map((e) => e.toJson()).toList(),
        'page': page,
        'pageSize': pageSize,
        'totalCount': totalCount,
      };
}

class ReviewBreakdownModel {
  final int rating;
  final int count;

  const ReviewBreakdownModel({
    required this.rating,
    required this.count,
  });

  factory ReviewBreakdownModel.fromJson(Map<String, dynamic> json) {
    return ReviewBreakdownModel(
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'count': count,
      };
}

class DoctorReviewModel {
  final String id;
  final String patientName;
  final int rating;
  final String comment;
  final String createdAt;

  const DoctorReviewModel({
    required this.id,
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory DoctorReviewModel.fromJson(Map<String, dynamic> json) {
    return DoctorReviewModel(
      id: json['id'] as String? ?? '',
      patientName: json['patientName'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientName': patientName,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt,
      };

  String get formattedTimeAgo {
    try {
      final parsed = DateTime.parse(createdAt);
      final difference = DateTime.now().difference(parsed);
      if (difference.inDays >= 30) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? 'منذ شهر' : 'منذ $months أشهر';
      } else if (difference.inDays >= 7) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? 'منذ أسبوع' : 'منذ $weeks أسابيع';
      } else if (difference.inDays >= 1) {
        return difference.inDays == 1 ? 'منذ يوم' : 'منذ ${difference.inDays} أيام';
      } else if (difference.inHours >= 1) {
        return 'منذ ${difference.inHours} ساعة';
      } else {
        return 'الآن';
      }
    } catch (_) {
      return '';
    }
  }
}

