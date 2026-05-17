class RefuseWorkOrderRequest {
  final String reason;
  final String explanation;
  final List<String> evidenceImageUrls;

  RefuseWorkOrderRequest({
    required this.reason,
    required this.explanation,
    required this.evidenceImageUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'explanation': explanation,
      'evidenceImageUrls': evidenceImageUrls,
    };
  }
}

class ApproveRefusalRequest {
  final String technicianId;

  ApproveRefusalRequest({required this.technicianId});

  Map<String, dynamic> toJson() {
    return {'technicianId': technicianId};
  }
}
