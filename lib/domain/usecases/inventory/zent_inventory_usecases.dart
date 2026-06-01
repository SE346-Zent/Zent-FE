import '../../entities/product_detail.dart';
import '../../entities/register_product_result.dart';
import '../../entities/warranty_check_result.dart';
import '../../repositories/inventory_repository.dart';

class GetProductDetailUseCase {
  final InventoryRepository repository;

  GetProductDetailUseCase(this.repository);

  Future<ProductDetail> execute(String productId) async {
    return await repository.getProductDetail(productId);
  }
}

class CheckWarrantyUseCase {
  final InventoryRepository repository;

  CheckWarrantyUseCase(this.repository);

  Future<WarrantyCheckResult> execute(String serialNumber) async {
    return await repository.checkWarranty(serialNumber);
  }
}

class RegisterProductUseCase {
  final InventoryRepository repository;

  RegisterProductUseCase(this.repository);

  Future<RegisterProductResult> execute({
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
    return await repository.registerProduct(
      serialNumber: serialNumber,
      country: country,
      province: province,
      city: city,
      address: address,
      firstName: firstName,
      lastName: lastName,
      email: email,
      mobilePhone: mobilePhone,
      sendEmailConfirmation: sendEmailConfirmation,
    );
  }
}

class AcceptPartUseCase {
  final InventoryRepository repository;

  AcceptPartUseCase(this.repository);

  Future<void> execute(String partId) async {
    await repository.acceptPart(partId);
  }
}

class DenyPartUseCase {
  final InventoryRepository repository;

  DenyPartUseCase(this.repository);

  Future<void> execute(String partId, String reason) async {
    await repository.denyPart(partId, reason);
  }
}

class AddPartsToWorkOrderUseCase {
  final InventoryRepository repository;

  AddPartsToWorkOrderUseCase(this.repository);

  Future<void> execute({
    required String workOrderId,
    required String partNumber,
    required int partTypesId,
    required String serialNumber,
    required String workOrderNumber,
    String? description,
    String? modelCode,
    List<String>? photos,
  }) async {
    await repository.addPartsToWorkOrder(
      workOrderId: workOrderId,
      partNumber: partNumber,
      partTypesId: partTypesId,
      serialNumber: serialNumber,
      workOrderNumber: workOrderNumber,
      description: description,
      modelCode: modelCode,
      photos: photos,
    );
  }
}

class GetAnalyticsUseCase {
  final InventoryRepository repository;

  GetAnalyticsUseCase(this.repository);

  Future<Map<String, dynamic>> execute({required String period}) async {
    return await repository.getAnalytics(period: period);
  }
}
