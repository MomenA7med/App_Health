abstract class BaseWrapper {
  final bool? isSuccess;
  final String? errors;

  BaseWrapper(this.isSuccess, this.errors);

  BaseWrapper.fromJson(Map<String, dynamic> json)
    : isSuccess =
          json['isSucceded'] != null ? json['isSucceded'] as bool : null,
      errors = json['errors'] != null ? json['errors'] as String? : null;
}
