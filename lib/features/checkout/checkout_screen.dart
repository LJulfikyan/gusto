import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/models/cart_item.dart';
import 'package:myapp/providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmá tu pedido'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        physics: const BouncingScrollPhysics(),
        children: [
          _SummaryCard(items: items, total: cart.totalAmount),
          const SizedBox(height: 24),
          const _PickupSection(),
          const SizedBox(height: 24),
          const _PaymentSection(),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Pedido confirmado! Coordiná el retiro con el local.')),
              );
            },
            child: const Text('Confirmar pedido'),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.items, required this.total});

  final List<CartItem> items;
  final double total;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 26,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Text('${item.quantity}x', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item.product.name, style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Text(
                    '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 32),
          Row(
            children: [
              const Text('Total'),
              const Spacer(),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PickupSection extends StatelessWidget {
  const _PickupSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Retiro o entrega',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          const _TimelineStep(
            icon: Icons.storefront_outlined,
            title: 'El local prepara tu pedido',
            subtitle: 'Te avisarán cuando esté listo',
          ),
          const _TimelineStep(
            icon: Icons.directions_walk_rounded,
            title: 'Coordiná el retiro',
            subtitle: 'Acercate al local o pedí envío propio',
          ),
          const _TimelineStep(
            icon: Icons.sms_outlined,
            title: 'Contacto directo',
            subtitle: 'Utilizá el chat interno o el teléfono del local',
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSection extends StatefulWidget {
  const _PaymentSection();

  @override
  State<_PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<_PaymentSection> {
  String _selected = 'efectivo';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Método de pago',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          RadioListTile<String>(
            value: 'efectivo',
            groupValue: _selected,
            title: const Text('Efectivo o transferencia al retirar'),
            subtitle: const Text('Coordiná con el local el método exacto'),
            onChanged: (value) => setState(() => _selected = value ?? _selected),
          ),
          RadioListTile<String>(
            value: 'qr',
            groupValue: _selected,
            title: const Text('Pago QR en el local'),
            subtitle: const Text('Escaneá desde tu billetera al retirar'),
            onChanged: (value) => setState(() => _selected = value ?? _selected),
          ),
        ],
      ),
    );
  }
}
