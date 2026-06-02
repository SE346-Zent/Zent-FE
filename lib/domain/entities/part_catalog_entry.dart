class PartCatalogEntry {
  final String id;
  final String partNumber;
  final int? partTypesId;
  final String? mfgNumber;
  final String? description;
  final String? partMfgStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  PartCatalogEntry({
    required this.id,
    required this.partNumber,
    this.partTypesId,
    this.mfgNumber,
    this.description,
    this.partMfgStatus,
    required this.createdAt,
    required this.updatedAt,
  });
}
