import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/providers/auth_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Cuenta'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              // context.go('/account/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Mis Tarjetas'),
            onTap: () {
              // context.go('/account/cards');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
