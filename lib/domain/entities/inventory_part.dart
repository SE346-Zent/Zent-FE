class InventoryPart {
  final String id;
  final String? partCatalogId;
  final String serialNumber;
  final String? productId;
  final int? partConditionId;
  final DateTime? manufacturedDate;
  final DateTime? installationDate;
  final DateTime? removalDate;
  final DateTime? scrappedDate;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  InventoryPart({
    required this.id,
    this.partCatalogId,
    required this.serialNumber,
    this.productId,
    this.partConditionId,
    this.manufacturedDate,
    this.installationDate,
    this.removalDate,
    this.scrappedDate,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}
