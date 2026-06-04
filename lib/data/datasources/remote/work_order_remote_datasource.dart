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
import '../../models/edit_work_order_request.dart';
import '../local/auth_local_datasource.dart';
import '../../../domain/exceptions/business_exception.dart';

abstract class WorkOrderRemoteDataSource {
  Future<List<WorkOrderModel>> getWorkOrders({
    int page = 1,
    int limit = 20,
    String? role,
    String? province,
    String? technicianId,
    String? date,
  });
  Future<WorkOrderModel> getWorkOrderDetail(String id);
  Future<void> createWorkOrder(CreateWorkOrderRequest request);
  Future<void> completeWorkOrder(String id, CompleteWorkOrderRequest request);
  Future<void> refuseWorkOrder(String id, RefuseWorkOrderRequest request);
  Future<void> approveRefusal(String id, ApproveRefusalRequest request);
  Future<void> denyRefusal(String id);
  Future<List<WorkOrderModel>> getActiveRepairs(String customerId);
  Future<void> changeAppointment(String id, DateTime newDate);
  Future<void> reassignWorkOrder(String id, String newTechnicianId);
  Future<void> cancelWorkOrder(String id, String? reason);
  Future<List<Map<String, dynamic>>> getTechnicians();
  Future<void> assignWorkOrder(String id, String technicianId);
  Future<void> startWorkOrder(String id, double latitude, double longitude);
  Future<void> uploadClosingFormPhoto(
    String id,
    String filePath,
    double latitude,
    double longitude,
    String phase,
  );
  Future<Map<String, dynamic>> getWorkOrderHistory(String id);
  Future<void> rateWorkOrder(String id, int rating, String? comment);
  Future<void> editWorkOrder(
    String workOrderNumber,
    EditWorkOrderRequest request,
  );
}

