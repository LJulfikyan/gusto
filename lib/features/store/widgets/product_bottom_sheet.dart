import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/models/product.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/widgets/quantity_stepper.dart';

Future<void> showProductBottomSheet(
  BuildContext context,
  Product product,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ProductBottomSheet(product: product),
  );
}

class ProductBottomSheet extends StatefulWidget {
  const ProductBottomSheet({super.key, required this.product});

  final Product product;

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  late final Map<String, Set<String>> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = {
      for (final group in widget.product.optionGroups)
        group.id: group.allowsMultiple
            ? <String>{}
            : (group.options.isNotEmpty ? {group.options.first.id} : <String>{})
    };
  }

  void _toggleSelection(ProductOptionGroup group, ProductOption option) {
    setState(() {
      final current = _selectedOptions[group.id] ?? <String>{};
      if (group.allowsMultiple) {
        if (current.contains(option.id)) {
          current.remove(option.id);
        } else {
          current.add(option.id);
        }
      } else {
        current
          ..clear()
          ..add(option.id);
      }
      _selectedOptions[group.id] = current;
    });
  }

  num get _optionsTotal {
    num total = 0;
    for (final group in widget.product.optionGroups) {
      final selected = _selectedOptions[group.id] ?? const <String>{};
      for (final option in group.options) {
        if (selected.contains(option.id) && option.price != null) {
          total += option.price!;
        }
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final quantity = cart.items[widget.product.id]?.quantity ?? 0;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(

          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
        
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.onSurface.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        height: 220,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.product.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.product.description,
                      style: theme.textTheme.bodyLarge,
                    ),
                    if (widget.product.optionGroups.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      for (final group in widget.product.optionGroups) ...[
                        Text(
                          group.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: group.options
                              .map(
                                (option) => group.allowsMultiple
                                    ? FilterChip(
                                        selectedColor: colors.primaryContainer,
                                        checkmarkColor: colors.onPrimaryContainer,
                                        side: BorderSide.none,
                                        label: Text(_optionLabel(option)),
                                        selected: _selectedOptions[group.id]
                                                ?.contains(option.id) ??
                                            false,
                                        onSelected: (_) => _toggleSelection(
                                          group,
                                          option,
                                        ),
                                      )
                                    : ChoiceChip(
                                        selected: _selectedOptions[group.id]
                                                ?.contains(option.id) ??
                                            false,
                                        label: Text(_optionLabel(option)),
                                        selectedColor: colors.primaryContainer,
                                        onSelected: (_) => _toggleSelection(
                                          group,
                                          option,
                                        ),
                                      ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ],
                    if (_optionsTotal > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.add_card_rounded,
                            color: colors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Extras seleccionados: +\$${_optionsTotal.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        QuantityStepper(
                          quantity: quantity,
                          onIncrement: () {
                            final wasZero =
                                (cart.items[widget.product.id]?.quantity ?? 0) ==
                                    0;
                            cart.addItem(widget.product);
                            if (wasZero) {
                              _showAddedSnack(context);
                            }
                          },
                          onDecrement: () =>
                              cart.removeSingleItem(widget.product.id),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              cart.addItem(widget.product);
                              _showAddedSnack(context);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.add_shopping_cart_rounded),
                            label: const Text('Agregar'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Total estimado: \$${(widget.product.price + _optionsTotal).toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 140,)
            ],
          ),
        ),
      ),
    );
  }

  String _optionLabel(ProductOption option) {
    if (option.price == null || option.price == 0) {
      return option.name;
    }
    return '${option.name} (+\$${option.price!.toStringAsFixed(2)})';
  }

  void _showAddedSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} se agregó al carrito'),
      ),
    );
  }
}
