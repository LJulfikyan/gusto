import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:myapp/models/product.dart';
import 'package:myapp/models/store.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/services/mock_data_service.dart';
import 'package:myapp/widgets/product_card.dart';
import 'package:myapp/features/store/widgets/product_bottom_sheet.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, required this.storeId});

  final String storeId;

  @override
  Widget build(BuildContext context) {
    final storeData = MockDataService.stores.firstWhere(
      (element) => element['id'] == storeId,
      orElse: () => <String, dynamic>{},
    );

    if (storeData.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Local no encontrado')),
      );
    }

    final store = Store(
      id: storeData['id'],
      name: storeData['name'],
      cuisine: storeData['cuisine'],
      imageUrl: storeData['imageUrl'],
      rating: storeData['rating'],
    );

    final products = (MockDataService.productsByStore[storeId] ?? [])
        .map((data) => Product(
              id: data['id'],
              name: data['name'],
              description: data['description'],
              price: data['price'],
              imageUrl: data['imageUrl'],
              optionGroups: (data['optionGroups'] as List<dynamic>? ?? [])
                  .map(
                    (group) => ProductOptionGroup.fromMap(
                        group as Map<String, dynamic>),
                  )
                  .toList(),
            ))
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                tooltip: 'Ver carrito',
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.push('/cart'),
              ),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final settings =
                    context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
                final collapsedHeight = (settings?.minExtent ?? kToolbarHeight) + 12;
                final isCollapsed = constraints.maxHeight <= collapsedHeight;

                final theme = Theme.of(context);
                final collapsedStyle = theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ) ??
                    const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    );
                final expandedStyle = theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ) ??
                    TextStyle(
                      fontSize: collapsedStyle.fontSize != null
                          ? collapsedStyle.fontSize! * 1.2
                          : 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    );

                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  titlePadding: EdgeInsetsDirectional.only(
                    start: !isCollapsed ? 16 : 44,
                    bottom: 16,
                    end: 16,
                  ),
                  title: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 180),
                    style: isCollapsed ? collapsedStyle : expandedStyle,
                    child: Text(
                      store.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  stretchModes: const [
                    StretchMode.fadeTitle,
                    StretchMode.zoomBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'store-${store.id}',
                        child: Image.network(
                          store.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.65),
                              Colors.black.withValues(alpha: 0.04),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _Pill(
                        icon: Icons.star_rounded,
                        label: store.rating.toStringAsFixed(1),
                      ),
                      const SizedBox(width: 12),
                      _Pill(
                        icon: Icons.local_fire_department_rounded,
                        label: store.cuisine,
                      ),
                      const Spacer(),
                      _Pill(
                        icon: Icons.alarm_rounded,
                        label: '35 - 45 min',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Recomendaciones del chef',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _HighlightChip('Súper frescos'),
                      _HighlightChip('Veggie friendly'),
                      _HighlightChip('Pagá en el local'),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Menú',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            sliver: SliverList.separated(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Consumer<CartProvider>(
                  builder: (context, cart, _) {
                    final quantity = cart.items[product.id]?.quantity ?? 0;
                    return ProductCard(
                      product: product,
                      quantity: quantity,
                      onIncrement: () {
                        final currentQuantity =
                            cart.items[product.id]?.quantity ?? 0;
                        final wasZero = currentQuantity == 0;
                        cart.addItem(product);
                        if (wasZero) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} se agregó al carrito',
                              ),
                            ),
                          );
                        }
                      },
                      onDecrement: () => cart.removeSingleItem(product.id),
                      onViewDetails: () => showProductBottomSheet(
                        context,
                        product,
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 18),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(26),
                ),
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Coordiná directamente con el local el retiro o la entrega. YaComer solo conecta personas con sabores locales.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class _HighlightChip extends StatelessWidget {
  const _HighlightChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      labelStyle: Theme.of(context)
          .textTheme
          .labelLarge
          ?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }
}