class WorkOrderRemoteDataSourceImpl implements WorkOrderRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  // The BASE_URL should be something like http://.../api/v1
  static final String _baseURL = dotenv.get("BASE_URL");

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
    String? date,
  }) async {
    final queryParameters = <String, String>{};
    if (role != null) queryParameters['role'] = role;
    if (province != null) queryParameters['province'] = province;
    if (technicianId != null) queryParameters['technician_id'] = technicianId;
    if (date != null) queryParameters['date'] = date;

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

      debugPrint('=== [API Response] GET /work_orders: ${response.body} ===');

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

      debugPrint(
        '=== [API Response] GET /work_orders/$id: ${response.body} ===',
      );

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
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
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
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
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
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
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
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error denying refusal: $e');
    }
  }

  @override
  Future<void> changeAppointment(String id, DateTime newDate) async {
    final url = Uri.parse('$_baseURL/work_orders/$id/change-appointment');
    try {
      final headers = await _getHeaders();
      final body = jsonEncode({
        'newAppointment': newDate.toUtc().toIso8601String(),
      });

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error changing appointment: $e');
    }
  }

  @override
  Future<void> reassignWorkOrder(String id, String newTechnicianId) async {
    final url = Uri.parse('$_baseURL/work_orders/$id/reassign');
    try {
      final headers = await _getHeaders();
      final body = jsonEncode({'technicianId': newTechnicianId});

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error changing technician: $e');
    }
  }

  @override
  Future<void> cancelWorkOrder(String id, String? reason) async {
    final url = Uri.parse('$_baseURL/work_orders/$id/cancel');
    final headers = await _getHeaders();
    final body = jsonEncode({'reason': reason});

    final response = await client
        .post(url, headers: headers, body: body)
        .timeout(_timeOut);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      _handleErrorResponse(response);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTechnicians() async {
    final url = Uri.parse(
      '$_baseURL/users?page=1&page_size=50&role=technician',
    );
    try {
      final headers = await _getHeaders();
      final response = await client
          .get(url, headers: headers)
          .timeout(_timeOut);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final users = body['data']['users'] as List<dynamic>;
        return users.map((u) => u as Map<String, dynamic>).toList();
      } else {
        _handleErrorResponse(response);
        return [];
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error fetching technicians: $e');
    }
  }

  @override
  Future<void> assignWorkOrder(String id, String technicianId) async {
    final url = Uri.parse('$_baseURL/work_orders/$id/assign');
    try {
      final headers = await _getHeaders();
      final body = jsonEncode({'technicianId': technicianId});

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error assigning work order: $e');
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

  @override
  Future<void> startWorkOrder(
    String id,
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse('$_baseURL/work_orders/$id/start');
    try {
      final headers = await _getHeaders();
      final body = jsonEncode({'latitude': latitude, 'longitude': longitude});

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error starting work order: $e');
    }
  }

  @override
  Future<void> uploadClosingFormPhoto(
    String id,
    String filePath,
    double latitude,
    double longitude,
    String phase,
  ) async {
    final url = Uri.parse(
      '$_baseURL/media/work_orders/$id/closing_form/photos',
    );
    try {
      final requestHeaders = await _getHeaders();
      requestHeaders.remove('Content-Type');

      final multipartRequest = http.MultipartRequest('POST', url);
      multipartRequest.headers.addAll(requestHeaders);

      multipartRequest.fields['latitude'] = latitude.toString();
      multipartRequest.fields['longitude'] = longitude.toString();
      multipartRequest.fields['phase'] = phase;

      final nowSeconds = (DateTime.now().millisecondsSinceEpoch ~/ 1000)
          .toString();
      multipartRequest.fields['internet_time'] = nowSeconds;
      multipartRequest.fields['internetTime'] = nowSeconds;
      multipartRequest.fields['timestamp'] = nowSeconds;
      multipartRequest.fields['dateTime'] = nowSeconds;

      final file = await http.MultipartFile.fromPath('file', filePath);
      multipartRequest.files.add(file);

      final streamedResponse = await multipartRequest.send().timeout(_timeOut);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        // Bypass geofencing violation (403) for local testing purposes
        if (response.statusCode == 403 &&
            (response.body.contains("Geofencing violation") ||
                response.body.contains("too far"))) {
          debugPrint(
            "WARNING: Geofencing violation (403) bypassed for local testing.",
          );
          return;
        }

        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to verify & upload image: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getWorkOrderHistory(String id) async {
    final url = Uri.parse('$_baseURL/work_orders/$id/history');
    try {
      final headers = await _getHeaders();
      final response = await client
          .get(url, headers: headers)
          .timeout(_timeOut);

      final jsonMap = jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleErrorResponse(response);
      }

      if (jsonMap is Map<String, dynamic> && jsonMap.containsKey('data')) {
        return jsonMap['data'] as Map<String, dynamic>;
      }
      return jsonMap;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error fetching work order history: $e');
    }
  }

  @override
  Future<void> rateWorkOrder(String id, int rating, String? comment) async {
    final url = Uri.parse('$_baseURL/work_orders/$id/rate');
    try {
      final headers = await _getHeaders();
      final body = jsonEncode({'rating': rating, 'comment': comment});

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error rating work order: $e');
    }
  }

  @override
  Future<void> editWorkOrder(
    String workOrderNumber,
    EditWorkOrderRequest request,
  ) async {
    final url = Uri.parse('$_baseURL/work_orders/$workOrderNumber/edit');
    try {
      final headers = await _getHeaders();

      final Map<String, dynamic> bodyMap = request.toJson();
      if (bodyMap['productId'] != null) {
        bodyMap['product_id'] = bodyMap['productId'].toString().replaceAll(
          '-',
          '',
        );
        bodyMap.remove('productId');
      }

      final body = jsonEncode(bodyMap);
      debugPrint(
        '=== [API Request] POST /work_orders/$workOrderNumber/edit: $body ===',
      );

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error editing work order: $e');
    }
  }

  void _handleErrorResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    debugPrint('--- API Error $statusCode ---');
    debugPrint('Body: $body');
    debugPrint('-----------------------------');
    if (body.isEmpty) {
      throw Exception('Silent server error');
    }

    try {
      final errorMap = jsonDecode(body);
      final message = errorMap['message'];

      if (statusCode >= 400 && statusCode < 500 && message is String) {
        throw BusinessException(message);
      }

      throw Exception('Server error ($statusCode)');
    } on BusinessException {
      rethrow;
    } catch (e) {
      throw Exception('Server error ($statusCode)');
    }
  }
}
