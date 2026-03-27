import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class GetMyProductsUseCase {
  final ProductRepository repository;

  GetMyProductsUseCase(this.repository);

  Future<List<Product>> execute(String userId) async {
    return await repository.getMyProducts(userId);
  }
}
