import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/product_model.dart';
import '../local/auth_local_datasource.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getMyProducts(String userId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  static final String _scmBaseUrl = dotenv.get("SCM_BASE_URL");
  static final String _zeusApiKey = dotenv.get("ZEUS_API_KEY");

  static final Duration _timeOut = Duration(
    seconds: int.tryParse(dotenv.get("TIME_OUT", fallback: "20")) ?? 20,
  );

  ProductRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  /// Headers for SCM (Zeus) calls — uses X-API-KEY + optional JWT
  Future<Map<String, String>> _getScmHeaders() async {
    final token = await authLocalDataSource.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-KEY': _zeusApiKey,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<ProductModel>> getMyProducts(String userId) async {
    final uri = Uri.parse(
      '$_scmBaseUrl/inventory/products',
    ).replace(queryParameters: {'limit': '1000'});

    try {
      final headers = await _getScmHeaders();
      final response = await client
          .get(uri, headers: headers)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
          '--- Product API Error ${response.statusCode} ---\n${response.body}',
        );
        throw Exception('Failed to fetch products (${response.statusCode})');
      }

      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final rawData = jsonMap['data'];

      List<dynamic> items;
      if (rawData is List) {
        items = rawData;
      } else if (rawData is Map<String, dynamic>) {
        items = rawData['items'] as List<dynamic>? ?? [];
      } else {
        items = [];
      }

      final List<ProductModel> filteredProducts = [];
      for (final item in items) {
        if (item is! Map<String, dynamic>) continue;

        final customerId =
            (item['CustomerID'] ?? item['customer_id'] ?? item['customerId'])
                ?.toString() ??
            '';
        if (customerId.toLowerCase() == userId.toLowerCase()) {
          debugPrint('SCM product raw item matches customer $userId: $item');

          final id = (item['ID'] ?? item['id'] ?? item['Id'])?.toString() ?? '';
          final name =
              (item['ProductName'] ??
                      item['product_name'] ??
                      item['productName'] ??
                      item['name'])
                  ?.toString() ??
              '';
          final model =
              (item['ProductModelCode'] ??
                      item['product_model_code'] ??
                      item['productModelCode'] ??
                      item['model'])
                  ?.toString() ??
              '';
          final serialNumber =
              (item['SerialNumber'] ??
                      item['serial_number'] ??
                      item['serialNumber'])
                  ?.toString() ??
              '';
          final nestedModel =
              item['product_model'] ??
              item['productModel'] ??
              item['ProductModel'];
          String? nestedImageUrl;
          if (nestedModel is Map) {
            nestedImageUrl =
                (nestedModel['image_url'] ??
                        nestedModel['imageUrl'] ??
                        nestedModel['ImageURL'] ??
                        nestedModel['product_image_url'] ??
                        nestedModel['productImageUrl'])
                    ?.toString();
          }

          final rawImageUrl =
              (item['ProductImageUrl'] ??
                      item['ProductImageURL'] ??
                      item['product_image_url'] ??
                      item['productImageUrl'] ??
                      item['ImageURL'] ??
                      item['imageUrl'] ??
                      item['image_url'])
                  ?.toString() ??
              nestedImageUrl;

          final productImageUrl = _sanitizeImageUrl(rawImageUrl);

          debugPrint(
            '=== [getMyProducts] Parsed productImageUrl for ${item['serial_number'] ?? item['serialNumber']}: $productImageUrl ===',
          );

          final warrantyStr =
              (item['WarrantyUntil'] ??
                      item['warranty_until'] ??
                      item['warrantyUntil'] ??
                      item['Warranty'] ??
                      item['warranty'])
                  ?.toString();
          final warrantyUntil = warrantyStr != null
              ? DateTime.tryParse(warrantyStr)
              : null;

          filteredProducts.add(
            ProductModel(
              id: id,
              name: name,
              model: model,
              serialNumber: serialNumber,
              warrantyUntil: warrantyUntil,
              productImageUrl: productImageUrl,
            ),
          );
        }
      }
      return filteredProducts;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error fetching products: $e');
    }
  }

  String? _sanitizeImageUrl(String? url) {
    if (url == null || url.isEmpty) return url;
    if (!url.contains('placehold.co')) return url;
    try {
      final uri = Uri.parse(url);
      if (uri.path.endsWith('.png') ||
          uri.path.endsWith('.jpg') ||
          uri.path.endsWith('.jpeg') ||
          uri.path.endsWith('.gif') ||
          uri.path.endsWith('.webp') ||
          uri.path.endsWith('.svg')) {
        return url;
      }
      final newPath = '${uri.path}.png';
      final newUri = uri.replace(path: newPath);
      return newUri.toString();
    } catch (_) {
      return url;
    }
  }
}
