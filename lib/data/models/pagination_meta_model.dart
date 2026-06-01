import 'package:zent_fe/domain/entities/pagination_meta.dart';

class PaginationMetaModel extends PaginationMeta {
  PaginationMetaModel({
    required super.limit,
    required super.page,
    required super.totalPages,
    required super.totalRows,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return PaginationMetaModel(
      limit: json['limit'] as int,
      page: json['page'] as int,
      totalPages: json['total_pages'] as int,
      totalRows: json['total_rows'] as int,
    );
  }
}
