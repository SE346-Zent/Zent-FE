import 'package:zent_fe/domain/entities/inventory_part.dart';

class InventoryPartModel extends InventoryPart {
  InventoryPartModel({
    required super.id,
    super.partCatalogId,
    required super.serialNumber,
    super.productId,
    super.partConditionId,
    super.manufacturedDate,
    super.installationDate,
    super.removalDate,
    super.scrappedDate,
    required super.createdAt,
    required super.updatedAt,
  });

  /// SCM returns PascalCase JSON keys: ID, PartCatalogID, SerialNumber, etc.
  factory InventoryPartModel.fromJson(Map<String, dynamic> json) {
    return InventoryPartModel(
      id: json['ID'] as String? ?? json['id'] as String,
      partCatalogId:
          json['PartCatalogID'] as String? ??
          json['part_catalog_id'] as String?,
      serialNumber:
          json['SerialNumber'] as String? ?? json['serial_number'] as String,
      productId: json['ProductID'] as String? ?? json['product_id'] as String?,
      partConditionId:
          json['PartConditionID'] as int? ?? json['part_condition_id'] as int?,
      manufacturedDate: _parseDate(
        json['ManufacturedDate'] as String?,
        fallback: json['manufactured_date'] as String?,
      ),
      installationDate: _parseDate(
        json['InstallationDate'] as String?,
        fallback: json['installation_date'] as String?,
      ),
      removalDate: _parseDate(
        json['RemovalDate'] as String?,
        fallback: json['removal_date'] as String?,
      ),
      scrappedDate: _parseDate(
        json['ScrappedDate'] as String?,
        fallback: json['scrapped_date'] as String?,
      ),
      createdAt: DateTime.parse(
        (json['CreatedAt'] as String?) ?? (json['created_at'] as String),
      ),
      updatedAt: DateTime.parse(
        (json['UpdatedAt'] as String?) ?? (json['updated_at'] as String),
      ),
    );
  }

  static DateTime? _parseDate(String? primary, {String? fallback}) {
    final value = primary ?? fallback;
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}
