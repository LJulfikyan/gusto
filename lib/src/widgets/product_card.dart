import 'package:flutter/material.dart';
import 'package:myapp/src/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({super.key, required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: onAddToCart,
        ),
      ),
    );
  }
}
