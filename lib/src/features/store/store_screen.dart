import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/models/product.dart';
import 'package:myapp/src/services/mock_data_service.dart';
import 'package:myapp/src/widgets/product_card.dart';
import 'package:myapp/src/providers/cart_provider.dart';

class StoreScreen extends StatelessWidget {
  final String storeId;

  const StoreScreen({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    final productsData = MockDataService.productsByStore[storeId] ?? [];
    final products = productsData
        .map((data) => Product(
              id: data['id'],
              name: data['name'],
              description: data['description'],
              price: data['price'],
              imageUrl: data['imageUrl'],
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          final product = products[i];
          return ProductCard(
            product: product,
            onAddToCart: () {
              final cart = Provider.of<CartProvider>(context, listen: false);
              cart.addItem(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} fue agregado al carrito.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
