import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/work_order_completion_draft_model.dart';

abstract class WorkOrderLocalDataSource {
  Future<void> cacheWorkOrderDraft(WorkOrderCompletionDraftModel draft);
  Future<WorkOrderCompletionDraftModel?> getWorkOrderDraft(String workOrderId);
}

class WorkOrderLocalDataSourceImpl implements WorkOrderLocalDataSource {
  final SharedPreferences sharedPreferences;

  WorkOrderLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheWorkOrderDraft(WorkOrderCompletionDraftModel draft) async {
    final jsonString = json.encode(draft.toJson());
    await sharedPreferences.setString(_getKey(draft.workOrderId), jsonString);
  }

  @override
  Future<WorkOrderCompletionDraftModel?> getWorkOrderDraft(String workOrderId) async {
    final jsonString = sharedPreferences.getString(_getKey(workOrderId));
    if (jsonString != null) {
      return WorkOrderCompletionDraftModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  String _getKey(String workOrderId) => 'WO_DRAFT_$workOrderId';
}
