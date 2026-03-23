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

class WorkOrderCompletionDraftModel extends WorkOrderCompletionDraft {
  WorkOrderCompletionDraftModel({
    required super.workOrderId,
    super.mtm,
    super.serialNumber,
    super.diagnosticNotes,
    super.uninstalledParts,
    super.installedParts,
    super.prePhotos,
    super.duringPhotos,
    super.postPhotos,
  });

  factory WorkOrderCompletionDraftModel.fromEntity(WorkOrderCompletionDraft entity) {
    return WorkOrderCompletionDraftModel(
      workOrderId: entity.workOrderId,
      mtm: entity.mtm,
      serialNumber: entity.serialNumber,
      diagnosticNotes: entity.diagnosticNotes,
      uninstalledParts: entity.uninstalledParts,
      installedParts: entity.installedParts,
      prePhotos: entity.prePhotos,
      duringPhotos: entity.duringPhotos,
      postPhotos: entity.postPhotos,
    );
  }

  factory WorkOrderCompletionDraftModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderCompletionDraftModel(
      workOrderId: json['workOrderId'] as String,
      mtm: json['mtm'] as String? ?? "",
      serialNumber: json['serialNumber'] as String? ?? "",
      diagnosticNotes: json['diagnosticNotes'] as String? ?? "",
      uninstalledParts: (json['uninstalledParts'] as List? ?? [])
          .map((e) => TechWorkOrderPartModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      installedParts: (json['installedParts'] as List? ?? [])
          .map((e) => TechWorkOrderPartModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      prePhotos: List<String>.from(json['prePhotos'] as List? ?? []),
      duringPhotos: List<String>.from(json['duringPhotos'] as List? ?? []),
      postPhotos: List<String>.from(json['postPhotos'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'mtm': mtm,
      'serialNumber': serialNumber,
      'diagnosticNotes': diagnosticNotes,
      'uninstalledParts': uninstalledParts
          .map((e) => TechWorkOrderPartModel.fromEntity(e).toJson())
          .toList(),
      'installedParts': installedParts
          .map((e) => TechWorkOrderPartModel.fromEntity(e).toJson())
          .toList(),
      'prePhotos': prePhotos,
      'duringPhotos': duringPhotos,
      'postPhotos': postPhotos,
    };
  }
}
