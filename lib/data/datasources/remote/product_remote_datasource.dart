import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/product_model.dart';
import '../local/auth_local_datasource.dart';
import '../../../domain/exceptions/business_exception.dart';

abstract class ProductRemoteDataSource {
  /// Returns the authenticated customer's registered products from Zent BE.
  Future<List<ProductModel>> getMyProducts(String userId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  static final String _baseURL = dotenv.get("BASE_URL");

  static final Duration _timeOut = Duration(
    seconds: int.tryParse(dotenv.get("TIMEOUT_SECONDS", fallback: "20")) ?? 20,
  );

  ProductRemoteDataSourceImpl({
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
  Future<List<ProductModel>> getMyProducts(String userId) async {
    // Zent BE endpoint — uses JWT auth, no SCM API key needed.
    final uri = Uri.parse('$_baseURL/inventory/products/mine');

    try {
      final headers = await _getHeaders();
      final response = await client
          .get(uri, headers: headers)
          .timeout(_timeOut);

      debugPrint(
        '=== [ProductAPI] GET /inventory/products/mine ${response.statusCode}: ${response.body} ===',
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _handleError(response);
      }

      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final rawData = jsonMap['data'];

      List<dynamic> items;
      if (rawData is List) {
        items = rawData;
      } else {
        items = [];
      }

      return items
          .whereType<Map<String, dynamic>>()
          .map((item) => ProductModel.fromZentJson(item))
          .toList();
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error fetching products: $e');
    }
  }

  void _handleError(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    debugPrint('--- Product API Error $statusCode ---\n$body');

    if (body.isNotEmpty) {
      try {
        final errorMap = jsonDecode(body);
        final message = errorMap['message'];
        if (statusCode >= 400 && statusCode < 500 && message is String) {
          throw BusinessException(message);
        }
      } catch (e) {
        if (e is BusinessException) rethrow;
      }
    }
    throw Exception('Failed to fetch products ($statusCode)');
  }
}
