class NotificationPreferenceModel {
  final int categoryId;
  final String categoryName;
  final String categorySlug;
  final bool osEnabled;
  final String? updatedAt;

  NotificationPreferenceModel({
    required this.categoryId,
    required this.categoryName,
    required this.categorySlug,
    required this.osEnabled,
    this.updatedAt,
  });

  factory NotificationPreferenceModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferenceModel(
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      categorySlug: json['categorySlug'] as String,
      osEnabled: json['osEnabled'] as bool,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categorySlug': categorySlug,
      'osEnabled': osEnabled,
      'updatedAt': updatedAt,
    };
  }
}
