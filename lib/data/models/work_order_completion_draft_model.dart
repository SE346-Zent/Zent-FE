import '../../domain/entities/work_order_completion_draft.dart';

class TechWorkOrderPartModel extends TechWorkOrderPart {
  TechWorkOrderPartModel({
    required super.id,
    required super.name,
    super.serialNumber,
    required super.quantity,
  });

  factory TechWorkOrderPartModel.fromEntity(TechWorkOrderPart entity) {
    return TechWorkOrderPartModel(
      id: entity.id,
      name: entity.name,
      serialNumber: entity.serialNumber,
      quantity: entity.quantity,
    );
  }

  factory TechWorkOrderPartModel.fromJson(Map<String, dynamic> json) {
    return TechWorkOrderPartModel(
      id: json['id'] as String,
      name: json['name'] as String,
      serialNumber: json['serialNumber'] as String?,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serialNumber': serialNumber,
      'quantity': quantity,
    };
  }
}

class TechWorkOrderChecklistItemModel extends TechWorkOrderChecklistItem {
  TechWorkOrderChecklistItemModel({
    required super.id,
    required super.result,
    super.notes,
  });

  factory TechWorkOrderChecklistItemModel.fromEntity(
    TechWorkOrderChecklistItem entity,
  ) {
    return TechWorkOrderChecklistItemModel(
      id: entity.id,
      result: entity.result,
      notes: entity.notes,
    );
  }

  factory TechWorkOrderChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return TechWorkOrderChecklistItemModel(
      id: json['id'] as int,
      result: json['result'] as bool,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'result': result, if (notes != null) 'notes': notes};
  }
}

class WorkOrderCompletionDraftModel extends WorkOrderCompletionDraft {
  WorkOrderCompletionDraftModel({
    required super.workOrderId,
    super.mtm,
    super.serialNumber,
    super.diagnosticNotes,
    super.diagnosticNote1,
    super.diagnosticNote2,
    super.diagnosticNote3,
    super.uninstalledParts,
    super.installedParts,
    super.prePhotos,
    super.duringPhotos,
    super.postPhotos,
    super.currentStep,
    super.signaturePoints,
    super.checklist,
  });

  factory WorkOrderCompletionDraftModel.fromEntity(
    WorkOrderCompletionDraft entity,
  ) {
    return WorkOrderCompletionDraftModel(
      workOrderId: entity.workOrderId,
      mtm: entity.mtm,
      serialNumber: entity.serialNumber,
      diagnosticNotes: entity.diagnosticNotes,
      diagnosticNote1: entity.diagnosticNote1,
      diagnosticNote2: entity.diagnosticNote2,
      diagnosticNote3: entity.diagnosticNote3,
      uninstalledParts: entity.uninstalledParts,
      installedParts: entity.installedParts,
      prePhotos: entity.prePhotos,
      duringPhotos: entity.duringPhotos,
      postPhotos: entity.postPhotos,
      currentStep: entity.currentStep,
      signaturePoints: entity.signaturePoints,
      checklist: entity.checklist,
    );
  }

  factory WorkOrderCompletionDraftModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderCompletionDraftModel(
      workOrderId: json['workOrderId'] as String,
      mtm: json['mtm'] as String? ?? "",
      serialNumber: json['serialNumber'] as String? ?? "",
      diagnosticNotes: json['diagnosticNotes'] as String? ?? "",
      diagnosticNote1: json['diagnosticNote1'] as String? ?? "",
      diagnosticNote2: json['diagnosticNote2'] as String? ?? "",
      diagnosticNote3: json['diagnosticNote3'] as String? ?? "",
      uninstalledParts: (json['uninstalledParts'] as List? ?? [])
          .map(
            (e) => TechWorkOrderPartModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      installedParts: (json['installedParts'] as List? ?? [])
          .map(
            (e) => TechWorkOrderPartModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      prePhotos: List<String>.from(json['prePhotos'] as List? ?? []),
      duringPhotos: List<String>.from(json['duringPhotos'] as List? ?? []),
      postPhotos: List<String>.from(json['postPhotos'] as List? ?? []),
      currentStep: json['currentStep'] as int? ?? 0,
      signaturePoints: (json['signaturePoints'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      checklist: (json['checklist'] as List? ?? [])
          .map(
            (e) => TechWorkOrderChecklistItemModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'mtm': mtm,
      'serialNumber': serialNumber,
      'diagnosticNotes': diagnosticNotes,
      'diagnosticNote1': diagnosticNote1,
      'diagnosticNote2': diagnosticNote2,
      'diagnosticNote3': diagnosticNote3,
      'uninstalledParts': uninstalledParts
          .map((e) => TechWorkOrderPartModel.fromEntity(e).toJson())
          .toList(),
      'installedParts': installedParts
          .map((e) => TechWorkOrderPartModel.fromEntity(e).toJson())
          .toList(),
      'prePhotos': prePhotos,
      'duringPhotos': duringPhotos,
      'postPhotos': postPhotos,
      'currentStep': currentStep,
      'signaturePoints': signaturePoints,
      'checklist': checklist
          .map((e) => TechWorkOrderChecklistItemModel.fromEntity(e).toJson())
          .toList(),
    };
  }
}
