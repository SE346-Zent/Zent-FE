import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../models/work_order_completion_draft_model.dart';

abstract class WorkOrderLocalDataSource {
  Future<void> cacheWorkOrderDraft(WorkOrderCompletionDraftModel draft);
  Future<WorkOrderCompletionDraftModel?> getWorkOrderDraft(String workOrderId);
  Future<void> clearWorkOrderDraft(String workOrderId);
}

class WorkOrderLocalDataSourceImpl implements WorkOrderLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  WorkOrderLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<void> cacheWorkOrderDraft(WorkOrderCompletionDraftModel draft) async {
    final jsonString = json.encode(draft.toJson());
    final key = await _getKey(draft.workOrderId);
    await sharedPreferences.setString(key, jsonString);
  }

  @override
  Future<WorkOrderCompletionDraftModel?> getWorkOrderDraft(
    String workOrderId,
  ) async {
    final key = await _getKey(workOrderId);
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      return WorkOrderCompletionDraftModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearWorkOrderDraft(String workOrderId) async {
    final key = await _getKey(workOrderId);
    await sharedPreferences.remove(key);
  }

  Future<String> _getKey(String workOrderId) async {
    String userPrefix = 'anonymous';
    try {
      final token = await secureStorage.read(key: 'ACCESS_TOKEN');
      if (token != null && token.isNotEmpty) {
        final payload = JwtDecoder.decode(token);
        final id = payload['id'] ?? payload['sub'] ?? payload['userId'];
        if (id != null) {
          userPrefix = id.toString();
        }
      }
    } catch (_) {}
    return 'WO_DRAFT_${userPrefix}_$workOrderId';
  }
}
