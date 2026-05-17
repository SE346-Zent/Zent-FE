class ChecklistResultInput {
  final int id;
  final bool result;
  final String? notes;

  ChecklistResultInput({required this.id, required this.result, this.notes});

  Map<String, dynamic> toJson() {
    return {'id': id, 'result': result, if (notes != null) 'notes': notes};
  }
}

class PartChangeInput {
  final String partId;
  final String changeType;

  PartChangeInput({required this.partId, required this.changeType});

  Map<String, dynamic> toJson() {
    return {'partId': partId, 'changeType': changeType};
  }
}

class CompleteWorkOrderRequest {
  final String mtm;
  final String serialNumber;
  final List<PartChangeInput> partChanges;
  final String diagnosis;
  final double latitude;
  final double longitude;
  final String signatureFileName;
  final List<ChecklistResultInput>? checklist;

  CompleteWorkOrderRequest({
    required this.mtm,
    required this.serialNumber,
    required this.partChanges,
    required this.diagnosis,
    required this.latitude,
    required this.longitude,
    required this.signatureFileName,
    this.checklist,
  });

  Map<String, dynamic> toJson() {
    return {
      'mtm': mtm,
      'serialNumber': serialNumber,
      'partChanges': partChanges.map((p) => p.toJson()).toList(),
      'diagnosis': diagnosis,
      'latitude': latitude,
      'longitude': longitude,
      'signatureFileName': signatureFileName,
      if (checklist != null)
        'checklist': checklist!.map((c) => c.toJson()).toList(),
    };
  }
}
