import 'package:zent_fe/domain/entities/part_catalog_entry.dart';

class PartCatalogEntryModel extends PartCatalogEntry {
  PartCatalogEntryModel({
    required super.id,
    required super.partNumber,
    super.partTypesId,
    super.mfgNumber,
    super.description,
    super.partMfgStatus,
    required super.createdAt,
    required super.updatedAt,
  });

  /// SCM returns PascalCase JSON keys. PartMfgStatus is Int32 from API.
  factory PartCatalogEntryModel.fromJson(Map<String, dynamic> json) {
    // PartMfgStatus is Int32 from SCM API (e.g., 1), convert to String
    final rawStatus = json['PartMfgStatus'] ?? json['part_mfg_status'];
    final partMfgStatus = rawStatus?.toString();

    return PartCatalogEntryModel(
      id: json['ID'] as String? ?? json['id'] as String,
      partNumber:
          json['PartNumber'] as String? ?? json['part_number'] as String,
      partTypesId: json['PartTypesID'] as int? ?? json['part_types_id'] as int?,
      mfgNumber: json['MfgNumber'] as String? ?? json['mfg_number'] as String?,
      description:
          json['Description'] as String? ?? json['description'] as String?,
      partMfgStatus: partMfgStatus,
      createdAt: DateTime.parse(
        (json['CreatedAt'] as String?) ?? (json['created_at'] as String),
      ),
      updatedAt: DateTime.parse(
        (json['UpdatedAt'] as String?) ?? (json['updated_at'] as String),
      ),
    );
  }
}
