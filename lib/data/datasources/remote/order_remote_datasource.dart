import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/api_response.dart';
import '../../models/work_order_model.dart';
import '../local/auth_local_datasource.dart';

abstract class OrderRemoteDataSource {
  Future<WorkOrderModel> getSingleWorkOrder(String id);
  Future<List<WorkOrderModel>> getManyWorkOrders(String userId);
  Future<void> createWorkOrder({
    required String productId,
    required String description,
    required String customerId,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  static final String _baseURL = dotenv.get(
    "BASE_URL",
    fallback: "http://localhost:3000/api",
  );

  static final Duration _timeOut = Duration(
    seconds: int.tryParse(dotenv.get("TIMEOUT_SECONDS", fallback: "20")) ?? 20,
  );

  OrderRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  Future<Map<String, String>> _getHeaders() async {
    final token = await authLocalDataSource.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<WorkOrderModel> getSingleWorkOrder(String id) async {
    final url = Uri.parse('$_baseURL/work_order/single_wo?Id=$id');
    try {
      final headers = await _getHeaders();
      final response = await client
          .get(url, headers: headers)
          .timeout(_timeOut);

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
      final response = await client
          .get(url, headers: headers)
          .timeout(_timeOut);

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
  Future<void> createWorkOrder({
    required String productId,
    required String description,
    required String customerId,
  }) async {
    final url = Uri.parse('$_baseURL/work_order/create');
    try {
      final headers = await _getHeaders();
      final body = jsonEncode({
        'productId': productId,
        'description': description,
        'customerId': customerId,
      });

      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(_timeOut);

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<void>.fromJson(jsonMap, (_) {});

      if (!apiResponse.isSuccessful) {
        throw Exception(apiResponse.message ?? 'Failed to create work order');
      }
    } catch (e) {
      throw Exception('Error creating work order: $e');
    }
  }
}
