
import 'package:flutter/material.dart';
import 'package:product_list/data/models/product_model.dart';
import 'package:product_list/data/repositories/product_repository.dart';

class ProductDetailPage extends StatelessWidget {
  final int? productId;
  final ProductRepository repository;

  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {

    if (productId == null) {
      return const Scaffold(
        body: Center(child: Text("Invalid product ID")),
      );
    }
    return FutureBuilder<List<ProductModel>>(
      future: repository.getCachedProducts(), // Get all cached
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final product = snapshot.data!.firstWhere(
              (p) => p.id == productId,
          orElse: () => null as ProductModel,
        );

        if (product == null) {
          return const Scaffold(
            body: Center(child: Text(" Product not found in local storage.")),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(product.title)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    product.thumbnail?? '',
                    width: 200,
                    height: 200,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(height: 20),
                Text(product.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                Text(product.description),
                const SizedBox(height: 10),
                Text("Category: ${product.category}"),
                Text("Brand: ${product.brand}"),
                const SizedBox(height: 10),
                Text("💵 Price: \$${product.price?.toStringAsFixed(2)}"),
                Text("⭐ Rating: ${product.rating}"),
              ],
            ),
          ),
        );
      },
    );

  }
}







