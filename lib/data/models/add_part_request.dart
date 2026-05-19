class AddPartRequest {
  final String partNumber;
  final int partTypesId;
  final String serialNumber;
  final String? description;
  final String? modelCode;
  final List<String> photos;

  AddPartRequest({
    required this.partNumber,
    required this.partTypesId,
    required this.serialNumber,
    this.description,
    this.modelCode,
    this.photos = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'partNumber': partNumber,
      'partTypesId': partTypesId,
      'serialNumber': serialNumber,
      'description': description,
      'modelCode': modelCode,
      'photos': photos,
    };
  }
}