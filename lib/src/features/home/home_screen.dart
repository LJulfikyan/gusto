import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/store.dart';
import 'package:myapp/src/services/mock_data_service.dart';
import 'package:myapp/src/widgets/store_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stores = MockDataService.stores
        .map((data) => Store(
              id: data['id'],
              name: data['name'],
              cuisine: data['cuisine'],
              imageUrl: data['imageUrl'],
              rating: data['rating'],
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurantes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              context.go('/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go('/account');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (ctx, i) {
          final store = stores[i];
          return StoreCard(
            store: store,
            onTap: () {
              context.go('/store/${store.id}');
            },
          );
        },
      ),
    );
  }
}
