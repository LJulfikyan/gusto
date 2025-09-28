import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cart.items.values.toList()[i];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('Precio: \$${item.product.price}'),
                  trailing: Text('${item.quantity} x'),
                );
              },
            ),
          ),
          if (cart.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  context.go('/checkout');
                },
                child: const Text('Proceder al Pago'),
              ),
            ),
        ],
      ),
    );
  }
}
