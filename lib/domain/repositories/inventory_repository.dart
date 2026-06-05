import 'package:zent_fe/domain/entities/inventory_part.dart';
import 'package:zent_fe/domain/entities/pagination_meta.dart';
import 'package:zent_fe/domain/entities/part_catalog_entry.dart';
import 'package:zent_fe/domain/entities/product_detail.dart';
import 'package:zent_fe/domain/entities/register_product_result.dart';
import 'package:zent_fe/domain/entities/scm_product.dart';
import 'package:zent_fe/domain/entities/warranty_check_result.dart';
import 'package:zent_fe/domain/entities/new_part_form.dart';

abstract class InventoryRepository {
  Future<(List<ScmProduct>, PaginationMeta)> getScmProducts({
    int page = 1,
    int limit = 15,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  });

  Future<(List<InventoryPart>, PaginationMeta)> getParts({
    int page = 1,
    int limit = 15,
    String? catalogId,
    String? productId,
    int? conditionId,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  });

  Future<(List<PartCatalogEntry>, PaginationMeta)> getPartCatalog({
    int page = 1,
    int limit = 15,
    int? typeId,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  });

  Future<InventoryPart> getPartById(String id);

  Future<ProductDetail> getProductDetail(String productId);

  Future<WarrantyCheckResult> checkWarranty(String serialNumber);

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
  });

  Future<void> acceptPart(String partId);

  Future<void> denyPart(String partId, String reason);

  Future<void> addPartsToWorkOrder({
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

  Future<(List<NewPartForm>, NewPartFormStatusSummary)> getPartRequests({
    int page = 1,
    int limit = 15,
    String? status,
    String? query,
  });

  Future<NewPartForm> getPartRequestById(String id);

  Future<Map<String, dynamic>> getScmLuts();

  Future<Map<String, dynamic>> getScmAssets();

  Future<String> exportInventoryAssets({String? query});
}
