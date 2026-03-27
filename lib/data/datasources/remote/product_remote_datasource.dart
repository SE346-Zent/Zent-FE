import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/api_response.dart';
import '../../models/product_model.dart';
import '../local/auth_local_datasource.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getMyProducts(String userId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  static final String _baseURL = dotenv.get(
    "BASE_URL",
    fallback: "http://localhost:3000/api",
  );

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
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<ProductModel>> getMyProducts(String userId) async {
    final url = Uri.parse('$_baseURL/product/my_products?userId=$userId');
    try {
      final headers = await _getHeaders();
      final response = await client
          .get(url, headers: headers)
          .timeout(_timeOut);

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<List<ProductModel>>.fromJson(jsonMap, (
        data,
      ) {
        if (data is List) {
          return data.map((e) => ProductModel.fromJson(e)).toList();
        }
        return [];
      });

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to fetch products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
