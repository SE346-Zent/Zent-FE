class ApiResponse<T> {
  final dynamic statusCode;
  final dynamic message;
  final T? data;
  final dynamic meta;

  ApiResponse({
    required this.statusCode,
    required this.message,
    this.data,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      statusCode: json['statusCode'],
      message: json['message']?.toString(),
      data:
          ((json['statusCode'] == 1 ||
                  json['statusCode'] == 200 ||
                  json['statusCode'] == 201) &&
              json['data'] != null)
          ? fromJsonT(json['data'])
          : null,
      meta: json['meta'],
    );
  }

  bool get isSuccessful =>
      statusCode == 1 || statusCode == 200 || statusCode == 201;
}
