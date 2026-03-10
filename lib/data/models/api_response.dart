class ApiResponse<T> {
  final dynamic statusCode;
  final dynamic message;
  final T? data;

  ApiResponse({required this.statusCode, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      statusCode: json['statusCode'],
      message: json['message'] as String?,
      data:
          ((json['statusCode'] == 1 || json['statusCode'] == 200) &&
              json['data'] != null)
          ? fromJsonT(json['data'])
          : null,
    );
  }

  bool get isSuccessful => statusCode == 1 || statusCode == 200;
}
