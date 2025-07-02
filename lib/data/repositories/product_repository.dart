import '../datasources/local/product_local_datasource.dart';
import '../datasources/remote/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ProductRemoteDataSource remote;
  final ProductLocalDataSource local;

  ProductRepository({required this.remote, required this.local});

  Future<void> fetchAndCacheProducts({required int skip, required int limit}) async {
    final products = await remote.fetchProducts(skip: skip, limit: limit);
    await local.insertProducts(products);
  }

  Future<List<ProductModel>> getCachedProducts() {
    return local.getAllProducts();
  }

  Future<List<ProductModel>> fetchProductsOnly({required int skip, required int limit}) {
    return remote.fetchProducts(skip: skip, limit: limit);
  }

  Future<void> cacheProducts(List<ProductModel> products) {
    return local.insertProducts(products);
  }
}
