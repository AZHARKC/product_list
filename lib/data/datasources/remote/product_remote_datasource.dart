import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts({required int skip, required int limit});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> fetchProducts({required int skip, required int limit}) async {
    final response = await client.get(
      Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final products = (jsonBody['products'] as List)
          .map((item) => ProductModel.fromJson({
        ...item,
        'image': (item['images'] as List).isNotEmpty ? item['images'][0] : ''
      }))
          .toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
