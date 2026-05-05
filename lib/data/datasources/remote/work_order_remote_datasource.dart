import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../models/api_response.dart';
import '../../models/work_order_model.dart';
import '../../models/create_work_order_request.dart';
import '../local/auth_local_datasource.dart';

abstract class WorkOrderRemoteDataSource {
  Future<WorkOrderModel> getSingleWorkOrder(String id);
  Future<List<WorkOrderModel>> getManyWorkOrders(String userId);
  Future<void> createWorkOrder(CreateWorkOrderRequest request);
  Future<List<WorkOrderModel>> getActiveRepairs(String customerId);
}

class WorkOrderRemoteDataSourceImpl implements WorkOrderRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  static final String _baseURL = dotenv.get(
    "BASE_URL",
    fallback: "http://localhost:3000/api",
  );

  static final Duration _timeOut = Duration(
    seconds: int.tryParse(dotenv.get("TIMEOUT_SECONDS", fallback: "20")) ?? 20,
  );

  WorkOrderRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  Future<Map<String, String>> _getHeaders() async {
    final token = await authLocalDataSource.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<WorkOrderModel> getSingleWorkOrder(String id) async {
    final url = Uri.parse('$_baseURL/work_order/single_wo?Id=$id');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers).timeout(_timeOut);

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<WorkOrderModel>.fromJson(
        jsonMap,
        (data) => WorkOrderModel.fromJson(data),
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(
          apiResponse.message ?? 'Failed to fetch single work order',
        );
      }
    } catch (e) {
      throw Exception('Error fetching single work order: $e');
    }
  }

  @override
  Future<List<WorkOrderModel>> getManyWorkOrders(String userId) async {
    final url = Uri.parse('$_baseURL/work_order/many_wo?userId=$userId');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers).timeout(_timeOut);

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<List<WorkOrderModel>>.fromJson(jsonMap, (
        data,
      ) {
        if (data is List) {
          return data.map((e) => WorkOrderModel.fromJson(e)).toList();
        }
        return [];
      });

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to fetch work orders');
      }
    } catch (e) {
      throw Exception('Error fetching many work orders: $e');
    }
  }

  @override
  Future<void> createWorkOrder(CreateWorkOrderRequest request) async {
    // New endpoint from image
    // Note: BASE_URL already includes /v1
    final url = Uri.parse('$_baseURL/work_orders');
    try {
      final headers = await _getHeaders();
      headers['X-Idempotency-Key'] = const Uuid().v4();
      final body = jsonEncode(request.toJson());

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);

      // Handle non-success status codes first
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Status ${response.statusCode}: ${response.body}',
        );
      }

      if (response.body.isEmpty) {
        return;
      }

      try {
        final jsonMap = jsonDecode(response.body);
        final apiResponse = ApiResponse<void>.fromJson(jsonMap, (_) {});

        if (!apiResponse.isSuccessful) {
          throw Exception(apiResponse.message ?? 'Failed to create work order');
        }
      } catch (e) {
        // If we can't parse JSON but status is success, we might be okay
        debugPrint('Warning: Could not parse response JSON: $e');
      }
    } catch (e) {
      throw Exception('Error creating work order: $e');
    }
  }

  @override
  Future<List<WorkOrderModel>> getActiveRepairs(String customerId) async {
    final url = Uri.parse('$_baseURL/work_order/active?customerId=$customerId');
    try {
      final headers = await _getHeaders();
      final response = await client.get(url, headers: headers).timeout(_timeOut);

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<List<WorkOrderModel>>.fromJson(jsonMap, (
        data,
      ) {
        if (data is List) {
          return data.map((e) => WorkOrderModel.fromJson(e)).toList();
        }
        return [];
      });

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to fetch active repairs');
      }
    } catch (e) {
      throw Exception('Error fetching active repairs: $e');
    }
  }
}
