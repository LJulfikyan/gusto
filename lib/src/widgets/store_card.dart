import 'package:flutter/material.dart';
import 'package:myapp/src/models/store.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback onTap;

  const StoreCard({super.key, required this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Image.network(store.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
            ListTile(
              title: Text(store.name),
              subtitle: Text(store.cuisine),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  Text(store.rating.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
