import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../local/auth_local_datasource.dart';
import '../../../domain/exceptions/business_exception.dart';

abstract class InventoryRemoteDataSource {
  Future<Map<String, dynamic>> getScmProducts({
    int page = 1,
    int limit = 15,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  });

  Future<Map<String, dynamic>> getScmProductById(String id);

  Future<Map<String, dynamic>> getParts({
    int page = 1,
    int limit = 15,
    String? catalogId,
    String? productId,
    int? conditionId,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  });

  Future<Map<String, dynamic>> getPartById(String id);

  Future<Map<String, dynamic>> getPartCatalog({
    int page = 1,
    int limit = 15,
    int? typeId,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  });

  Future<Map<String, dynamic>> getProductDetail(String productId);

  Future<Map<String, dynamic>> checkWarranty(String serialNumber);

  Future<Map<String, dynamic>> registerProduct(Map<String, dynamic> body);

  Future<Map<String, dynamic>> acceptPart(String partId);

  Future<Map<String, dynamic>> denyPart(String partId, String reason);

  Future<Map<String, dynamic>> addPartsToWorkOrder({
    required String workOrderId,
    required String partNumber,
    required int partTypesId,
    required String serialNumber,
    required String workOrderNumber,
    String? description,
    String? modelCode,
    List<String>? photos,
  });

  Future<Map<String, dynamic>> getAnalytics({required String period});

  Future<Map<String, dynamic>> getPartRequests({
    int page = 1,
    int limit = 15,
    String? status,
    String? query,
  });

  Future<Map<String, dynamic>> getPartRequestById(String id);

  Future<Map<String, dynamic>> getScmLuts();
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  static final String _scmBaseUrl = dotenv.get("SCM_BASE_URL");

  static final String _zentBaseUrl = dotenv.get("BASE_URL");

  static final String _zeusApiKey = dotenv.get("ZEUS_API_KEY");

  static final Duration _timeOut = Duration(
    seconds: int.tryParse(dotenv.get("TIME_OUT", fallback: "20")) ?? 20,
  );

  InventoryRemoteDataSourceImpl({
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

  /// Headers for Zent BE calls — uses JWT BearerAuth
  Future<Map<String, String>> _getHeaders() async {
    final token = await authLocalDataSource.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ──────────────────────────────────────────────────────
  //  SCM (Zeus) endpoints — PascalCase responses
  // ──────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getScmProducts({
    int page = 1,
    int limit = 15,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  }) async {
    final uri = Uri.parse('$_scmBaseUrl/inventory/products').replace(
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        'sort_by': sortBy,
        'sort_dir': sortDir,
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );

    return _getScm(uri);
  }

  @override
  Future<Map<String, dynamic>> getScmProductById(String id) async {
    final uri = Uri.parse('$_scmBaseUrl/inventory/products/$id');
    return _getScm(uri);
  }

  @override
  Future<Map<String, dynamic>> getParts({
    int page = 1,
    int limit = 15,
    String? catalogId,
    String? productId,
    int? conditionId,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  }) async {
    final uri = Uri.parse('$_scmBaseUrl/inventory/parts').replace(
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        'sort_by': sortBy,
        'sort_dir': sortDir,
        if (catalogId != null && catalogId.isNotEmpty) 'catalog_id': catalogId,
        if (productId != null && productId.isNotEmpty) 'product_id': productId,
        if (conditionId != null) 'condition_id': conditionId.toString(),
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );

    return _getScm(uri);
  }

  @override
  Future<Map<String, dynamic>> getPartById(String id) async {
    final uri = Uri.parse('$_scmBaseUrl/inventory/parts/$id');
    return _getScm(uri);
  }

  @override
  Future<Map<String, dynamic>> getPartCatalog({
    int page = 1,
    int limit = 15,
    int? typeId,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  }) async {
    final uri = Uri.parse('$_scmBaseUrl/inventory/part-catalog').replace(
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        'sort_by': sortBy,
        'sort_dir': sortDir,
        if (typeId != null) 'type_id': typeId.toString(),
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );

    return _getScm(uri);
  }

  @override
  Future<Map<String, dynamic>> getScmLuts() async {
    final uri = Uri.parse('$_scmBaseUrl/luts');
    return _getScm(uri);
  }

  // ──────────────────────────────────────────────────────
  //  Zent BE endpoints — camelCase responses
  // ──────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getProductDetail(String productId) async {
    final uri = Uri.parse('$_zentBaseUrl/inventory/products/$productId');
    return _get(uri);
  }

  @override
  Future<Map<String, dynamic>> checkWarranty(String serialNumber) async {
    final uri = Uri.parse('$_zentBaseUrl/inventory/products/check-warranty');
    final body = jsonEncode({'serialNumber': serialNumber});
    return _post(uri, body);
  }

  @override
  Future<Map<String, dynamic>> registerProduct(
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$_zentBaseUrl/inventory/devices/register');
    return _post(uri, jsonEncode(body));
  }

