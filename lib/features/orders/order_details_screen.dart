import 'package:flutter/material.dart';

import 'package:myapp/models/order.dart';
import 'package:myapp/services/mock_data_service.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final ordersData = MockDataService.orders.cast<Map<String, dynamic>>();
    final orderData = ordersData.firstWhere(
      (order) => order['id'] == orderId,
      orElse: () => <String, dynamic>{},
    );

    if (orderData.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Pedido #$orderId')),
        body: const Center(child: Text('No encontramos la información de este pedido.')),
      );
    }

    final order = Order(
      id: orderData['id'],
      items: orderData['items'],
      total: orderData['total'],
      date: DateTime.parse(orderData['date']),
      status: orderData['status'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${order.id}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _StatusSection(status: order.status, date: order.date),
          const SizedBox(height: 24),
          _ItemsSection(items: order.items),
          const SizedBox(height: 24),
          _TotalSection(total: order.total),
        ],
      ),
    );
  }
}

class _StatusSection extends StatelessWidget {
  const _StatusSection({required this.status, required this.date});

  final String status;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Estado actual', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _StatusBadge(status: status),
          const SizedBox(height: 12),
          Text(
            'Actualizado el ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} a las ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = _statusColor(status, colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
      ),
    );
  }

  Color _statusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'entregado':
        return colorScheme.secondary;
      case 'en camino':
        return colorScheme.tertiary;
      default:
        return colorScheme.primary;
    }
  }
}

class _ItemsSection extends StatelessWidget {
  const _ItemsSection({required this.items});

  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detalle del pedido', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${item['quantity']}x',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item['product']['name'],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Text(
                    '\$${(item['product']['price'] * item['quantity']).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalSection extends StatelessWidget {
  const _TotalSection({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Text('Total'),
          const Spacer(),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
