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
      categoryId: (json['categoryId'] ?? json['category_id']) as int,
      categoryName: (json['categoryName'] ?? json['category_name'] ?? '') as String,
      categorySlug: (json['categorySlug'] ?? json['category_slug'] ?? '') as String,
      osEnabled: (json['osEnabled'] ?? json['os_enabled'] ?? false) as bool,
      updatedAt: (json['updatedAt'] ?? json['updated_at']) as String?,
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
