import '../../entities/inventory_part.dart';
import '../../entities/pagination_meta.dart';
import '../../entities/part_catalog_entry.dart';
import '../../entities/scm_product.dart';
import '../../entities/new_part_form.dart';
import '../../repositories/inventory_repository.dart';

class GetScmProductsUseCase {
  final InventoryRepository repository;

  GetScmProductsUseCase(this.repository);

  Future<(List<ScmProduct>, PaginationMeta)> execute({
    int page = 1,
    int limit = 15,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  }) async {
    return await repository.getScmProducts(
      page: page,
      limit: limit,
      query: query,
      sortBy: sortBy,
      sortDir: sortDir,
    );
  }
}

class GetPartsUseCase {
  final InventoryRepository repository;

  GetPartsUseCase(this.repository);

  Future<(List<InventoryPart>, PaginationMeta)> execute({
    int page = 1,
    int limit = 15,
    String? catalogId,
    String? productId,
    int? conditionId,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  }) async {
    return await repository.getParts(
      page: page,
      limit: limit,
      catalogId: catalogId,
      productId: productId,
      conditionId: conditionId,
      query: query,
      sortBy: sortBy,
      sortDir: sortDir,
    );
  }
}

class GetPartCatalogUseCase {
  final InventoryRepository repository;

  GetPartCatalogUseCase(this.repository);

  Future<(List<PartCatalogEntry>, PaginationMeta)> execute({
    int page = 1,
    int limit = 15,
    int? typeId,
    String? query,
    String sortBy = 'created_at',
    String sortDir = 'desc',
  }) async {
    return await repository.getPartCatalog(
      page: page,
      limit: limit,
      typeId: typeId,
      query: query,
      sortBy: sortBy,
      sortDir: sortDir,
    );
  }
}

class GetPartByIdUseCase {
  final InventoryRepository repository;

  GetPartByIdUseCase(this.repository);

  Future<InventoryPart> execute(String id) async {
    return await repository.getPartById(id);
  }
}

class GetPartRequestsUseCase {
  final InventoryRepository repository;

  GetPartRequestsUseCase(this.repository);

  Future<(List<NewPartForm>, NewPartFormStatusSummary)> execute({
    int page = 1,
    int limit = 15,
    String? status,
    String? query,
  }) async {
    return await repository.getPartRequests(
      page: page,
      limit: limit,
      status: status,
      query: query,
    );
  }
}

class GetNewPartFormByIdUseCase {
  final InventoryRepository repository;

  GetNewPartFormByIdUseCase(this.repository);

  Future<NewPartForm> execute(String id) async {
    return await repository.getPartRequestById(id);
  }
}

class GetScmLutsUseCase {
  final InventoryRepository repository;

  GetScmLutsUseCase(this.repository);

  Future<Map<String, dynamic>> execute() async {
    return await repository.getScmLuts();
  }
}
