import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../models/api_response.dart';
import '../../models/work_order_model.dart';
import '../../models/create_work_order_request.dart';
import '../../models/complete_work_order_request.dart';
import '../../models/refuse_work_order_request.dart';
import '../local/auth_local_datasource.dart';

abstract class WorkOrderRemoteDataSource {
  Future<List<WorkOrderModel>> getWorkOrders({
    int page = 1,
    int limit = 20,
    String? role,
    String? province,
    String? technicianId,
  });
  Future<WorkOrderModel> getWorkOrderDetail(String id);
  Future<void> createWorkOrder(CreateWorkOrderRequest request);
  Future<void> completeWorkOrder(String id, CompleteWorkOrderRequest request);
  Future<void> refuseWorkOrder(String id, RefuseWorkOrderRequest request);
  Future<void> approveRefusal(String id, ApproveRefusalRequest request);
  Future<void> denyRefusal(String id);
  Future<List<WorkOrderModel>> getActiveRepairs(String customerId);
}

class WorkOrderRemoteDataSourceImpl implements WorkOrderRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  // The BASE_URL should be something like http://.../api/v1
  static final String _baseURL = dotenv.get(
    "BASE_URL",
    fallback: "http://localhost:3000/api/v1",
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
  Future<List<WorkOrderModel>> getWorkOrders({
    int page = 1,
    int limit = 20,
    String? role,
    String? province,
    String? technicianId,
  }) async {
    final queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
      ?role: role,
      ?province: province,
      'technician_id': technicianId,
    };

    final url = Uri.parse(
      '$_baseURL/work_orders',
    ).replace(queryParameters: queryParameters);

    try {
      final headers = await _getHeaders();
      final response = await client
          .get(url, headers: headers)
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        jsonMap,
        (data) => data as List<dynamic>,
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!
            .map(
              (item) => WorkOrderModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(apiResponse.message ?? 'Failed to fetch work orders');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error fetching work orders: $e');
    }
  }

  @override
  Future<WorkOrderModel> getWorkOrderDetail(String id) async {
    final url = Uri.parse('$_baseURL/work_orders/$id');

    try {
      final headers = await _getHeaders();
      final response = await client
          .get(url, headers: headers)
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<WorkOrderModel>.fromJson(
        jsonMap,
        (data) => WorkOrderModel.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(
          apiResponse.message ?? 'Failed to fetch work order detail',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error fetching single work order: $e');
    }
  }

  @override
  Future<void> createWorkOrder(CreateWorkOrderRequest request) async {
    final url = Uri.parse('$_baseURL/work_orders');
    try {
      final headers = await _getHeaders();
      headers['X-Idempotency-Key'] = const Uuid().v4();

      // Transform UUIDs to hex strings (no dashes) as backend uses BINARY(16)
      final Map<String, dynamic> bodyMap = request.toJson();
      if (bodyMap['product_id'] != null) {
        bodyMap['product_id'] = bodyMap['product_id'].toString().replaceAll(
          '-',
          '',
        );
      }
      if (bodyMap['reference_ticket_id'] != null) {
        bodyMap['reference_ticket_id'] = bodyMap['reference_ticket_id']
            .toString()
            .replaceAll('-', '');
      }

      final body = jsonEncode(bodyMap);

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleErrorResponse(response);
      }

      if (response.body.isEmpty) return;

      try {
        final jsonMap = jsonDecode(response.body);
        final apiResponse = ApiResponse<void>.fromJson(jsonMap, (_) {});

        if (!apiResponse.isSuccessful) {
          throw Exception(apiResponse.message ?? 'Failed to create work order');
        }
      } catch (e) {
        debugPrint('Warning: Could not parse response JSON: $e');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error creating work order: $e');
    }
  }

  @override
  Future<void> completeWorkOrder(
    String id,
    CompleteWorkOrderRequest request,
  ) async {
    // Path: /api/v1/work_orders/{id}/complete
    final url = Uri.parse('$_baseURL/work_orders/$id/complete');
    try {
      final headers = await _getHeaders();
      final body = jsonEncode(request.toJson());

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error completing work order: $e');
    }
  }

  @override
  Future<void> refuseWorkOrder(
    String id,
    RefuseWorkOrderRequest request,
  ) async {
    // Path: /api/v1/work_orders/{id}/refuse
    // According to api-1.json, this endpoint requires multipart/form-data
    final url = Uri.parse('$_baseURL/work_orders/$id/refuse');
    try {
      final requestHeaders = await _getHeaders();
      // Remove Content-Type so the http package can set it with the correct boundary
      requestHeaders.remove('Content-Type');

      final multipartRequest = http.MultipartRequest('POST', url);
      multipartRequest.headers.addAll(requestHeaders);

      // Map fields to match RefuseWorkOrderMultipart in api-1.json
      multipartRequest.fields['reason'] = request.reason;
      multipartRequest.fields['explanation'] = request.explanation;

      // Add evidence images
      for (final path in request.evidenceImageUrls) {
        if (path.isNotEmpty) {
          final file = await http.MultipartFile.fromPath('photos', path);
          multipartRequest.files.add(file);
        }
      }

      final streamedResponse = await multipartRequest.send().timeout(_timeOut);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error refusing work order: $e');
    }
  }

  @override
  Future<void> approveRefusal(String id, ApproveRefusalRequest request) async {
    // Path: /api/v1/work_orders/{id}/refusal/approve
    final url = Uri.parse('$_baseURL/work_orders/$id/refusal/approve');
    try {
      final headers = await _getHeaders();
      final body = jsonEncode(request.toJson());

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error approving refusal: $e');
    }
  }

  @override
  Future<void> denyRefusal(String id) async {
    // Path: /api/v1/work_orders/{id}/refusal/deny
    final url = Uri.parse('$_baseURL/work_orders/$id/refusal/deny');
    try {
      final headers = await _getHeaders();
      final response = await client
          .post(url, headers: headers)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error denying refusal: $e');
    }
  }

  @override
  Future<List<WorkOrderModel>> getActiveRepairs(String customerId) async {
    // Align with /api/v1/work_orders using status filters if possible.
    // Assuming status=active or equivalent filter.
    final url = Uri.parse('$_baseURL/work_orders?status=active');
    try {
      final headers = await _getHeaders();
      final response = await client
          .get(url, headers: headers)
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

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
        throw Exception(
          apiResponse.message ?? 'Failed to fetch active repairs',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error fetching active repairs: $e');
    }
  }

  void _handleErrorResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    debugPrint('--- API Error $statusCode ---');
    debugPrint('Body: $body');
    debugPrint('-----------------------------');

    if (body.isEmpty) {
      throw Exception('Server Error ($statusCode)');
    }

    final contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('application/json')) {
      try {
        final errorMap = jsonDecode(body);
        throw Exception(
          errorMap['message'] ?? 'Something went wrong ($statusCode)',
        );
      } catch (_) {
        throw Exception('Server response error ($statusCode)');
      }
    } else {
      throw Exception('Server error ($statusCode)');
    }
  }
}
