import 'package:flutter/foundation.dart';

import '../../domain/entities/inventory_part.dart';
import '../../domain/entities/pagination_meta.dart';
import '../../domain/entities/part_catalog_entry.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/entities/register_product_result.dart';
import '../../domain/entities/scm_product.dart';
import '../../domain/entities/warranty_check_result.dart';
import '../../domain/entities/new_part_form.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/remote/inventory_remote_datasource.dart';
import '../models/inventory_part_model.dart';
import '../models/new_part_form_model.dart';
import '../models/pagination_meta_model.dart';
import '../models/part_catalog_entry_model.dart';
import '../models/product_detail_model.dart';
import '../models/register_product_result_model.dart';
import '../models/scm_product_model.dart';
import '../models/warranty_check_result_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;

  InventoryRepositoryImpl({required this.remoteDataSource});

  // ──────────────────────────────────────────────────────
  //  SCM (Zeus) — paginated list responses
  //  Two possible response shapes (handle both):
  //    A) { data: { items: [...], pagination: {...} } }  (spec)
  //    B) { data: [...], metadata: { pagination: {...} } }  (actual)
  // ──────────────────────────────────────────────────────

  /// Extracts the list of items from either response shape A or B.
  List<T> _extractItems<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = json['data'];

    // Shape B: data is a direct array
    if (data is List) {
      return data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }

    // Shape A: data is { items: [...], pagination: {...} }
    if (data is Map<String, dynamic>) {
      final items = data['items'] as List<dynamic>?;
      if (items != null) {
        return items.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      }
    }

    return <T>[];
  }

  /// Extracts pagination from either response shape A or B.
  PaginationMeta _extractPagination(Map<String, dynamic> json) {
    // Shape B: pagination in metadata.pagination
    final metadata = json['metadata'] as Map<String, dynamic>?;
    final metaPagination = metadata?['pagination'] as Map<String, dynamic>?;
    if (metaPagination != null) {
      return PaginationMetaModel.fromJson(metaPagination);
    }

    // Shape A: pagination in data.pagination
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final dataPagination = data['pagination'] as Map<String, dynamic>?;
      if (dataPagination != null) {
        return PaginationMetaModel.fromJson(dataPagination);
      }
    }

    return _emptyPagination();
  }

  @override
  Future<(List<ScmProduct>, PaginationMeta)> getScmProducts({
    int page = 1,
    int limit = 15,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  }) async {
    final json = await remoteDataSource.getScmProducts(
      page: page,
      limit: limit,
      query: query,
      sortBy: sortBy,
      sortDir: sortDir,
    );

    final items = _extractItems(json, ScmProductModel.fromJson);
    final pagination = _extractPagination(json);

    return (items, pagination);
  }

  @override
  Future<(List<InventoryPart>, PaginationMeta)> getParts({
    int page = 1,
    int limit = 15,
    String? catalogId,
    String? productId,
    int? conditionId,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  }) async {
    final json = await remoteDataSource.getParts(
      page: page,
      limit: limit,
      catalogId: catalogId,
      productId: productId,
      conditionId: conditionId,
      query: query,
      sortBy: sortBy,
      sortDir: sortDir,
    );

    final items = _extractItems(json, InventoryPartModel.fromJson);
    final pagination = _extractPagination(json);

    return (items, pagination);
  }

  @override
  Future<(List<PartCatalogEntry>, PaginationMeta)> getPartCatalog({
    int page = 1,
    int limit = 15,
    int? typeId,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  }) async {
    final json = await remoteDataSource.getPartCatalog(
      page: page,
      limit: limit,
      typeId: typeId,
      query: query,
      sortBy: sortBy,
      sortDir: sortDir,
    );

    final items = _extractItems(json, PartCatalogEntryModel.fromJson);
    final pagination = _extractPagination(json);

    return (items, pagination);
  }

  @override
  Future<InventoryPart> getPartById(String id) async {
    final json = await remoteDataSource.getPartById(id);
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Part not found: $id');
    }
    return InventoryPartModel.fromJson(data);
  }

  // ──────────────────────────────────────────────────────
  //  Zent BE — single-object responses
  //  Response shape: { statusCode, message, data: {...} }
  // ──────────────────────────────────────────────────────

  @override
  Future<ProductDetail> getProductDetail(String productId) async {
    final json = await remoteDataSource.getProductDetail(productId);
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Product detail not found: $productId');
    }
    return ProductDetailModel.fromJson(data);
  }

  @override
  Future<WarrantyCheckResult> checkWarranty(String serialNumber) async {
    final json = await remoteDataSource.checkWarranty(serialNumber);
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Warranty check failed for serial: $serialNumber');
    }
    return WarrantyCheckResultModel.fromJson(data);
  }

  String _convertProvinceToCode(String province) {
    final lower = province.toLowerCase();
    if (lower.contains('hồ chí minh') || lower.contains('ho chi minh')) {
      return 'HCM';
    }
    if (lower.contains('hà nội') || lower.contains('ha noi')) {
      return 'HN';
    }
    return province;
  }

  @override
  Future<RegisterProductResult> registerProduct({
    required String serialNumber,
    required String country,
    required String province,
    required String city,
    required String address,
    required String firstName,
    required String lastName,
    required String email,
    required String mobilePhone,
    required bool sendEmailConfirmation,
  }) async {
    final body = {
      'serialNumber': serialNumber,
      'country': country,
      'province': _convertProvinceToCode(province),
      'ward': city,
      'address': address,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobilePhone': mobilePhone,
      'sendEmailConfirmation': sendEmailConfirmation,
    };

    final json = await remoteDataSource.registerProduct(body);
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      final message = json['message']?.toString() ?? 'Registration failed';
      return RegisterProductResult(
        productId: '',
        serialNumber: serialNumber,
        message: message,
        emailSent: false,
      );
    }
    return RegisterProductResultModel.fromJson(data);
  }

  @override
  Future<void> acceptPart(String partId) async {
    await remoteDataSource.acceptPart(partId);
    debugPrint('Part accepted: $partId');
  }

  @override
  Future<void> denyPart(String partId, String reason) async {
    await remoteDataSource.denyPart(partId, reason);
    debugPrint('Part denied: $partId, reason: $reason');
  }

  @override
  Future<void> addPartsToWorkOrder({
    required String workOrderId,
    required String partNumber,
    required int partTypesId,
    required String serialNumber,
    required String workOrderNumber,
    String? description,
    String? modelCode,
    List<String>? photos,
  }) async {
    await remoteDataSource.addPartsToWorkOrder(
      workOrderId: workOrderId,
      partNumber: partNumber,
      partTypesId: partTypesId,
      serialNumber: serialNumber,
      workOrderNumber: workOrderNumber,
      description: description,
      modelCode: modelCode,
      photos: photos,
    );
    debugPrint('Parts added to work order: $workOrderId');
  }

  @override
  Future<Map<String, dynamic>> getAnalytics({required String period}) async {
    final json = await remoteDataSource.getAnalytics(period: period);
    return json;
  }

  @override
  Future<(List<NewPartForm>, NewPartFormStatusSummary)> getPartRequests({
    int page = 1,
    int limit = 15,
    String? status,
    String? query,
  }) async {
    final json = await remoteDataSource.getPartRequests(
      page: page,
      limit: limit,
      status: status,
      query: query,
    );

    final dataMap = json['data'] as Map<String, dynamic>?;
    if (dataMap == null) {
      return (
        <NewPartForm>[],
        NewPartFormStatusSummary(pending: 0, approved: 0, rejected: 0),
      );
    }

    final itemsList = dataMap['items'] as List<dynamic>?;
    final items =
        itemsList
            ?.map((e) => NewPartFormModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <NewPartForm>[];

    final summaryMap = dataMap['summary'] as Map<String, dynamic>?;
    final summary = summaryMap != null
        ? NewPartFormStatusSummaryModel.fromJson(summaryMap)
        : NewPartFormStatusSummary(pending: 0, approved: 0, rejected: 0);

    return (items, summary);
  }

  @override
  Future<NewPartForm> getPartRequestById(String id) async {
    final json = await remoteDataSource.getPartRequestById(id);
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Part request not found: $id');
    }
    return NewPartFormModel.fromJson(data);
  }

  @override
  Future<Map<String, dynamic>> getScmLuts() async {
    return await remoteDataSource.getScmLuts();
  }

  // ──────────────────────────────────────────────────────
  //  Helpers
  // ──────────────────────────────────────────────────────

  PaginationMeta _emptyPagination() =>
      PaginationMeta(limit: 15, page: 1, totalPages: 0, totalRows: 0);
}
