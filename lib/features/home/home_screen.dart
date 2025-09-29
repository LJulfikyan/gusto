import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:myapp/models/store.dart';
import 'package:myapp/services/mock_data_service.dart';
import 'package:myapp/widgets/brand_logo.dart';
import 'package:myapp/widgets/store_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _selectedCategory = ValueNotifier<int>(0);
  late final List<Store> _stores;
  late final List<String> _categories;

  @override
  void initState() {
    super.initState();
    _stores = MockDataService.stores
        .map((data) => Store(
              id: data['id'],
              name: data['name'],
              cuisine: data['cuisine'],
              imageUrl: data['imageUrl'],
              rating: data['rating'],
            ))
        .toList();
    _categories = <String>{'Todos', ..._stores.map((store) => store.cuisine)}.toList();
  }

  @override
  void dispose() {
    _selectedCategory.dispose();
    super.dispose();
  }

  List<Store> _filteredStores(int selectedIndex) {
    if (selectedIndex == 0) {
      return _stores;
    }
    final selectedCuisine = _categories[selectedIndex];
    return _stores.where((store) => store.cuisine == selectedCuisine).toList();
  }

  @override
  Widget build(BuildContext context) {
    final overlayStyle = Theme.of(context).brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:100, right: 24),
        child: FloatingActionButton(
          onPressed: () => context.push('/cart'),
          child: const Icon(Icons.shopping_cart_outlined),
          
        ),
      ),

      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: SafeArea(
          child: ValueListenableBuilder<int>(
            valueListenable: _selectedCategory,
            builder: (context, selectedIndex, _) {
              final stores = _filteredStores(selectedIndex);

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    toolbarHeight: 148,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'yaComer.brand.mark',
                            child: const BrandLogo(size: 54),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hola de nuevo',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '¿Qué ganas tenés hoy?',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(96),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: _SearchBar(
                                onSubmitted: (query) {
                                  if (query.isEmpty) {
                                    _selectedCategory.value = 0;
                                    return;
                                  }
                                  final index = _categories.indexWhere(
                                    (category) => category.toLowerCase() == query.toLowerCase(),
                                  );
                                  if (index != -1) {
                                    _selectedCategory.value = index;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            _CategorySelector(
                              categories: _categories,
                              selectedIndex: selectedIndex,
                              onSelected: (index) => _selectedCategory.value = index,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                    sliver: SliverList.separated(
                      itemCount: stores.length,
                      itemBuilder: (context, index) {
                        final store = stores[index];
                        return StoreCard(
                          store: store,
                          index: index,
                          onTap: () => context.push('/store/${store.id}'),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 24),
                    ),
                  ),
                  if (stores.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(onReset: () => _selectedCategory.value = 0),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onSubmitted});

  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar por cocina o nombre',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          onPressed: () {},
        ),
      ),
      onSubmitted: onSubmitted,
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedIndex == index;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => onSelected(index),
            labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 72,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 24),
          Text(
            'No encontramos opciones para tu búsqueda',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Probá con otra categoría o reiniciá los filtros para volver a ver todos los locales.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onReset,
            child: const Text('Ver todo'),
          ),
        ],
      ),
    );
  }
}
