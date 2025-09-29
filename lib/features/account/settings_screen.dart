import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferencias'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _ThemeSection(),
          SizedBox(height: 24),
          _NotificationsSection(),
          SizedBox(height: 24),
          _PrivacySection(),
        ],
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return _SettingsCard(
      title: 'Apariencia',
      subtitle: 'Elegí cómo se adapta YaComer a tus preferencias visuales.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('Sistema'), icon: Icon(Icons.auto_mode_rounded)),
              ButtonSegment(value: ThemeMode.light, label: Text('Claro'), icon: Icon(Icons.wb_sunny_outlined)),
              ButtonSegment(value: ThemeMode.dark, label: Text('Oscuro'), icon: Icon(Icons.dark_mode_outlined)),
            ],
            selected: {themeProvider.themeMode},
            onSelectionChanged: (value) {
              final mode = value.first;
              themeProvider.setTheme(mode);
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Podés cambiar la apariencia en cualquier momento. Usamos colores cálidos que resaltan la identidad gastronómica de cada local.',
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

class _NotificationsSection extends StatefulWidget {
  const _NotificationsSection();

  @override
  State<_NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<_NotificationsSection> {
  bool _orderUpdates = true;
  bool _promotions = false;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Notificaciones',
      subtitle: 'Personalizá qué mensajes querés recibir.',
      child: Column(
        children: [
          SwitchListTile.adaptive(
            value: _orderUpdates,
            onChanged: (value) => setState(() => _orderUpdates = value),
            title: const Text('Actualizaciones de pedidos'),
            subtitle: const Text('Te avisamos cuando el local acepta, prepara y entrega.'),
          ),
          SwitchListTile.adaptive(
            value: _promotions,
            onChanged: (value) => setState(() => _promotions = value),
            title: const Text('Promociones de locales'),
            subtitle: const Text('Descuentos especiales y menús del día de tus favoritos.'),
          ),
        ],
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection();

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      title: 'Privacidad y datos',
      subtitle: 'Gestioná la información que compartís con los locales.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.download_rounded),
            title: const Text('Descargar historial de pedidos'),
            subtitle: const Text('Recibí un resumen de tus transacciones en tu correo.'),
            trailing: FilledButton.tonal(
              onPressed: () {},
              child: const Text('Solicitar'),
            ),
          ),
          const Divider(height: 32),
          Text(
            'YaComer solo comparte con el local los datos indispensables para concretar tu pedido. Todo pago se realiza directamente con el comercio.',
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

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
