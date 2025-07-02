import 'package:sqflite/sqflite.dart';
import '../../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> insertProducts(List<ProductModel> products);
  Future<List<ProductModel>> getAllProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Database db;

  ProductLocalDataSourceImpl(this.db);

  @override
  Future<void> insertProducts(List<ProductModel> products) async {
    final batch = db.batch();
    for (final product in products) {
      batch.insert(
        'products',
        product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final result = await db.query('products');
    return result.map((json) => ProductModel.fromJson(json)).toList();
  }
}