  @override
  Future<Map<String, dynamic>> acceptPart(String partId) async {
    final uri = Uri.parse('$_zentBaseUrl/inventory/parts/$partId/accept');
    return _post(uri, null);
  }

  @override
  Future<Map<String, dynamic>> denyPart(String partId, String reason) async {
    final uri = Uri.parse('$_zentBaseUrl/inventory/parts/$partId/deny');
    final body = jsonEncode({'reason': reason});
    return _post(uri, body);
  }

  @override
  Future<Map<String, dynamic>> addPartsToWorkOrder({
    required String workOrderId,
    required String partNumber,
    required int partTypesId,
    required String serialNumber,
    required String workOrderNumber,
    String? description,
    String? modelCode,
    List<String>? photos,
  }) async {
    final url = Uri.parse(
      '$_zentBaseUrl/inventory/work_orders/$workOrderId/parts',
    );

    try {
      final requestHeaders = await _getHeaders();
      // Remove Content-Type so the http package can set it with the correct boundary
      requestHeaders.remove('Content-Type');

      final multipartRequest = http.MultipartRequest('POST', url);
      multipartRequest.headers.addAll(requestHeaders);

      multipartRequest.fields['partNumber'] = partNumber;
      multipartRequest.fields['partTypesId'] = partTypesId.toString();
      multipartRequest.fields['serialNumber'] = serialNumber;
      multipartRequest.fields['workOrderNumber'] = workOrderNumber;
      if (description != null && description.isNotEmpty) {
        multipartRequest.fields['description'] = description;
      }
      if (modelCode != null && modelCode.isNotEmpty) {
        multipartRequest.fields['modelCode'] = modelCode;
      }

      // Add evidence images
      if (photos != null && photos.isNotEmpty) {
        for (final path in photos) {
          if (path.isNotEmpty) {
            final file = await http.MultipartFile.fromPath('photos', path);
            multipartRequest.files.add(file);
          }
        }
      }

      final streamedResponse = await multipartRequest.send().timeout(_timeOut);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw _parseError(response);
      }

      if (response.body.isEmpty) {
        return {'statusCode': response.statusCode, 'message': 'success'};
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Multipart addPartsToWorkOrder failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAnalytics({required String period}) async {
    final uri = Uri.parse(
      '$_zentBaseUrl/inventory/analytics',
    ).replace(queryParameters: {'mode': period});
    return _get(uri);
  }

  @override
  Future<Map<String, dynamic>> getPartRequests({
    int page = 1,
    int limit = 15,
    String? status,
    String? query,
  }) async {
    final uri = Uri.parse('$_zentBaseUrl/inventory/part-requests').replace(
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status': status,
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );
    final response = await _get(uri);
    debugPrint('=== [getPartRequests] RESPONSE ===');
    debugPrint(jsonEncode(response));
    debugPrint('==================================');
    return response;
  }

  @override
  Future<Map<String, dynamic>> getPartRequestById(String id) async {
    final uri = Uri.parse('$_zentBaseUrl/inventory/part-requests/$id');
    final response = await _get(uri);
    debugPrint('=== [getPartRequestById] RESPONSE for id=$id ===');
    debugPrint(jsonEncode(response));
    debugPrint('================================================');
    return response;
  }

  // ──────────────────────────────────────────────────────
  //  Private helpers
  // ──────────────────────────────────────────────────────

  /// GET for Zent BE — uses JWT BearerAuth
  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final headers = await _getHeaders();
      final response = await client
          .get(uri, headers: headers)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw _parseError(response);
      }

      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonMap;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('GET $uri failed: $e');
    }
  }

  /// GET for SCM (Zeus) — uses X-API-KEY + optional JWT
  Future<Map<String, dynamic>> _getScm(Uri uri) async {
    try {
      final headers = await _getScmHeaders();
      final response = await client
          .get(uri, headers: headers)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw _parseError(response);
      }

      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonMap;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('GET $uri failed: $e');
    }
  }

  /// POST for Zent BE — uses JWT BearerAuth
  Future<Map<String, dynamic>> _post(Uri uri, String? body) async {
    try {
      final headers = await _getHeaders();
      final response = await client
          .post(uri, headers: headers, body: body)
          .timeout(_timeOut);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw _parseError(response);
      }

      // Handle empty success responses (e.g. acceptPart returns 200 with no body)
      if (response.body.isEmpty) {
        return {'statusCode': response.statusCode, 'message': 'success'};
      }

      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonMap;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('POST $uri failed: $e');
    }
  }

  Exception _parseError(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    debugPrint('--- Inventory API Error $statusCode ---');
    debugPrint('Body: $body');
    debugPrint('----------------------------------------');

    if (body.isEmpty) {
      return Exception('Silent server error');
    }

    try {
      final errorMap = jsonDecode(body);
      final message = errorMap['message'];
      
      if (statusCode >= 400 && statusCode < 500 && message is String) {
        return BusinessException(message);
      }
      
      return Exception('Silent API error');
    } catch (_) {
      return Exception('Silent parse error');
    }
  }
}
