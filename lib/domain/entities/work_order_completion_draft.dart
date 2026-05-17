class TechWorkOrderPart {
  final String id;
  final String name;
  final String? serialNumber;
  final int quantity;

  TechWorkOrderPart({
    required this.id,
    required this.name,
    this.serialNumber,
    required this.quantity,
  });
}

class TechWorkOrderChecklistItem {
  final int id;
  final bool result;
  final String? notes;

  TechWorkOrderChecklistItem({
    required this.id,
    required this.result,
    this.notes,
  });
}

class WorkOrderCompletionDraft {
  final String workOrderId;
  final String mtm;
  final String serialNumber;
  final String diagnosticNotes;
  final List<TechWorkOrderPart> uninstalledParts;
  final List<TechWorkOrderPart> installedParts;
  final List<String> prePhotos;
  final List<String> duringPhotos;
  final List<String> postPhotos;
  final int currentStep;
  final List<Map<String, dynamic>> signaturePoints;
  final List<TechWorkOrderChecklistItem> checklist;

  WorkOrderCompletionDraft({
    required this.workOrderId,
    this.mtm = "",
    this.serialNumber = "",
    this.diagnosticNotes = "",
    this.uninstalledParts = const [],
    this.installedParts = const [],
    this.prePhotos = const [],
    this.duringPhotos = const [],
    this.postPhotos = const [],
    this.currentStep = 0,
    this.signaturePoints = const [],
    this.checklist = const [],
  });
}
