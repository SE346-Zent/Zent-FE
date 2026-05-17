import 'package:http/http.dart' as http;
import '../../models/product_model.dart';
import '../local/auth_local_datasource.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getMyProducts(String userId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  ProductRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  @override
  Future<List<ProductModel>> getMyProducts(String userId) async {
    // TEMPORARY: Hardcoded seeding as the /product/my_products endpoint is not in api-1.json
    // Data matched from database screenshot provided by user
    return [
      ProductModel(
        id: '155630d2-54c0-46ef-abff-dd797fcadea7',
        name: 'Lenovo relationships',
        model: '83LY00HQVN',
        serialNumber: 'SN-RELATIONSHIPS-00006',
      ),
      ProductModel(
        id: '5d530009-ff8d-4e48-abbe-57850174fb76',
        name: 'Lenovo applications',
        model: '82SN003JVN',
        serialNumber: 'SN-APPLICATIONS-00005',
      ),
      ProductModel(
        id: '8b002018-3651-4726-ad5d-cb6437c5aec5',
        name: 'Lenovo paradigms',
        model: '82SN003JVN',
        serialNumber: 'SN-PARADIGMS-00000',
      ),
      ProductModel(
        id: 'a6248c33-7436-4d3d-919d-9b9022737b79',
        name: 'Lenovo infomediaries',
        model: '82SN003JVN',
        serialNumber: 'SN-INFOMEDIARIES-00008',
      ),
      ProductModel(
        id: 'b37096c3-ecbe-4404-8806-62bdf95cb8fe',
        name: 'Lenovo infomediaries',
        model: '82SN003JVN',
        serialNumber: 'SN-INFOMEDIARIES-00002',
      ),
      ProductModel(
        id: 'fe9ff979-d1e3-406c-8564-0924fc0434bd',
        name: 'Lenovo metrics',
        model: '82SN003JVN',
        serialNumber: 'SN-METRICS-00007',
      ),
    ];
  }
}
